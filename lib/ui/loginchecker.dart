import 'package:ai_chat/ui/common.dart';
import 'package:ai_chat/ui/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../splash.dart';
import '../viewmodel/user/users_vm.dart';
import '../viewmodel/wallet/wallet_vm.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //  Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashView();
        }

        //  User logged in
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthViewModel>().loadUser();
            context.read<WalletViewModel>().loadWallet();
          });
          return const MainNavigationView();
        }

        //  Not logged in
        return SigninView();
      },
    );
  }
}
