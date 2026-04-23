import 'package:equatable/equatable.dart';
import '../models/channel.dart';

abstract class TvPlayerEvent extends Equatable {
  const TvPlayerEvent();

  @override
  List<Object?> get props => [];
}

class LoadChannelsEvent extends TvPlayerEvent {
  const LoadChannelsEvent();
}

class SelectChannelEvent extends TvPlayerEvent {
  final Channel channel;

  const SelectChannelEvent(this.channel);

  @override
  List<Object?> get props => [channel];
}

class ChangeCategoryEvent extends TvPlayerEvent {
  final int categoryIndex;

  const ChangeCategoryEvent(this.categoryIndex);

  @override
  List<Object?> get props => [categoryIndex];
}

class NavigateChannelEvent extends TvPlayerEvent {
  final int direction;

  const NavigateChannelEvent(this.direction);

  @override
  List<Object?> get props => [direction];
}

class ToggleFullscreenEvent extends TvPlayerEvent {
  const ToggleFullscreenEvent();
}

class ReloadStreamEvent extends TvPlayerEvent {
  const ReloadStreamEvent();
}
