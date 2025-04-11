import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/auth/forgot_password/code_verification/code_verification.dart';
import 'package:buddy_ai_wingman/pages/auth/forgot_password/create_password/create_password.dart';
import 'package:buddy_ai_wingman/pages/auth/forgot_password/create_password/create_password_binding.dart';
import 'package:buddy_ai_wingman/pages/auth/forgot_password/email_verification/email_verification.dart';
import 'package:buddy_ai_wingman/pages/auth/login/login.dart';
import 'package:buddy_ai_wingman/pages/auth/otp/otp_verification/otp_varification.dart';
import 'package:buddy_ai_wingman/pages/auth/otp/otp_verification/otp_verification_binding.dart';
import 'package:buddy_ai_wingman/pages/auth/pin_verification/pin_verification.dart';
import 'package:buddy_ai_wingman/pages/auth/signup/signup.dart';
import 'package:buddy_ai_wingman/pages/home/home.dart';
import 'package:buddy_ai_wingman/pages/home/image_chat/screen/image_chat_binding.dart';
import 'package:buddy_ai_wingman/pages/home/image_chat/screen/image_chat_screen.dart';
import 'package:buddy_ai_wingman/pages/home/manual_chat/manual_chat_binding.dart';
import 'package:buddy_ai_wingman/pages/home/manual_chat/manual_chat_name.dart';
import 'package:buddy_ai_wingman/pages/home/pickup_lines/pickup_line.dart';
import 'package:buddy_ai_wingman/pages/home/pickup_lines/pickup_line_binding.dart';
import 'package:buddy_ai_wingman/pages/inbox/inbox.dart';
import 'package:buddy_ai_wingman/pages/inbox/inbox_binding.dart';
import 'package:buddy_ai_wingman/pages/new_chat/chat/chat.dart';
import 'package:buddy_ai_wingman/pages/new_chat/chat/chat_page_m.dart';
import 'package:buddy_ai_wingman/pages/new_chat/chat/chat_w_biding.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/gather_new_chat.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/manual_Chat.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/newbinding.dart';
import 'package:buddy_ai_wingman/pages/new_chat/info/info.dart';
import 'package:buddy_ai_wingman/pages/new_chat/voice_chat/voice_chat.dart';
import 'package:buddy_ai_wingman/pages/notifications/notification_settings.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_confirmation/payment_confirmation.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_method/payment_method.dart';
import 'package:buddy_ai_wingman/pages/payment/payment_plan/payment_plan.dart';
import 'package:buddy_ai_wingman/pages/pin/create_pin/create_pin.dart';
import 'package:buddy_ai_wingman/pages/pin/pin_success/pin_success.dart';
import 'package:buddy_ai_wingman/pages/profile/profile.dart';
import 'package:buddy_ai_wingman/pages/profile_before_payment/profile_before_payment.dart';
import 'package:buddy_ai_wingman/pages/profile_before_payment/profile_before_payment_binding.dart';
import 'package:buddy_ai_wingman/pages/settings/settings.dart';
import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines.dart';
import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response.dart';
import 'package:buddy_ai_wingman/pages/start/create_account/create_account.dart';
import 'package:buddy_ai_wingman/pages/start/on_boarding/onBoarding.dart';
import 'package:buddy_ai_wingman/pages/start/on_boarding_for_social/onBoarding_social.dart';
import 'package:buddy_ai_wingman/pages/start/on_boarding_for_social/onBoarding_social_binding.dart';
import 'package:buddy_ai_wingman/pages/start/splash/splash.dart';
import 'package:buddy_ai_wingman/pages/start_sparkd/start_sparkd.dart';
import 'package:buddy_ai_wingman/pages/terms_condition/terms_condition.dart';

