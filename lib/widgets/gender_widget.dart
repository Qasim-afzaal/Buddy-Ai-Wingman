import 'package:buddy/core/constants/imports.dart';

class GenderWidget extends StatelessWidget {
  const GenderWidget(
      {super.key,
      this.selectedGender,
      required this.onGenderSelection,
      this.headingText});

  final Genders? selectedGender;
  final Function(Genders) onGenderSelection;
  final String? headingText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headingText ?? AppStrings.yourGenderHeading,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(35),
        _Container(
          icon: Assets.icons.female,
          gender: Genders.Female,
          selectedGender: selectedGender,
          onGenderSelection: onGenderSelection,
        ),
        _Container(
          icon: Assets.icons.male,
          gender: Genders.Male,
          selectedGender: selectedGender,
          onGenderSelection: onGenderSelection,
        ),
        _Container(
          icon: Assets.icons.other,
          gender: Genders.Other,
          selectedGender: selectedGender,
          onGenderSelection: onGenderSelection,
        ),
      ],
    ).paddingAll(20);
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {super.key,
      required this.gender,
      this.selectedGender,
      required this.icon,
      required this.onGenderSelection});

  final Genders gender;
  final Genders? selectedGender;
  final SvgGenImage icon;

  final Function(Genders) onGenderSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
        onTap: () => onGenderSelection(gender),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: gender == selectedGender
                ? null
                : context.scaffoldBackgroundColor,
            gradient: gender == selectedGender
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                        context.secondary,
                        context.primary,
                      ])
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.svg(
                  color:
                      gender == selectedGender ? Colors.white : context.primary,
                  width: 42,
                  height: 48),
              SB.w(15),
              Text(
                gender.name,
                style: context.titleMedium?.copyWith(
                  color: gender == selectedGender ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
