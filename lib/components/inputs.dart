// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motopickupdriver/components/cities.dart';
import 'package:motopickupdriver/components/custom_search.dart';
import 'package:motopickupdriver/utils/colors.dart';
import 'package:motopickupdriver/utils/models/ListItems.dart';
import 'package:motopickupdriver/utils/typography.dart';

class InputTextField extends StatefulWidget {
  String hintText;
  TextEditingController controller;
  TextInputType type;
  IconData icon;
  bool enable;
  InputTextField(
      {required this.hintText,
      required this.type,
      required this.controller,
      required this.icon,
      this.enable = true,
      Key? key})
      : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 70.h,
        child: TextField(
          textCapitalization: TextCapitalization.words,
          enabled: widget.enable,
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: widget.type,
          style: inputTextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            hintText: widget.hintText.tr(),
            hintStyle: hintTextStyle,
            filled: true,
            fillColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primary, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: border, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

class InputDatePicker extends StatefulWidget {
  String dateText;
  IconData icon;
  VoidCallback function;

  InputDatePicker(
      {required this.dateText,
      required this.icon,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<InputDatePicker> createState() => _InputDatePickerState();
}

class _InputDatePickerState extends State<InputDatePicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          height: 60.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: dark, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: Colors.grey,
                ),
                10.horizontalSpace,
                Text(
                  widget.dateText,
                  style: widget.dateText == "Entrez votre date de naissance"
                      ? hintTextStyle
                      : bodyTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  List<DropdownMenuItem<ListItem>>? items;
  ListItem? listItem;
  final Function(ListItem?)? function;

  DropDownMenu(
      {required this.items,
      required this.listItem,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 60.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0x90000000), width: 1),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                height: 65.h,
                width: 300.w,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ListItem>(
                    value: widget.listItem,
                    items: widget.items,
                    style: inputTextStyle,
                    iconSize: 20,
                    icon: const Icon(
                      Boxicons.bx_chevron_down,
                      color: dark,
                    ),
                    iconEnabledColor: Colors.grey[800],
                    isExpanded: true,
                    onChanged: widget.function,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityPicker extends StatefulWidget {
  int? initialData;
  var selected;
  List? selectedList;
  Function(dynamic) function;

  CityPicker(
      {required this.initialData,
      required this.selected,
      required this.selectedList,
      required this.function,
      Key? key})
      : super(key: key);

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomSearchableDropDown(
        items: listToSearch,
        menuHeight: 60.h,
        label: 'Choisissez votre ville'.tr(),
        labelStyle: bodyTextStyle,
        searchBarHeight: 65.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0x90000000), width: 1),
        ),
        suffixIcon: const Icon(Boxicons.bx_chevron_down),
        dropDownMenuItems: listToSearch.map((item) {
          return item['name'];
        }).toList(),
        onChanged: widget.function,
        dropdownHintText: 'Choisissez votre ville'.tr(),
        dropdownItemStyle: bodyTextStyle,
        initialIndex: widget.initialData,
        showClearButton: false,
      ),
    );
  }
}

class InputPasswordField extends StatefulWidget {
  String hintText;
  TextEditingController controller;
  TextInputType type;
  bool enable;
  InputPasswordField(
      {required this.hintText,
      required this.type,
      required this.controller,
      this.enable = true,
      Key? key})
      : super(key: key);

  @override
  State<InputPasswordField> createState() => _InputPasswordFieldState();
}

class _InputPasswordFieldState extends State<InputPasswordField> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 70.h,
        child: TextField(
          enabled: widget.enable,
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: widget.type,
          style: inputTextStyle,
          obscureText: !show,
          obscuringCharacter: '•',
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                show
                    ? setState(() => show = false)
                    : setState(() => show = true);
              },
              child:
                  Icon(show ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash),
            ),
            hintText: widget.hintText.tr(),
            hintStyle: hintTextStyle,
            filled: true,
            fillColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primary, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: border, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
