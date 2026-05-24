import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../viewmodel/user/users_vm.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),

                            // HEADER
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt_1,
                                    size: 36.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),

                                Text(
                                  "Create Account",
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6.h),

                                Text(
                                  "Start chatting & earn rewards",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 40.h),

                            // FORM CARD
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.r),
                                  ),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // NAME
                                      TextFormField(
                                        style: const TextStyle(
                                          color:
                                              Colors.black, // input text color
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter Your Name',
                                          filled: true,
                                          fillColor: AppColors.backgroundLight,
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),
                                        ),

                                        validator: Validators.name,
                                        onChanged: vm.setName,
                                      ),
                                      SizedBox(height: AppSpacing.md),

                                      // EMAIL
                                      TextFormField(
                                        style: const TextStyle(
                                          color:
                                              Colors.black, // input text color
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter Your Email',
                                          filled: true,
                                          fillColor: AppColors.backgroundLight,
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),
                                        ),
                                        validator: Validators.email,
                                        onChanged: vm.setEmail,
                                      ),
                                      SizedBox(height: AppSpacing.md),

                                      // PASSWORD
                                      TextFormField(
                                        style: const TextStyle(
                                          color:
                                              Colors.black, // input text color
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Create password',
                                          filled: true,
                                          fillColor: AppColors.backgroundLight,
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),
                                        ),
                                        obscureText: true,
                                        validator: Validators.strongPassword,
                                        onChanged: vm.setPassword,
                                      ),

                                      SizedBox(height: AppSpacing.lg),

                                      // SIGNUP BUTTON
                                      vm.isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    vm.signup(context);
                                                  }
                                                },
                                                child: Text(
                                                  "Create Account",
                                                  style:
                                                      AppTextStyles.buttonLarge,
                                                ),
                                              ),
                                            ),

                                      SizedBox(height: AppSpacing.lg),

                                      // DIVIDER
                                      Row(
                                        children: [
                                          const Expanded(child: Divider()),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
                                            child: Text(
                                              "OR",
                                              style: AppTextStyles.labelMedium,
                                            ),
                                          ),
                                          const Expanded(child: Divider()),
                                        ],
                                      ),

                                      SizedBox(height: AppSpacing.lg),

                                      // GOOGLE
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          onPressed: () =>
                                              vm.googleSignIn(context),
                                          icon: const Icon(
                                            Icons.g_mobiledata,
                                            size: 26,
                                          ),
                                          label: Text(
                                            "Continue with Google",
                                            style: AppTextStyles.buttonMedium,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      // LOGIN REDIRECT
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Already have an account? ",
                                            style: AppTextStyles.bodySmall,
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Text(
                                              "Login",
                                              style: AppTextStyles.labelLarge
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: AppSpacing.md),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
