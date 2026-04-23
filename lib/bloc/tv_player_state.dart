import 'package:equatable/equatable.dart';
import '../models/channel.dart';

enum TvPlayerStatus { initial, loading, loaded, error, playing }

class TvPlayerState extends Equatable {
  final TvPlayerStatus status;
  final List<ChannelCategory> categories;
  final int currentCategoryIndex;
  final Channel? currentChannel;
  final bool isFullscreen;
  final String? errorMessage;

  const TvPlayerState({
    this.status = TvPlayerStatus.initial,
    this.categories = const [],
    this.currentCategoryIndex = 0,
    this.currentChannel,
    this.isFullscreen = false,
    this.errorMessage,
  });

  List<Channel> get currentChannels {
    if (categories.isEmpty || currentCategoryIndex >= categories.length) {
      return [];
    }
    return categories[currentCategoryIndex].channels;
  }

  String get currentCategoryName {
    if (categories.isEmpty || currentCategoryIndex >= categories.length) {
      return '';
    }
    return categories[currentCategoryIndex].name;
  }

  TvPlayerState copyWith({
    TvPlayerStatus? status,
    List<ChannelCategory>? categories,
    int? currentCategoryIndex,
    Channel? currentChannel,
    bool? isFullscreen,
    String? errorMessage,
  }) {
    return TvPlayerState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      currentCategoryIndex: currentCategoryIndex ?? this.currentCategoryIndex,
      currentChannel: currentChannel ?? this.currentChannel,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        currentCategoryIndex,
        currentChannel,
        isFullscreen,
        errorMessage,
      ];
}
