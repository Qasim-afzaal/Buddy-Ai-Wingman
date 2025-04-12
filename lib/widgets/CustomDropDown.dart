import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:buddy_ai_wingman/core/constants/imports.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.onChanged,
      required this.dropDownIcon,
      required this.dropDownList});

  final void Function(DropDownItem?)? onChanged;
  final Widget dropDownIcon;
  final List<DropDownItem> dropDownList;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dropDownIcon,
        alignment: Alignment.bottomRight,
        items: [
          ...dropDownList.map(
            (item) => DropdownMenuItem<DropDownItem>(
              value: item,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  if (item.iconPath != null)
                    SvgPicture.asset(item.iconPath!).paddingOnly(right: 8),
                  Text(
                    item.text,
                    style: context.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          padding: const EdgeInsets.only(left: 8, right: 8),
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 8,
          offset: const Offset(0, 8),
        ),
      ),
    );
  }
}

class DropDownItem {
  final String? iconPath;
  final String text, value;

  const DropDownItem({
    this.iconPath,
    required this.text,
    required this.value,
  });
}
