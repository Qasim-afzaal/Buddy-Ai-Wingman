import 'package:buddy_ai_wingman/core/constants/imports.dart';

import '../../api_repository/api_class.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  String? imagePath;

  void addNewChatManually(bool value) {
                   Map chatmsg = {
        "name": "add new chat manual Chat"
      };
      Constants.socket!.emit("logEvent", chatmsg);
    Get.toNamed(
      Routes.GATHER_NEW_CHAT_INFO,
      arguments: {
        if (!value) HttpUtil.filePath: imagePath,
        HttpUtil.isManually: value,
      },
    );
  }
}

List<SparkLinesModel> linesList = [
     SparkLinesModel(text: "👋 Casual Hi"),
    SparkLinesModel(text: "😘 Flirty Compliment"),
    SparkLinesModel(text: "🌇 Ask About"),
    SparkLinesModel(text: "🗓️ Weekend Plans"),
    SparkLinesModel(text: "🎬 Favorite Movie"),
    SparkLinesModel(text: "🎶 Go-To Song"),
    SparkLinesModel(text: "✈️ Best Travel"),
    SparkLinesModel(text: "👗 Compliment Style"),
    SparkLinesModel(text: "💼 Dream Job"),
    SparkLinesModel(text: "🦁 Spirit Animal"),
    SparkLinesModel(text: "💖 Compliment Kindness"),
    SparkLinesModel(text: "🌟 Childhood Dream"),
    SparkLinesModel(text: "🌞 Good Morning"),
    SparkLinesModel(text: "🏝️ Ideal Vacation"),
    SparkLinesModel(text: "😆 Compliment Humor"),
    SparkLinesModel(text: "🌟 Quote Inspire"),
    SparkLinesModel(text: "🍕 Favorite Food"),
    SparkLinesModel(text: "♌ Zodiac Sign"),
    SparkLinesModel(text: "🍝 Dinner Idea"),
    SparkLinesModel(text: "🤓 Fun Fact"),
    SparkLinesModel(text: "📚 Favorite Book"),
    SparkLinesModel(text: "❓ Random Question"),
    SparkLinesModel(text: "🎨 Hobbies Interests"),
    SparkLinesModel(text: "📺 Favorite TV"),
    SparkLinesModel(text: "🎯 Goals"),
    SparkLinesModel(text: "😊 Compliment Smile"),
    SparkLinesModel(text: "🌴 Relax Place"),
    SparkLinesModel(text: "🎭 Hidden Talent"),
    SparkLinesModel(text: "🧀 Pickup Line"),
    SparkLinesModel(text: "🐶 Ask Pets"),
    SparkLinesModel(text: "💭 Daydreams"),
    SparkLinesModel(text: "🍫 Guilty Pleasure"),
    SparkLinesModel(text: "⚽ Sport Activity"),
    SparkLinesModel(text: "👀 Compliment Eyes"),
    SparkLinesModel(text: "🍂 Favorite Season"),
    SparkLinesModel(text: "🎉 Fun Challenge"),
    SparkLinesModel(text: "🧠 Fact of Day"),
    SparkLinesModel(text: "🎄 Favorite Holiday"),
    SparkLinesModel(text: "😂 Funny Meme"),
    SparkLinesModel(text: "📝 Bucket List"),
    SparkLinesModel(text: "💪 Morning Motivation"),
    SparkLinesModel(text: "🐾 Cute Photo"),
    SparkLinesModel(text: "☕ Coffee Tea"),
    SparkLinesModel(text: "🏖️ Weekend Vibes"),
    SparkLinesModel(text: "🤳 Silly Selfie"),
];

class SparkLinesModel {
  final String text;

  SparkLinesModel({
    required this.text,
  });
}
