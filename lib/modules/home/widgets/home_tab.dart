import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => Text(
                              'Bonjour, ${auth.currentUser.value?.firstName ?? 'Citoyen'} 👋',
                              style: AppTextStyles.headlineSmall
                                  .copyWith(color: Colors.white),
                            )),
                        const SizedBox(height: 4),
                        Text(
                          'Que souhaitez-vous faire aujourd\'hui ?',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(() => CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Text(
                      auth.currentUser.value?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  )),
              const SizedBox(width: 12),
            ],
          ),
          // ─── Quick Actions ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Services rapides', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _QuickActionCard(
                        icon: Icons.description_rounded,
                        label: 'Demande\nadministrative',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                        onTap: () => Get.toNamed(AppRoutes.createRequest),
                      ),
                      _QuickActionCard(
                        icon: Icons.report_rounded,
                        label: 'Signaler une\nréclamation',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                        ),
                        onTap: () => Get.toNamed(AppRoutes.createComplaint),
                      ),
                      _QuickActionCard(
                        icon: Icons.find_in_page_rounded,
                        label: 'Document\nperdu',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        onTap: () => Get.toNamed(AppRoutes.createMissingDoc),
                      ),
                      _QuickActionCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scanner\nQR Code',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        ),
                        onTap: () => Get.toNamed(AppRoutes.qrScan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ─── Recent Banner ──────────────────────
                  Text('Mes dernières demandes',
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: 16),
                  _RecentBanner(
                    onTap: () => Get.toNamed(AppRoutes.requestsList),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _RecentBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.darkBorder)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.list_alt_rounded,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voir mes demandes', style: AppTextStyles.titleSmall),
                  Text('Suivez l\'état de vos dossiers',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.grey500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.grey500),
          ],
        ),
      ),
    );
  }
}
