part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.initial,
    this.errorMessage = '',
    this.isGridView = true,
    this.tabBarStatus = TabBarStatus.popular,
  });

  final Status status;
  final String errorMessage;
  final bool isGridView;
  final TabBarStatus tabBarStatus;

  HomeState copyWith({
    Status? status,
    String? errorMessage,
    bool? isGridView,
    TabBarStatus? tabBarStatus,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isGridView: isGridView ?? this.isGridView,
      tabBarStatus: tabBarStatus ?? this.tabBarStatus,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage,
        isGridView,
        tabBarStatus,
      ];
}
