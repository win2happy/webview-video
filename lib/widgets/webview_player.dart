import 'package:flutter/material.dart';
import 'package:in_app_webview/in_app_webview.dart';
import '../models/channel.dart';

class WebViewPlayer extends StatefulWidget {
  final Channel channel;
  final VoidCallback? onExitFullscreen;
  final VoidCallback? onError;

  const WebViewPlayer({
    super.key,
    required this.channel,
    this.onExitFullscreen,
    this.onError,
  });

  @override
  State<WebViewPlayer> createState() => _WebViewPlayerState();
}

class _WebViewPlayerState extends State<WebViewPlayer> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;
  double _loadProgress = 0;

  @override
  void dispose() {
    _webViewController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadError(InAppWebViewController controller, WebResourceError error) async {
    widget.onError?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.channel.url),
                ),
                initialSettings: InAppWebViewSettings(
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  supportZoom: true,
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  cacheEnabled: true,
                  clearCache: false,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                    _loadProgress = 0;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onLoadError: _handleLoadError,
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _loadProgress = progress / 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
              ),
              if (_isLoading)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(value: _loadProgress > 0 ? _loadProgress : null),
                      const SizedBox(height: 16),
                      Text(
                        'Loading: ${(_loadProgress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.white70),
                  onPressed: widget.onExitFullscreen,
                  tooltip: 'Exit Fullscreen',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
