import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String suggestion; // Feature #3: Suggest solutions!

  const Failure({required this.message, required this.suggestion});

  @override
  List<Object> get props => [message, suggestion];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server Hiccup! 🤒',
    super.suggestion = 'Our servers are taking a nap. Please try again later.',
  });
}

class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message = 'No Internet Connection 📡',
    super.suggestion = 'Check your WiFi or data. But good news: You can still work offline!',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Storage Error 💾',
    super.suggestion = 'We couldn\'t save that locally. Is your device storage full?',
  });
}

class InputFailure extends Failure {
  const InputFailure(String message)
      : super(
          message: message,
          suggestion: 'Double-check your input and try again.',
        );
}
