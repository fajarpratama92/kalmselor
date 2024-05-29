import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/widget/date_picker.dart';
import 'package:counselor/widget/text.dart';

Future<DateTime?> DATE_PICKER({
  DateTime? initialDateTime,
  int? maxYears,
  int? minYear,
  bool showUserAge = true,
}) async {
  DatePickerController _datePickerController = DatePickerController(
      initialDateTime: initialDateTime ?? DateTime.now(),
      minYear: minYear ?? 1900,
      maxYear: maxYears ?? DateTime.now().year);
  DateTime? _dateTime;
  await Get.bottomSheet<bool>(
    DatePicker(
      showUserAge: showUserAge,
      onSubmit: (d) {
        _dateTime = d;
        Get.back();
      },
      title: "Pilih Tanggal",
      height: Get.height / 3,
      controller: _datePickerController,
      locale: DatePickerLocale.id_ID,
      pickerDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(color: BLUEKALM, width: 2.0)),
      config: DatePickerConfig(isLoop: false, selectedTextStyle: COSTUM_TEXT_STYLE()),
      onChanged: (date) {
        _dateTime = date;
      },
    ),
  );
  return _dateTime;
}
