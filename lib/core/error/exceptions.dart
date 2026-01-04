/// Thrown when the device has no internet connection.
class OfflineException implements Exception {}

/// Thrown when the server returns a 500 or 404.
class ServerException implements Exception {
  final String message;
  final int statusCode;
  ServerException({required this.message, this.statusCode = 500});
}

/// Thrown when the local database (Hive) fails.
class CacheException implements Exception {}

/// Thrown when the user does something silly (like entering "banana" as an age).
class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);
}
