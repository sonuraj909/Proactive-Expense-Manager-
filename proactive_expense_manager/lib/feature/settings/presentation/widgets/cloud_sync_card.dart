import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:proactive_expense_manager/core/theme/app_colors.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_bloc.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_event.dart';
import 'package:proactive_expense_manager/feature/sync/presentation/bloc/sync_state.dart';
import 'package:proactive_expense_manager/gen/assets.gen.dart';

class CloudSyncCard extends StatelessWidget {
  const CloudSyncCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) {
        if (state is SyncCompleted) {
          final message = state.totalSynced == 0
              ? 'Everything is already up to date!'
              : 'Sync completed! ${state.totalSynced} item${state.totalSynced == 1 ? '' : 's'} synced.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        } else if (state is SyncFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sync failed: ${state.message}'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final syncState = state is SyncInProgress ? state : null;
        final isSyncing = syncState != null;
        final syncMessage = syncState?.message ?? 'Sync and update data to the backend';
        return GestureDetector(
          onTap: isSyncing
              ? null
              : () =>
                  context.read<SyncBloc>().add(const StartSyncEvent()),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C59),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    spacing: 4.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSyncing ? 'Syncing...' : 'Sync To Cloud',
                        style: tt.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(syncMessage, style: tt.bodySmall),
                    ],
                  ),
                ),
                isSyncing
                    ? LoadingAnimationWidget.waveDots(
                        color: AppColors.textPrimary,
                        size: 30.sp,
                      )
                    : Assets.images.cloudUpload.image(
                        width: 21.w,
                        height: 18.w,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
