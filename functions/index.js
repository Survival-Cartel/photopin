const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.sendFcm = functions.https.onRequest(async (req, res) => {
  // functions.logger.info("Hello logs!", {structuredData: true});
  const message = {
    token: req.body.token,
    data: {
      title: req.body.title,
      body: req.body.body,
    },
    apns: {
      headers: {
        "apns-priority": "5",
        "apns-push-type": "background",
      },
      payload: {
        aps: {
          "content-available": 1,
        },
      },
    },
  };

  admin
    .messaging()
    .send(message)
    .then((response) => {
      console.log("Successful send message : ", response);
    })
    .catch((error) => {
      console.log("Error send message : ", error);
    });

  res.status(200).send();
});
