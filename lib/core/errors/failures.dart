abstract class Failure {
  Failure({required this.msg});

  final String msg;
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(msg: message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(msg: message);
}
