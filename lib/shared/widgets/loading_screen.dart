import 'package:flutter/material.dart';
import 'package:solarsense/shared/widgets/loading_indicator.dart';

import '../services/app_controller.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: AppController.to.state.loadingWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.4),
        body: const Center(
          child: LoadingIndicator(),
        ),
      ),
    );
  }
}
