
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../model/wallet/transactions.dart';
import '../../viewmodel/wallet/wallet_vm.dart';
import '../common.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 HEADER
                  Text(
                    "My Wallet",
                    style: AppTextStyles.h2,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 💰 BALANCE CARD
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

                        Text(
                          "Available Balance",
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "₹${vm.wallet?.currentBalance}",
                          style: AppTextStyles.h1
                              .copyWith(color: Colors.white),
                        ),

                        SizedBox(height: 12),

                        Row(
                          children: [

                            // 💸 WITHDRAW BUTTON
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  MainNavigationView.changeTab(context, 3);
                                },
                                child: Text(
                                  "Withdraw",
                                  style: AppTextStyles.buttonMedium
                                      .copyWith(color: AppColors.primary),
                                ),
                              ),
                            ),

                            SizedBox(width: AppSpacing.md),

                            // 💬 CHAT BUTTON
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  MainNavigationView.changeTab(context, 1);
                                },
                                child: Text("Earn More 💬"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 📊 TOTAL EARNINGS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Earnings", style: AppTextStyles.h3),
                      Text(
                        "₹${vm.wallet?.totalEarning}",
                        style: AppTextStyles.h3
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.md),

                  // 📜 TRANSACTIONS TITLE
                  Text("Recent Activity", style: AppTextStyles.h3),

                  SizedBox(height: AppSpacing.md),

                  // 🔥 TRANSACTION LIST
                  Expanded(
                    child: vm.transactions.isEmpty
                        ? Center(
                      child: Text("No transactions yet"),
                    )
                        : ListView.builder(
                      itemCount: vm.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = vm.transactions[
                        vm.transactions.length - 1 - index];

                        return _TransactionTile(tx: tx);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel tx;

  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          // ICON
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tx.type == 'earn'
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              tx.type == 'earn' ? Icons.arrow_downward : Icons.arrow_upward,
              color: tx.type == 'earn' ? AppColors.success : AppColors.error,
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.source, style: AppTextStyles.bodyMedium),
                SizedBox(height: 4),
                Text(
                  "Just now", // 👉 later add real date
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),

          // AMOUNT
          Text(
            tx.type == 'earn' ? "+₹${tx.amount}" : "-₹${tx.amount}",
            style: AppTextStyles.labelLarge.copyWith(
              color:
              tx.type == 'earn' ? AppColors.success : AppColors.error,
            ),
          )
        ],
      ),
    );
  }
}