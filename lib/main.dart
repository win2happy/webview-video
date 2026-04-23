import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/tv_player_bloc.dart';
import 'pages/tv_player_page.dart';

void main() {
  runApp(const WebViewTvPlayerApp());
}

class WebViewTvPlayerApp extends StatelessWidget {
  const WebViewTvPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView TV Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => TvPlayerBloc(),
        child: const TvPlayerPage(),
      ),
    );
  }
}
