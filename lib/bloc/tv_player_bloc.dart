import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/channel.dart';
import 'tv_player_event.dart';
import 'tv_player_state.dart';

class TvPlayerBloc extends Bloc<TvPlayerEvent, TvPlayerState> {
  TvPlayerBloc() : super(const TvPlayerState()) {
    on<LoadChannelsEvent>(_onLoadChannels);
    on<SelectChannelEvent>(_onSelectChannel);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<NavigateChannelEvent>(_onNavigateChannel);
    on<ToggleFullscreenEvent>(_onToggleFullscreen);
    on<ReloadStreamEvent>(_onReloadStream);
  }

  Future<void> _onLoadChannels(
    LoadChannelsEvent event,
    Emitter<TvPlayerState> emit,
  ) async {
    emit(state.copyWith(status: TvPlayerStatus.loading));

    try {
      final jsonString = await rootBundle.loadString('assets/channels.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final categories = (jsonData['categories'] as List<dynamic>)
          .map((e) => ChannelCategory.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(
        status: TvPlayerStatus.loaded,
        categories: categories,
        currentCategoryIndex: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TvPlayerStatus.error,
        errorMessage: 'Failed to load channels: $e',
      ));
    }
  }

  void _onSelectChannel(
    SelectChannelEvent event,
    Emitter<TvPlayerState> emit,
  ) {
    emit(state.copyWith(
      status: TvPlayerStatus.playing,
      currentChannel: event.channel,
    ));
  }

  void _onChangeCategory(
    ChangeCategoryEvent event,
    Emitter<TvPlayerState> emit,
  ) {
    if (event.categoryIndex >= 0 &&
        event.categoryIndex < state.categories.length) {
      emit(state.copyWith(currentCategoryIndex: event.categoryIndex));
    }
  }

  void _onNavigateChannel(
    NavigateChannelEvent event,
    Emitter<TvPlayerState> emit,
  ) {
    final channels = state.currentChannels;
    if (channels.isEmpty) return;

    final currentIndex = state.currentChannel != null
        ? channels.indexWhere((c) => c.id == state.currentChannel!.id)
        : -1;

    int newIndex;
    if (currentIndex == -1) {
      newIndex = 0;
    } else {
      newIndex = currentIndex + event.direction;
      if (newIndex < 0) newIndex = channels.length - 1;
      if (newIndex >= channels.length) newIndex = 0;
    }

    emit(state.copyWith(
      status: TvPlayerStatus.playing,
      currentChannel: channels[newIndex],
    ));
  }

  void _onToggleFullscreen(
    ToggleFullscreenEvent event,
    Emitter<TvPlayerState> emit,
  ) {
    emit(state.copyWith(isFullscreen: !state.isFullscreen));
  }

  void _onReloadStream(
    ReloadStreamEvent event,
    Emitter<TvPlayerState> emit,
  ) {
    if (state.currentChannel != null) {
      emit(state.copyWith(status: TvPlayerStatus.playing));
    }
  }
}
