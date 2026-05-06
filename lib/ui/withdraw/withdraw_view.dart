import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodel/wallet/wallet_vm.dart';

class WithdrawView extends StatefulWidget {
  const WithdrawView({super.key});

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  final TextEditingController amountController = TextEditingController();

  String selectedMethod = "UPI";

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

                  // 🔙 BACK
                  Row(
                    children: [
                      Text("Withdraw", style: AppTextStyles.h2),
                    ],
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
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 💸 ENTER AMOUNT
                  Text("Enter Amount", style: AppTextStyles.h3),
                  SizedBox(height: AppSpacing.sm),

                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Minimum ₹50",
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 💳 PAYMENT METHOD
                  Text("Select Method", style: AppTextStyles.h3),
                  SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _methodCard("UPI", selectedMethod),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _methodCard("Bank", selectedMethod),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 🚀 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount =
                            int.tryParse(amountController.text) ?? 0;

                        if (amount < 50) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Minimum ₹50 required")),
                          );
                          return;
                        }

                        if (amount > vm.wallet!.currentBalance) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Insufficient balance")),
                          );
                          return;
                        }

                        // await vm.requestWithdraw(
                        //   amount: amount,
                        //   method: selectedMethod,
                        // );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Withdraw request sent")),
                        );

                        amountController.clear();
                      },
                      child: Text("Withdraw Now 💸"),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 💳 METHOD CARD
  Widget _methodCard(String method, String current) {
    final isSelected = method == current;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Center(
          child: Text(method, style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }
}