import '../pages/auth/forgot_password/code_verification/code_verification_binding.dart';
import '../pages/auth/forgot_password/email_verification/email_verification_binding.dart';
import '../pages/auth/login/login_binding.dart';
import '../pages/auth/pin_verification/pin_verification_binding.dart';
import '../pages/auth/signup/signup_binding.dart';
import '../pages/dashboard/dashboard_binding.dart';
import '../pages/home/home_binding.dart';
import '../pages/new_chat/chat/chat_binding.dart';
import '../pages/new_chat/gather_new_chat/gather_new_chat_binding.dart';
import '../pages/new_chat/info/info_binding.dart';
import '../pages/new_chat/voice_chat/voice_chat_binding.dart';
import '../pages/notifications/notification_settings_binding.dart';
import '../pages/payment/payment_confirmation/payment_confirmation_binding.dart';
import '../pages/payment/payment_method/payment_method_binding.dart';
import '../pages/payment/payment_plan/payment_plan_binding.dart';
import '../pages/pin/create_pin/create_pin_binding.dart';
import '../pages/pin/pin_success/pin_success_binding.dart';
import '../pages/profile/profile_binding.dart';
import '../pages/settings/settings_binding.dart';
import '../pages/sparkd_lines/sparkd_lines_binding.dart';
import '../pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response_binding.dart';
import '../pages/start/create_account/create_account_binding.dart';
import '../pages/start/on_boarding/onBoarding_binding.dart';
import '../pages/start/splash/splash_binding.dart';
import '../pages/start_sparkd/start_sparkd_binding.dart';
import '../pages/terms_condition/terms_condition_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: _Paths.SPLASH,
        page: () => const SplashPage(),
        binding: SplashBinding()),
    GetPage(
        name: _Paths.PROFILEPAGE_2,
        page: () => const ProfilePageBeforePayment(),
        binding: ProfileBeforePaymentBinding()),
    GetPage(
        name: _Paths.ON_BOARDING,
        page: () => const OnBoardingPage(),
        binding: OnBoardingBinding()),
    GetPage(
        name: _Paths.ON_BOARDING_FOR_SOCIAL,
        page: () => const OnBoardingSocialPage(),
        binding: OnBoardingSocialBinding()),
    GetPage(
        name: _Paths.CREATE_ACCOUNT,
        page: () => const CreateAccountPage(),
        binding: CreateAccountBinding()),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: _Paths.OTP,
        page: () => OTPVerificationPage(),
        binding: OtpVerificationBinding()),
    GetPage(
        name: _Paths.SIGN_UP,
        page: () => const SignupPage(),
        binding: SignupBinding()),
    GetPage(
        name: _Paths.CODE_VERIFICATION,
        page: () => const CodeVerificationPage(),
        binding: CodeVerificationBinding()),
    GetPage(
        name: _Paths.CREATE_PASSWORD,
        page: () => const CreatePasswordPage(),
        binding: CreatePasswordBinding()),
    GetPage(
        name: _Paths.EMAIL_VERIFICATION,
        page: () => const EmailVerificationPage(),
        binding: EmailVerificationBinding()),
    GetPage(
        name: _Paths.PIN_VERIFICATION,
        page: () => const PinVerificationPage(),
        binding: PinVerificationBinding()),
    GetPage(
        name: _Paths.DASHBOARD,
        page: () => const DashboardPage(),
        binding: DashBoardBinding()),
    GetPage(name: _Paths.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: _Paths.INBOX,
        page: () => const InboxPage(),
        binding: InboxBinding()),
    GetPage(
        name: _Paths.CHAT,
        page: () => const ChatPage(),
        binding: ChatBinding()),
    GetPage(
        name: _Paths.GATHER_NEW_CHAT_INFO,
        page: () => const GatherNewChatInfoPage(),
        binding: GatherNewChatInfoBinding()),
    GetPage(
        name: _Paths.INFO,
        page: () => const InfoPage(),
        binding: InfoBinding()),
    GetPage(
        name: _Paths.VOICE_CHAT,
        page: () => const VoiceChatPage(),
        binding: VoiceChatBinding()),
    GetPage(
        name: _Paths.PAYMENT_CONFIRMATION,
        page: () => const PaymentConfirmationPage(),
        binding: PaymentConfirmationBinding()),
    GetPage(
        name: _Paths.PAYMENT_METHOD,
        page: () => const PaymentMethodPage(),
        binding: PaymentMethodBinding()),
    GetPage(
        name: _Paths.PAYMENT_PLAN,
        page: () => const PaymentPlanPage(),
        binding: PaymentPlanBinding()),
    GetPage(
        name: _Paths.CREATE_PIN,
        page: () => const CreatePinPage(),
        binding: CreatePinBinding()),
    GetPage(
        name: _Paths.PIN_SUCCESS,
        page: () => const PinSuccessPage(),
        binding: PinSuccessBinding()),
    GetPage(
        name: _Paths.PROFILE,
        page: () => const ProfilePage(),
        binding: ProfileBinding()),
    GetPage(
        name: _Paths.SETTINGS,
        page: () => const SettingsPage(),
        binding: SettingsBinding()),
    GetPage(
        name: _Paths.NOTIFICATION_SETTINGS,
        page: () => const NotificationSettingsPage(),
        binding: NotificationSettingsBinding()),
   

    GetPage(
        name: _Paths.START_SPARKD,
        page: () => const StartSparkdPage(),
        binding: StartSparkdBinding()),
    GetPage(
        name: _Paths.IMAGE_CHAT,
        page: () => const ImageChatPage(),
        binding: ImageChatBinding()),
    GetPage(
        name: _Paths.PICKUP_LINES,
        page: () => const PickupLinePage(),
        binding: PickupLineBinding()),
    GetPage(
        name: _Paths.TERMS_CONDITION,
        page: () => const TermsConditionPage(),
        binding: TermsConditionBinding()),
    GetPage(
      name: _Paths.NEW,
      page: () => NewGatherChatPage(),
      binding: NewGatherChatInfoBinding(),
    ),
    GetPage(
      name: _Paths.MANUAL_CHAT,
      page: () => ManualChatPage(),
      binding: ManualChatBinding(),
    ),
    GetPage(
      name: _Paths.NEW2,
      page: () => ChatPage2(),
      binding: Chat2Binding(),
    ),
  ];
}
