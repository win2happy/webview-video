import 'package:flutter/material.dart';
import '../models/channel.dart';

class ChannelListWidget extends StatelessWidget {
  final List<Channel> channels;
  final Channel? currentChannel;
  final ValueChanged<Channel> onChannelSelected;

  const ChannelListWidget({
    super.key,
    required this.channels,
    this.currentChannel,
    required this.onChannelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        final isSelected = currentChannel?.id == channel.id;

        return ListTile(
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          leading: CircleAvatar(
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text(
              channel.name.substring(0, 1),
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          title: Text(
            channel.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            channel.id,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () => onChannelSelected(channel),
        );
      },
    );
  }
}
