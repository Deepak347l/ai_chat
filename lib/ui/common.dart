import 'package:ai_chat/core/constants/app_colors.dart';
import 'package:ai_chat/core/utils/constants.dart';
import 'package:ai_chat/ui/setting/setting_view.dart';
import 'package:ai_chat/ui/wallet/wallet_view.dart';
import 'package:ai_chat/ui/withdraw/withdraw_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_text_styles.dart';
import '../viewmodel/chat/chat_vm.dart';
import '../viewmodel/user/users_vm.dart';
import 'chat/chat_view.dart';
import 'home/home_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  static void changeTab(BuildContext context, int index) {
    final state =
    context.findAncestorStateOfType<_MainNavigationViewState>();
    state?.changeTab(index);
  }

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeView(),
    ChatView(),
    const WalletView(),
    const WithdrawView(),
    const SettingsView(),
  ];


  @override
  void initState() {
    super.initState();

    final vm = context.read<AuthViewModel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final chatvm = context.read<ChatViewModel>();

    constants().uid = userId;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.checkUserSetup(userId);

      if (!vm.isGenderSelected) {
        showGenderDialog(context, userId);
      }

      chatvm.initChatUser(vm.isGenderSelected ? vm.currentUser!.isSelectgender! : ""); // "male" or "female"

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondary,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColors.textPrimaryLight,
        selectedItemColor: AppColors.backgroundLight,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Withdraw"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],

      ),
    );
  }
}

void showGenderDialog(BuildContext context, String userId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      String selected = "";

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.surfaceLight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  //  TITLE
                  Text(
                    "Who would you like to chat with?",
                    style: AppTextStyles.h3,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Choose your preference",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),

                  SizedBox(height: 20),

                  //  GIRL OPTION
                  _optionCard(
                    title: "Girls 👩",
                    value: "female",
                    selected: selected,
                    onTap: () => setState(() => selected = "female"),
                  ),

                  SizedBox(height: 12),

                  //  BOY OPTION
                  _optionCard(
                    title: "Boys 👨",
                    value: "male",
                    selected: selected,
                    onTap: () => setState(() => selected = "male"),
                  ),

                  SizedBox(height: 20),

                  //  CONTINUE
                  Consumer<AuthViewModel>(
                    builder: (context, vm, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selected.isEmpty
                              ? null
                              : () async {
                            await vm.saveGender(userId, selected);
                            Navigator.pop(context);
                          },
                          child: Text("Continue"),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _optionCard({
  required String title,
  required String value,
  required String selected,
  required VoidCallback onTap,
}) {
  final isSelected = selected == value;

  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          const Spacer(),
          if (isSelected)
            Icon(Icons.check_circle, color: AppColors.primary)
        ],
      ),
    ),
  );
}
