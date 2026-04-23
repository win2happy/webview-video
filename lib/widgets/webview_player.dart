import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  double _loadProgress = 0;

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
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
                onReceivedError: (controller, request, error) {
                  widget.onError?.call();
                },
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
