import 'package:ai_chat/ui/loginchecker.dart';
import 'package:ai_chat/ui/signin.dart';
import 'package:ai_chat/viewmodel/chat/chat_vm.dart';
import 'package:ai_chat/viewmodel/user/users_vm.dart';
import 'package:ai_chat/viewmodel/wallet/wallet_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Firebase
  await Firebase.initializeApp();

  // Initialize ad mob
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(),),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), //  Base design (iPhone X)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            //  Theme setup
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,

            //  First screen
            home: child,
          );
        },

        //  Your starting screen
        child: AuthWrapper(), // or LoginView()
      ),
    );
  }
}
