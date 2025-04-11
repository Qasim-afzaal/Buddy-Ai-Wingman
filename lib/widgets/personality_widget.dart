import 'package:buddy_ai_wingman/core/constants/imports.dart';

class PersonalityWidget extends StatelessWidget {
  PersonalityWidget({
    super.key,
    this.selectedPersonality,
    required this.onPersonalitySelection,
    this.onFinish,
    this.headingText,
  });

  final String? headingText;

  final Personality? selectedPersonality;
  final Function(Personality) onPersonalitySelection;
  final VoidCallback? onFinish;
  final List<PersonalityModel> _personalityList = [
    PersonalityModel(
      personality: Personality.Seductive,
      image: Assets.icons.seductuve,
      description:
          "Lorem ipsum dolor sit amet. Qui nobisnostrum ut voluptas incidunt.",
    ),
    PersonalityModel(
      personality: Personality.Extrovert,
      image: Assets.icons.extrovert,
      description:
          "Lorem ipsum dolor sit amet. Qui nobisnostrum ut voluptas incidunt.",
    ),
    PersonalityModel(
      personality: Personality.Introvert,
      image: Assets.icons.introvert,
      description:
          "Lorem ipsum dolor sit amet. Qui nobisnostrum ut voluptas incidunt.",
    ),
    PersonalityModel(
      personality: Personality.Romantic,
      image: Assets.icons.romantic,
      description:
          "Lorem ipsum dolor sit amet. Qui nobisnostrum ut voluptas incidunt.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headingText ?? AppStrings.yourPersonalityHeading,
          textAlign: TextAlign.center,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(18),
        Flexible(
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _Container(
                  data: _personalityList[index],
                  selectedPersonality: selectedPersonality,
                  onPersonalitySelection: onPersonalitySelection,
                );
              },
              separatorBuilder: (context, index) {
                return SB.h(0);
              },
              itemCount: _personalityList.length),
        ),
        if (headingText == null)
          if (selectedPersonality != null)
            AppButton.primary(
              title: 'Finish',
              onPressed: onFinish,
            ),
      ],
    ).paddingAll(18);
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {required this.data,
      this.selectedPersonality,
      required this.onPersonalitySelection});

  final PersonalityModel data;
  final Personality? selectedPersonality;

  final Function(Personality) onPersonalitySelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primary,
              context.secondary,
            ]),
      ),
      child: InkWell(
        onTap: () {
          onPersonalitySelection(data.personality);
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: data.personality == selectedPersonality
                ? null
                : context.scaffoldBackgroundColor,
            gradient: data.personality == selectedPersonality
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                        context.secondary,
                        context.primary,
                      ])
                : null,
          ),
          child: Stack(
            children: [
              data.image.svg(
                color: data.personality == selectedPersonality
                    ? Colors.white
                    : context.primary,
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Center(
                  child: Text(
                    data.personality.name,
                    style: context.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: data.personality == selectedPersonality
                          ? Colors.white
                          : null,
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              // SB.h(4),
              // Text(
              //   data.description,
              //   style: context.titleSmall?.copyWith(
              //     fontWeight: FontWeight.w400,
              //     height: 1,
              //     color: data.personality == selectedPersonality
              //         ? Colors.white
              //         : null,
              //   ),
              // ),
              // ],
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalityModel {
  final Personality personality;
  final SvgGenImage image;
  final String description;

  PersonalityModel(
      {required this.personality,
      required this.image,
      required this.description});
}
