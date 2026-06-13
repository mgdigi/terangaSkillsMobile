import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/requests_controller.dart';

class RequestsListView extends GetView<RequestsController> {
  const RequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Demandes', style: AppTextStyles.titleLarge.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchMyRequests,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildShimmer(context);
        if (controller.requests.isEmpty) return _buildEmpty(context);
        return RefreshIndicator(
          onRefresh: controller.fetchMyRequests,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final req = controller.requests[i];
              return _RequestCard(
                type: StatusUtils.requestTypeLabel(req.type),
                title: req.title,
                status: req.status,
                date: req.createdAt,
                onTap: () {
                  controller.selectedRequest.value = req;
                  Get.toNamed(AppRoutes.requestDetail,
                      arguments: {'id': req.id});
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardTheme.color ?? Colors.grey[300]!,
      highlightColor: Theme.of(context).dividerColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: 90,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded,
              size: 72, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('Aucune demande', style: AppTextStyles.titleMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('Soumettez votre première demande !',
              style: AppTextStyles.bodySmall
                  .copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.createRequest),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nouvelle demande'),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String type;
  final String title;
  final String status;
  final DateTime date;
  final VoidCallback onTap;

  const _RequestCard({
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = StatusUtils.requestStatusColor(status);
    final statusLabel = StatusUtils.requestStatusLabel(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_rounded,
                    color: AppColors.info, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 2),
                    Text(title,
                        style: AppTextStyles.titleSmall.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppTextStyles.labelSmall
                                .copyWith(color: statusColor, fontSize: 10),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
