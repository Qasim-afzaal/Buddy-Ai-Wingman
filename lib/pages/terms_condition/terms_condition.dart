import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/terms_condition/terms_condition_controller.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.termsConditions,
      ),
      body: GetBuilder<TermsConditionController>(
        init: TermsConditionController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  """1. Introduction
App Name and Developer Information: Clearly state the name of the app and provide information about the developer. 
  
Acceptance of Terms: Specify that by using the app, users agree to the terms and conditions.

2. Eligibility
Age Requirement: Users must be at least 18 years old to use the app. 
  
User Responsibility: Users are responsible for their interactions and ensuring they comply with the terms.

3. Data Collection and Usage
Personal Information: Clearly outline what personal information will be collected (e.g., name, email, date of birth, location). 
  
Behavioral Data: Detail what behavioral data the app will collect (e.g., user interactions, preferences, usage patterns).
  
AI Interaction Data: Explain what data will be collected from user interactions with the AI coach. 
  
Purpose of Data Collection: Specify why the data is being collected (e.g., to enhance user experience, provide personalized advice, etc.). 
  
Third-Party Services: Mention any third-party services used for data processing or analytics, including links to their privacy policies.
  
4. User Consent
Explicit Consent: Ensure that users give explicit consent to data collection when signing up.
  
Opt-out Options: Provide users with options to opt out of certain data collection practices (e.g., location tracking).
  
5. Data Security
Encryption: Mention that data is encrypted both in transit and at rest.

Security Measures: Detail the security measures in place to protect user data (e.g., regular security audits, secure servers).

6. User Rights
Access and Control: Inform users of their rights to access, modify, or delete their data.

Data Portability: If applicable, describe how users can request their data in a portable format.

Account Deletion: Explain the process for deleting accounts and what happens to their data afterward.

7. AI Usage and Limitations
AI Coach Role: Describe the role of the AI coach, emphasizing that it is a tool to provide guidance, not a substitute for human judgment.

No Guarantees: Clearly state that the app does not guarantee successful dating outcomes.

Limitations of AI: Highlight any limitations of the AI, such as its inability to understand all human emotions fully.

8. In-App Purchases
Pricing: Provide clear information on pricing for any in-app purchases.

Refunds: Outline the refund policy, in accordance with Apple’s guidelines.

9. User Conduct
Prohibited Activities: List prohibited activities (e.g., harassment, spamming, inappropriate content).

Reporting Abuse: Provide a method for users to report abuse or violations of the terms.

10. Modifications to the Terms
Changes: State that the terms may be updated, with users being notified of significant changes.

User Agreement: Users must agree to the updated terms to continue using the app.

11. Termination
Termination Rights: Reserve the right to terminate user accounts for violations of the terms.

Consequences: Explain what happens to user data upon termination.

12. Governing Law
Jurisdiction: Specify the governing law and jurisdiction for resolving disputes.

13. Contact Information
Support: Provide contact details for customer support regarding the terms and conditions. Compliance with Apple’s Guidelines. Ensure that your terms align with Apple’s App Store Review Guidelines, especially regarding data collection, user consent, and privacy. Adhere to Apple’s requirements on data privacy (e.g., providing a clear privacy policy), in-app purchases, and user-generated content.

Final Steps
Legal Review: Consider having the terms reviewed by a legal professional to ensure full compliance with all applicable laws and regulations.

User Agreement Flow: Implement a user-friendly flow in the app that allows users to read and agree to the terms before using the app.,
                """,
                  style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ).paddingAll(context.paddingDefault),
          );
        },
      ),
    );
  }
}

// ignore: unused_element
class _Tile extends StatelessWidget {
  const _Tile({required this.iconPath, required this.title, this.onTap});

  final String iconPath, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 28,
              height: 28,
            ),
            SB.w(10),
            Expanded(
              child: Text(
                title,
                style: context.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: context.primary,
              size: 18,
            )
          ],
        ).paddingAll(15),
        Divider(
          color: context.primary,
        )
      ],
    );
  }
}
