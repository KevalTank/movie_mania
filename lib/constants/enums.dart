// This is general status that all bloc will use
enum Status { initial, inProgress, success, failure }

// This is general status for authentication
enum AuthStatus { initial, inProgress, authenticated, unAuthenticated }

// Helper extension for status
extension StatusExtension on Status {
  bool get isInitial => this == Status.initial;

  bool get isInProgress => this == Status.inProgress;

  bool get isSuccess => this == Status.success;

  bool get isFailure => this == Status.failure;
}
