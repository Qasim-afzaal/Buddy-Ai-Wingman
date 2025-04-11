import 'package:get/get.dart';
import 'package:buddy_ai_wingman/pages/home/home_controller.dart';

class SparkdLinesController extends GetxController {
  var linesList = <SparkLinesModel>[
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
  ].obs;

  var filteredList = <SparkLinesModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initially, the filtered list is the same as the original list
    filteredList.value = linesList;
  }

  void filterLines(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredList.value = linesList;
    } else {
      filteredList.value = linesList
          .where(
              (line) => line.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void resetSearch() {
    searchQuery.value = '';
    filteredList.value = linesList;
  }
}
