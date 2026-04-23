import 'package:equatable/equatable.dart';

class Channel extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String url;

  const Channel({
    required this.id,
    required this.name,
    required this.logo,
    required this.url,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [id, name, logo, url];
}

class ChannelCategory extends Equatable {
  final String name;
  final List<Channel> channels;

  const ChannelCategory({
    required this.name,
    required this.channels,
  });

  factory ChannelCategory.fromJson(Map<String, dynamic> json) {
    return ChannelCategory(
      name: json['name'] as String? ?? '',
      channels: (json['channels'] as List<dynamic>?)
              ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [name, channels];
}
