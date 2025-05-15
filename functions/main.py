# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app, messaging

initialize_app()
#
#
@https_fn.on_request()
def send_push_to_token(req: https_fn.Request) -> https_fn.Response:
    data = req.json or {}
    token = data.get("token")
    if not token:
        return https_fn.Response("token is required", status=400)

    message = messaging.Message(
        notification=messaging.Notification(
            title=data.get("title", "알림"),
            body=data.get("body", "내용")
        ),
        data=data.get("data", {}),
        token=token,
    )
    try:
        message_id = messaging.send(message)
        return https_fn.Response({"success": True, "messageId": message_id})
    except Exception as e:
        return https_fn.Response({"error": str(e)}, status=500)