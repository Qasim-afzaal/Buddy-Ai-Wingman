import 'package:get/get.dart';
import 'package:buddy/pages/start/create_account/create_account_controller.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(
      () => CreateAccountController(),
    );
  }
}
