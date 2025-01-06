import 'package:flutter/material.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/loader.dart';

class DropdownMenuBuilder {
  static Widget buildLoadingState() {
    return const FractionallySizedBox(
      heightFactor: 0.7,
      child: Center(
        child: Loader(),
      ),
    );
  }

  static Widget buildEmptyState() {
    return const SizedBox();
  }
}
