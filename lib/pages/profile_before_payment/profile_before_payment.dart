import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/profile_before_payment/profile_before_payment_controller.dart';
import 'package:buddy/widgets/confirmation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePageBeforePayment extends StatelessWidget {
  const ProfilePageBeforePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.profile,
      ),
      body: GetBuilder<ProfileBeforePaymentController>(
        init: ProfileBeforePaymentController(),
        builder: (controller) {
          final userId = getStorageData.getUserId();
          final userName = getStorageData.readString(getStorageData.userName) ?? 'User';
          final userEmail = getStorageData.readString(getStorageData.userEmailId) ?? 'No email';
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(20),
              // User Info Card
              Obx(() => _UserInfoCard(
                name: userName,
                email: userEmail,
                subscriptionPlan: controller.subscriptionPlan.value,
                isSubscribed: controller.isSubscribed.value,
              )),
              SB.h(20),
              _Tile(
                iconPath: Assets.icons.mail.path,
                title: "Contact and Support",
                onTap: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'info@buddywingman.com',
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Could not open email app',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              _Tile(
                iconPath: Assets.icons.logout.path,
                title: AppStrings.logout,
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                    title: AppStrings.logout,
                    description: AppStrings.logoutDescription,
                    onConfirmation: () {
                      getStorageData.removeAllData();
                    },
                  ),
                ),
              ),
              _Tile(
                iconPath: Assets.icons.deleteAll.path,
                title: "Delete Account",
                onTap: () => Get.bottomSheet(
                  ConfirmationWidget(
                      title: "Delete Account",
                      description: AppStrings.deletetaccont,
                      onConfirmation: () {
                        Get.bottomSheet(
                          ConfirmationWidget(
                            title: "Delete Account",
                            description: AppStrings.deletetaccont,
                            onConfirmation: () {
                              controller.deleteAccount();
                              print("User ID: $userId");
                            },
                          ),
                        );
                      }),
                ),
              ),
              // Push subscription info to bottom
              const Spacer(),
              // Subscription/Trial Info Card at the bottom
              Obx(() {
                if (controller.isLoadingSubscription.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                
                if (controller.isSubscribed.value && controller.subscriptionPlan.value.isNotEmpty) {
                  return Column(
                    children: [
                      _SubscriptionCard(
                        title: "Subscription",
                        subtitle: "Buddy ${controller.subscriptionPlan.value}",
                        description: controller.subscriptionPlan.value == "Basic"
                            ? "€9,99 / maand"
                            : "€14,99 / maand",
                        isTrial: false,
                      ),
                      // Show upgrade button only if user has Basic plan
                      if (controller.subscriptionPlan.value == "Basic")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => controller.upgradeToPro(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.primary,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Upgrade to Pro",
                                style: GoogleFonts.interTight(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                } else if (!controller.isSubscribed.value && controller.isTrialActive.value) {
                  return _SubscriptionCard(
                    title: "Free Trial",
                    subtitle: "${controller.trialDaysRemaining.value} ${controller.trialDaysRemaining.value == 1 ? 'day' : 'days'} remaining",
                    description: "After trial, choose a subscription plan",
                    isTrial: true,
                  );
                }
                return const SizedBox.shrink();
              }),
              SB.h(20),
            ],
          );
        },
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({
    required this.name,
    required this.email,
    required this.subscriptionPlan,
    required this.isSubscribed,
  });

  final String name;
  final String email;
  final String subscriptionPlan;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: GoogleFonts.interTight(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SB.w(15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.interTight(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SB.h(4),
                      Text(
                        email,
                        style: GoogleFonts.interTight(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SB.h(15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSubscribed && subscriptionPlan.isNotEmpty
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSubscribed && subscriptionPlan.isNotEmpty
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSubscribed && subscriptionPlan.isNotEmpty
                        ? Icons.check_circle
                        : Icons.access_time,
                    size: 16,
                    color: isSubscribed && subscriptionPlan.isNotEmpty
                        ? Colors.green
                        : Colors.orange,
                  ),
                  SB.w(6),
                  Text(
                    isSubscribed && subscriptionPlan.isNotEmpty
                        ? 'Subscription: $subscriptionPlan'
                        : 'Free Trial',
                    style: GoogleFonts.interTight(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: isSubscribed && subscriptionPlan.isNotEmpty
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.iconPath, required this.title, this.onTap});

  final String iconPath, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: Colors.black,
              ),
              SB.w(10),
              Expanded(
                child: Text(
                  title,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ).paddingAll(15),
        ),
        Divider(
          color: context.primary,
        )
      ],
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.title,
    required this.subtitle,
    required this.description,
    this.isTrial = false,
  });

  final String title;
  final String subtitle;
  final String description;
  final bool isTrial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isTrial 
              ? context.primary.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isTrial 
                ? context.primary.withOpacity(0.3)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isTrial 
                        ? context.primary
                        : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.interTight(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SB.h(12),
            Text(
              subtitle,
              style: GoogleFonts.interTight(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: isTrial ? context.primary : Colors.black87,
                ),
              ),
            ),
            SB.h(6),
            Text(
              description,
              style: GoogleFonts.interTight(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

