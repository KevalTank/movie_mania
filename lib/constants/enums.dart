// This is general status that all bloc will use
enum Status { initial, inProgress, success, failure }

// This is TabBar status
enum TabBarStatus { popular, topRated, upcoming }

// Helper extension for Status
extension StatusExtension on Status {
  bool get isInitial => this == Status.initial;

  bool get isInProgress => this == Status.inProgress;

  bool get isSuccess => this == Status.success;

  bool get isFailure => this == Status.failure;
}

// TabBar extension on TabBarStatus
extension TabBarExtension on TabBarStatus {
  bool get popular => this == TabBarStatus.popular;

  bool get topRated => this == TabBarStatus.topRated;

  bool get upcoming => this == TabBarStatus.upcoming;
}
