import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/pin/create_pin/create_pin_controller.dart';

class CreatePinPage extends StatelessWidget {
  const CreatePinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: getStorageData.readBoolean(key: getStorageData.isPinCreated)
            ? AppStrings.changePin
            : AppStrings.createPin,
      ),
      body: GetBuilder<CreatePinController>(
        init: CreatePinController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SB.h(20),
                Text(
                  getStorageData.readBoolean(key: getStorageData.isPinCreated)
                      ? AppStrings.enterYourNewPin
                      : AppStrings.createPin,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: getStorageData.readBoolean(
                            key: getStorageData.isPinCreated)
                        ? context.primary
                        : null,
                  ),
                ),
                SB.h(40),
                if (getStorageData.readBoolean(
                    key: getStorageData.isPinCreated))
                  CustomTextField(
                    controller: controller.oldPin,
                    title: AppStrings.oldPin,
                    isPasswordField: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                CustomTextField(
                  controller: controller.newPin,
                  title: getStorageData.readBoolean(
                          key: getStorageData.isPinCreated)
                      ? AppStrings.newPin
                      : AppStrings.enterPin,
                  isPasswordField: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
                CustomTextField(
                  controller: controller.confirmNewPin,
                  title: AppStrings.confirmPin,
                  isPasswordField: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 4,
                ),
                SB.h(30),
                AppButton.primary(
                  title: getStorageData.readBoolean(
                          key: getStorageData.isPinCreated)
                      ? AppStrings.changePin
                      : AppStrings.confirmPin,
                  onPressed: getStorageData.readBoolean(
                          key: getStorageData.isPinCreated)
                      ? controller.changePin
                      : controller.createPin,
                ),
                SB.h(25),
                AppButton.outline(
                  title: AppStrings.enableBio,
                  onPressed: () => Get.bottomSheet(const _BiometricWidget()),
                ),
              ],
            ).paddingAll(context.paddingDefault),
          );
        },
      ),
    );
  }
}

class _BiometricWidget extends StatefulWidget {
  const _BiometricWidget();

  @override
  State<_BiometricWidget> createState() => _BiometricWidgetState();
}

class _BiometricWidgetState extends State<_BiometricWidget> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: context.scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SB.h(25),
            Assets.icons.fingerprint.svg(),
            SB.h(25),
            Text(
              isEnabled ? AppStrings.bioAuthSetup : AppStrings.bioAuth,
              textAlign: TextAlign.center,
              style: context.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500, height: 1),
            ),
            SB.h(10),
            Text(
              isEnabled
                  ? AppStrings.bioAuthSetupDescription
                  : AppStrings.bioAuthDescription,
              textAlign: TextAlign.center,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SB.h(15),
            Column(children: [
              if (!isEnabled) ...[
                AppButton.primary(
                  title: AppStrings.enableBioLogin,
                  onPressed: () {
                    setState(() {
                      isEnabled = true;
                    });
                  },
                ),
                SB.h(20),
                AppButton.outline(
                  title: AppStrings.cancel,
                  onPressed: Get.back,
                ),
              ],
              if (isEnabled)
                AppButton.primary(
                  title: AppStrings.backToHome,
                  onPressed: () => Get.offAll(() => const DashboardPage()),
                ),
            ]).paddingAll(context.paddingDefault)
          ],
        ).paddingAll(context.paddingDefault),
      ),
    );
  }
}
