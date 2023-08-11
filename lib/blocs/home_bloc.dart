import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/constants/enums.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ChangeGridViewToListViewRequested>(_onChangeGridViewToListViewRequested);
    on<ChangeTabBarStatusRequested>(_onChangeTabBarStatusRequested);
  }

  FutureOr<void> _onChangeGridViewToListViewRequested(
    ChangeGridViewToListViewRequested event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isGridView: event.isGridView));
  }

  FutureOr<void> _onChangeTabBarStatusRequested(
    ChangeTabBarStatusRequested event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(tabBarStatus: event.tabBarStatus));
  }
}
