sealed class AuthAction {
  factory AuthAction.login() = Login;
  factory AuthAction.logout() = Logout;
  factory AuthAction.onClick() = OnClick;
}

class Login implements AuthAction {}

class Logout implements AuthAction {}

class OnClick implements AuthAction {}
