import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/missing_docs_controller.dart';

class MissingDocsListView extends GetView<MissingDocsController> {
  const MissingDocsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents Perdus', style: AppTextStyles.titleLarge.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: controller.fetchAll),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).cardTheme.color ?? Colors.grey[300]!,
            highlightColor: Theme.of(context).dividerColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }
        if (controller.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.find_in_page_rounded,
                    size: 72, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                const SizedBox(height: 16),
                Text('Aucun document signalé', style: AppTextStyles.titleMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.createMissingDoc),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Signaler un document'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAll,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final doc = controller.docs[i];
              final statusColor = StatusUtils.missingDocStatusColor(doc.status);
              final statusLabel = StatusUtils.missingDocStatusLabel(doc.status);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    controller.selectedDoc.value = doc;
                    Get.toNamed(AppRoutes.missingDocDetail,
                        arguments: {'id': doc.id});
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: doc.photoUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: doc.photoUrl!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 64,
                                    height: 64,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  errorWidget: (_, __, ___) => _DocIcon(),
                                )
                              : _DocIcon(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.title,
                                  style: AppTextStyles.titleSmall.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              if (doc.lastSeenLocation != null)
                                Row(children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(doc.lastSeenLocation!,
                                        style: AppTextStyles.bodySmall.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ]),
                              const SizedBox(height: 6),
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(statusLabel,
                                      style: AppTextStyles.labelSmall.copyWith(
                                          color: statusColor, fontSize: 10)),
                                ),
                                const Spacer(),
                                if (doc.isVerified)
                                  const Icon(Icons.verified_rounded,
                                      size: 14, color: AppColors.info),
                              ]),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), size: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _DocIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.find_in_page_rounded,
          color: AppColors.error, size: 28),
    );
  }
}
