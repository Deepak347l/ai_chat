import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodel/user/users_vm.dart';
import '../../viewmodel/wallet/wallet_vm.dart';
import '../common.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final walletVM = context.watch<WalletViewModel>();
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  MODERN APP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome 👋",
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondaryLight)),
                      SizedBox(height: 4),

                      Text(vm.currentUser?.name ?? "User",
                          style: AppTextStyles.h3.copyWith(
                              color: AppColors.textPrimaryLight)),
                    ],
                  ),

                  Row(
                    children: [
                      //  COINS
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on,
                                size: 16, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text("${walletVM.wallet?.currentBalance ?? 0}",
                                style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary)),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      // 👤 PROFILE
                      vm.currentUser?.photoUrl != null ? CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(vm.currentUser!.photoUrl!),
                      ): vm.currentUser?.photoUrl == null ? CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.person, color: Colors.white),
                      ): const SizedBox.shrink(),
                    ],
                  )
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              //  TOTAL EARNINGS CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Earnings",
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                    SizedBox(height: 8),
                    Text("₹ ${walletVM.wallet?.totalEarning ?? 0}",
                        style: AppTextStyles.h2
                            .copyWith(color: Colors.white)),
                    SizedBox(height: 12),
                    Text("+12% this week",
                        style: AppTextStyles.labelMedium
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              //  QUICK ACTIONS
              Text("Quick Actions", style:TextStyle(
                color: AppColors.backgroundDark
              )),
              SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.chat,
                      title: "New Chat",
                      color: AppColors.primary,
                      onTap: () {
                        MainNavigationView.changeTab(context, 1); // CHAT TAB
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _actionCard(
                      icon: Icons.group,
                      title: "Invite",
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //  RECENT ACTIVITY
              Text("Recent Activity", style: TextStyle(
                color: AppColors.backgroundDark
              ),),
              SizedBox(height: AppSpacing.md),

              Expanded(
                child:
                    walletVM.transactions.isEmpty ? const Center(
                      child: Text("No transactions yet",style: TextStyle(
                        color: AppColors.error
                      ),),
                    ):
                    ListView.builder(
                      itemCount: walletVM.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = walletVM.transactions[index];

                        return _ActivityTile(
                          title: tx.source,
                          amount: tx.type == 'earn'
                              ? "+₹${tx.amount}"
                              : "-₹${tx.amount}",
                        );
                      },
                    )
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 ACTION CARD WIDGET
class _actionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const _actionCard({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: AppSpacing.sm),
            Text(title,
                style: AppTextStyles.labelLarge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// 🔹 ACTIVITY TILE
class _ActivityTile extends StatelessWidget {
  final String title;
  final String amount;

  const _ActivityTile({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: Text(amount,
          style: AppTextStyles.labelLarge.copyWith(
            color: amount.startsWith('+')
                ? AppColors.success
                : AppColors.error,
          )),
    );
  }
}
