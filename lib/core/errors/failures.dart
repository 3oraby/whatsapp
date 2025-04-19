class Failure {
  final String? message;

  const Failure({this.message});
}

class CustomException extends Failure {
  const CustomException({required super.message});
}

class UnAuthorizedException extends Failure {}