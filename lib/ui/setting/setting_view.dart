import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodel/user/users_vm.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
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
                  Text("Settings", style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontSize: 26
                  )),

                  SizedBox(height: AppSpacing.lg),

                  // 👤 PROFILE CARD
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),

                        SizedBox(width: AppSpacing.md),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vm.name ?? "User",
                                style: TextStyle(
                                  color: AppColors.textPrimaryLight,
                                  fontSize: 14
                                )),
                            Text(vm.email ?? "",
                                style: AppTextStyles.bodySmall),
                          ],
                        ),

                        const Spacer(),

                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 💰 OFFER WALL (IMPORTANT 🔥)
                  _sectionTitle("Earn More"),

                  _settingsTile(
                    icon: Icons.local_offer,
                    title: "Offer Wall",
                    subtitle: "Complete tasks & earn coins",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OfferWallScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // ⚙️ APP SETTINGS
                  _sectionTitle("App Settings"),

                  _settingsTile(
                    icon: Icons.dark_mode,
                    title: "Dark Mode",
                    subtitle: "Toggle theme",
                    color: Colors.purple,
                  ),

                  _settingsTile(
                    icon: Icons.help,
                    title: "Help & Support",
                    subtitle: "Contact us",
                    color: Colors.blue,
                    onTap: () {},
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // 🚪 LOGOUT
                  _settingsTile(
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Sign out from account",
                    color: Colors.red,
                    onTap: () {
                      vm.logout(context);
                    }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: TextStyle(
        color: AppColors.backgroundDark
      )),
    );
  }
}


Widget _settingsTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  color: AppColors.backgroundDark,
                  fontSize: 14
                )),
                Text(subtitle, style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontSize: 12
                )),
              ],
            ),
          ),

          trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}


class OfferWallScreen extends StatelessWidget {
  const OfferWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offer Wall")),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [

            _offerTile(
              title: "Watch Ads",
              reward: "+5 coins",
              icon: Icons.ondemand_video,
              onTap: () {},
            ),

            _offerTile(
              title: "Install Apps",
              reward: "+50 coins",
              icon: Icons.download,
              onTap: () {},
            ),

            _offerTile(
              title: "Daily Bonus",
              reward: "+10 coins",
              icon: Icons.card_giftcard,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


Widget _offerTile({
  required String title,
  required String reward,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Icon(icon, color: Colors.white),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ),

          Text(
            reward,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          )
        ],
      ),
    ),
  );
}