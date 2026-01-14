import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController _controllerWebView;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controllerWebView = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    )
    ..loadRequest(
      Uri.parse(
        'https://www.bagaer.com.br/política-de-privacidade',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(color: Colors.white),
            ),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            opacity: _isLoading ? 0 : 1,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              offset: _isLoading ? const Offset(0, 0) : Offset.zero,
              child: WebViewWidget(
                controller: _controllerWebView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}