import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/new_chat/voice_chat/voice_chat_controller.dart';

class VoiceChatPage extends StatelessWidget {
  const VoiceChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoiceChatController>(
      init: VoiceChatController(),
      builder: (controller) {
        return Scaffold(
          appBar: SimpleAppBar(
            title: 'Angela',
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    width: context.width * 0.8,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.chatBubbleColor,
                    ),
                    child: Center(child: Assets.icons.voiceBar.image(
                      width: context.width * 0.5
                    )),
                  ),
                  SB.h(20),
                  Text(AppStrings.listening, style: context.bodyLarge,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.chatBubbleColor,
                    ),
                    child: Assets.icons.stop.svg(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.primary,
                    ),
                    child: Icon(Icons.clear, color: context.scaffoldBackgroundColor,),
                  ),
                ],
              )
            ],
          ).paddingAll(context.paddingDefault),
        );
      },
    );
  }
}
