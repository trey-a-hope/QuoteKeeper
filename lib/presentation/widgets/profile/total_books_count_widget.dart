import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:quote_keeper/presentation/widgets/profile/profile_stat_badget_widget.dart';
import 'package:quote_keeper/utils/config/providers.dart';

class TotalBooksCountWidget extends ConsumerWidget {
  const TotalBooksCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var totalBooksCount =
        ref.watch(Providers.totalBooksCountAsyncNotifierProvider);

    return totalBooksCount.when(
      data: (data) =>
          ProfileStatBadgetWidget(count: data, label: 'Total Books'),
      error: (err, stack) => Center(child: Text(err.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}