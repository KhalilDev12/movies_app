import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/Models/configModel.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildUI();
  }

  Widget _buildUI() {
    final getIt = GetIt.instance;
    ConfigModel model = getIt.get();
    return Scaffold(
      appBar: AppBar(title: Text(model.BASE_API_URL)),
    );
  }
}
