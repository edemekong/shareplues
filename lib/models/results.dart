class HandleSuccess<T> {
  final T data;
  final String? message;
  const HandleSuccess(this.data, [this.message]);
}

class HandleError implements Exception {
  final String message;
  final String? code;

  const HandleError(this.message, {this.code});

  String get getTitle {
    switch (code) {
      case "invalid-email":
        return "Invalid Email";
      case "wrong-password":
        return "Incorrect Password";

      case "weak-password":
        return "Week Password";

      case "user-not-found":
        return "Email Not Found";

      case "user-disabled":
        return "Disabled Account";

      case "too-many-requests":
        return "Block Request";

      case "operation-not-allowed":
        return "Operation Blocked";

      case "email-already-exists":
        return "Email Exists";

      case "invalid-action-code":
        return "Session Expired";
      case "cancelled":
        return "Login Cancelled";
      case "username-not-found":
        return "Username Not Found";
      default:
        return "An Error Occured";
    }
  }

  String get getMessage {
    String error = message;

    switch (code) {
      case "invalid-email":
        error = "Invalid email or does not match.";
        break;
      case "wrong-password":
        error = "The password you entered is wrong. Please Try again.";
        break;
      case "weak-password":
        error = "Weak password, add symbols to make it stronger";
        break;
      case "user-not-found":
        error = "The Email you entered does not exist. Please, Try again.";
        break;
      case "user-disabled":
        error = "Your account has been disabled.";
        break;
      case "too-many-requests":
        error = "Too many request, we block you for sometime.";
        break;
      case "operation-not-allowed":
        error = "Auth is not enabled";
        break;
      case "email-already-exists":
        error = "Email already registered.";
        break;
      case "invalid-action-code":
        error = "Sign in link has expired, or has already been used";
        break;

      case "cancelled":
        error = "Login with Facebook cancelled. Please, Try again.";
        break;

      case "username-not-found":
        return "The username you entered does not exist. Please, Try again.";
    }

    return error;
  }
}
