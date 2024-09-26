class AppException implements Exception {
  final String message;
  final String prefix;

  AppException({required this.message, required this.prefix});

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message)
      : super(message: message, prefix: "Error During Communication: ");
}

class BadRequestException extends AppException {
  // In this class we will add more checks on the code returned from API, and return the correct message on each case
  BadRequestException(String message)
      : super(message: getErrorMessage(message), prefix: "");

  static getErrorMessage(dynamic message) {
    return message;
  }
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message])
      : super(
            message: "Looks like your sessions is expired, please login again",
            prefix: "");
}

class UserNotFoundException extends AppException {
  UserNotFoundException(String message)
      : super(message: "Username does not exist", prefix: "");
}

class InternalServerException extends AppException {
  InternalServerException([message])
      : super(
            message:
                "Ops Looks like there is an error with our servers, Please try gain later",
            prefix: "");
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException(String message)
      : super(
            message: "Failed to complete your operation, Please try again",
            prefix: "");
}

class IncorrectUsernameOrPassword extends AppException {
  IncorrectUsernameOrPassword([message])
      : super(message: message.toString(), prefix: "");
}
