part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeGridViewToListViewRequested extends HomeEvent {
  const ChangeGridViewToListViewRequested({
    required this.isGridView,
  });

  final bool isGridView;
}

class ChangeTabBarStatusRequested extends HomeEvent {
  const ChangeTabBarStatusRequested({
    required this.tabBarStatus,
  });

  final TabBarStatus tabBarStatus;
}
