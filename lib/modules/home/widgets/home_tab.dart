import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';
import '../../missing_docs/controller/missing_docs_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final homeCtrl = Get.find<HomeController>();
    // Use find (registered in HomeBinding) to avoid re-registration on rebuild
    final missingDocsCtrl = Get.find<MissingDocsController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar Premium ──────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          final name = auth.currentUser.value?.firstName ?? '';
                          return Text(
                            'Bonjour, ${name.isNotEmpty ? name : 'Citoyen'} 👋',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          );
                        }),
                        const SizedBox(height: 6),
                        Text(
                          'Que souhaitez-vous faire aujourd\'hui ?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(() => IconButton(
                    icon: Icon(
                      homeCtrl.isDarkMode.value
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: homeCtrl.toggleTheme,
                  )),
              const SizedBox(width: 8),
              Obx(() {
                final name = auth.currentUser.value?.firstName ?? '';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        auth.logout();
                      }
                    },
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).cardTheme.color,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${auth.currentUser.value?.firstName ?? ''} ${auth.currentUser.value?.lastName ?? ''}',
                              style: AppTextStyles.titleSmall.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            Text(
                              auth.currentUser.value?.email ?? '',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Se déconnecter',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          // ─── Quick Actions Premium ─────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services rapides',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _PremiumActionCard(
                        icon: Icons.description_outlined,
                        label: 'Demande\nadministrative',
                        iconColor: const Color(0xFF60A5FA), // Soft Blue
                        onTap: () => Get.toNamed(AppRoutes.createRequest),
                      ),
                      _PremiumActionCard(
                        icon: Icons.report_outlined,
                        label: 'Signaler une\nréclamation',
                        iconColor: const Color(0xFFF87171), // Soft Red
                        onTap: () => Get.toNamed(AppRoutes.createComplaint),
                      ),
                      _PremiumActionCard(
                        icon: Icons.find_in_page_outlined,
                        label: 'Document\nperdu',
                        iconColor: const Color(0xFF34D399), // Soft Green
                        onTap: () => Get.toNamed(AppRoutes.createMissingDoc),
                      ),
                      _PremiumActionCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scanner\nQR Code',
                        iconColor: const Color(0xFFA78BFA), // Soft Purple
                        onTap: () => Get.toNamed(AppRoutes.qrScan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // ─── Missing Documents Carousel ────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Documents Perdus/Trouvés',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => homeCtrl.changeTab(3),
                        child: Text(
                          'Voir tout',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: Obx(() {
                      if (missingDocsCtrl.isLoading.value && missingDocsCtrl.docs.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (missingDocsCtrl.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'Aucun document signalé récent.',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                          ),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: missingDocsCtrl.docs.length > 5 ? 5 : missingDocsCtrl.docs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final doc = missingDocsCtrl.docs[index];
                          final isMissing = doc.status == 'MISSING';
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.missingDocDetail, arguments: doc);
                            },
                            child: Container(
                              width: 240,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isMissing
                                              ? AppColors.error.withOpacity(0.15)
                                              : AppColors.success.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isMissing ? 'PERDU' : 'TROUVÉ',
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: isMissing ? AppColors.error : AppColors.success,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        timeago.format(doc.createdAt, locale: 'fr'),
                                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    doc.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.labelLarge.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // ─── Recent Banner Premium ─────────────────
                  Text(
                    'Mes dernières demandes',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PremiumRecentBanner(
                    onTap: () => Get.toNamed(AppRoutes.requestsList),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _PremiumActionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: iconColor.withOpacity(0.1),
          highlightColor: iconColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const Spacer(),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumRecentBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumRecentBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            Theme.of(context).cardTheme.color ?? AppColors.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.history_rounded,
                      color: AppColors.primaryLight, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voir mes demandes',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Suivez l\'état de vos dossiers en temps réel',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppColors.grey400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
