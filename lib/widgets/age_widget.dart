import 'package:buddy/core/constants/imports.dart';

class AgeWidget extends StatelessWidget {
  AgeWidget(
      {super.key,
      this.selectedAge,
      required this.onAgeSelection,
      this.headingText});
  final String? headingText;

  final String? selectedAge;
  final Function(String) onAgeSelection;
  final List<String> _ageList = [
    '18 - 25',
    '26 - 35',
    '36 - 45',
    '46 - \u221E',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headingText ?? AppStrings.yourAgeHeading,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(35),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return _Container(
                  age: _ageList[index],
                  selectedAge: selectedAge,
                  onAgeSelection: onAgeSelection,
                );
              },
              separatorBuilder: (context, index) {
                return SB.h(0);
              },
              itemCount: _ageList.length),
        )
      ],
    ).paddingAll(20);
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {super.key,
      required this.age,
      this.selectedAge,
      required this.onAgeSelection});

  final String age;
  final String? selectedAge;

  final Function(String) onAgeSelection;

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
        onTap: () => onAgeSelection(age),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: age == selectedAge ? null : context.scaffoldBackgroundColor,
            gradient: age == selectedAge
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
              Text(
                age,
                style: context.titleMedium?.copyWith(
                  color: age == selectedAge ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
