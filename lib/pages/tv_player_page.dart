import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_player_bloc.dart';
import '../bloc/tv_player_event.dart';
import '../bloc/tv_player_state.dart';
import '../models/channel.dart';
import '../widgets/webview_player.dart';
import '../widgets/channel_list_widget.dart';
import '../widgets/category_tab_bar.dart';

class TvPlayerPage extends StatefulWidget {
  const TvPlayerPage({super.key});

  @override
  State<TvPlayerPage> createState() => _TvPlayerPageState();
}

class _TvPlayerPageState extends State<TvPlayerPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<TvPlayerBloc>().add(const LoadChannelsEvent());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final bloc = context.read<TvPlayerBloc>();

      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          bloc.add(const NavigateChannelEvent(-1));
          break;
        case LogicalKeyboardKey.arrowDown:
          bloc.add(const NavigateChannelEvent(1));
          break;
        case LogicalKeyboardKey.arrowLeft:
          bloc.add(const NavigateChannelEvent(-1));
          break;
        case LogicalKeyboardKey.arrowRight:
          bloc.add(const NavigateChannelEvent(1));
          break;
        case LogicalKeyboardKey.escape:
        case LogicalKeyboardKey.back:
          if (bloc.state.isFullscreen) {
            bloc.add(const ToggleFullscreenEvent());
          }
          break;
        case LogicalKeyboardKey.f11:
        case LogicalKeyboardKey.enter:
          bloc.add(const ToggleFullscreenEvent());
          break;
        case LogicalKeyboardKey.keyR:
          if (HardwareKeyboard.instance.isControlPressed) {
            bloc.add(const ReloadStreamEvent());
          }
          break;
        default:
          break;
      }
    }
  }

  void _showChannelList() {
    final bloc = context.read<TvPlayerBloc>();
    final state = bloc.state;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Channels - ${state.currentCategoryName}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ChannelListWidget(
                    channels: state.currentChannels,
                    currentChannel: state.currentChannel,
                    onChannelSelected: (channel) {
                      bloc.add(SelectChannelEvent(channel));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        body: BlocBuilder<TvPlayerBloc, TvPlayerState>(
          builder: (context, state) {
            return Column(
              children: [
                if (!state.isFullscreen) _buildHeader(context, state),
                Expanded(
                  child: _buildContent(context, state),
                ),
                if (!state.isFullscreen) _buildBottomBar(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TvPlayerState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(
            Icons.live_tv,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Text(
            'WebView TV Player',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          const Spacer(),
          if (state.currentChannel != null)
            Chip(
              label: Text(
                state.currentChannel!.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, TvPlayerState state) {
    switch (state.status) {
      case TvPlayerStatus.initial:
      case TvPlayerStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading channels...'),
            ],
          ),
        );

      case TvPlayerStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'An error occurred',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<TvPlayerBloc>().add(const LoadChannelsEvent());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );

      case TvPlayerStatus.loaded:
        return _buildChannelSelector(context, state);

      case TvPlayerStatus.playing:
        return _buildPlayer(context, state);
    }
  }

  Widget _buildChannelSelector(BuildContext context, TvPlayerState state) {
    return Column(
      children: [
        if (state.categories.isNotEmpty)
          CategoryTabBar(
            categories: state.categories.map((c) => c.name).toList(),
            selectedIndex: state.currentCategoryIndex,
            onCategoryChanged: (index) {
              context.read<TvPlayerBloc>().add(ChangeCategoryEvent(index));
            },
          ),
        Expanded(
          child: ChannelListWidget(
            channels: state.currentChannels,
            currentChannel: state.currentChannel,
            onChannelSelected: (channel) {
              context.read<TvPlayerBloc>().add(SelectChannelEvent(channel));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayer(BuildContext context, TvPlayerState state) {
    if (state.currentChannel == null) {
      return const Center(child: Text('No channel selected'));
    }

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.black,
            child: WebViewPlayer(
              channel: state.currentChannel!,
              onExitFullscreen: () {
                context.read<TvPlayerBloc>().add(const ToggleFullscreenEvent());
              },
              onError: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading: ${state.currentChannel!.name}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.currentChannel!.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'URL: ${state.currentChannel!.url}',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.list),
                        onPressed: _showChannelList,
                        tooltip: 'Channel List',
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: () {
                          context
                              .read<TvPlayerBloc>()
                              .add(const ToggleFullscreenEvent());
                        },
                        tooltip: 'Fullscreen',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: () {
                          context
                              .read<TvPlayerBloc>()
                              .add(const NavigateChannelEvent(-1));
                        },
                        tooltip: 'Previous Channel',
                      ),
                      const SizedBox(width: 16),
                      IconButton.filled(
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {
                          context
                              .read<TvPlayerBloc>()
                              .add(const NavigateChannelEvent(1));
                        },
                        tooltip: 'Next Channel',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, TvPlayerState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 16),
          const SizedBox(width: 8),
          Text(
            'Use Arrow Keys to switch channels, F11 for fullscreen',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
