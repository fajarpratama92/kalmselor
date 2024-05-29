import 'dart:io';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/utilities/util.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentInformationPage extends StatelessWidget {
  final _controller = Get.put(PaymentInformationController());

  PaymentInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentInformationController>(
      builder: (_) {
        return SAFE_AREA(
          context: context,
          bottomPadding: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SPACE(height: 10),
                Center(
                  child: TEXT("INFORMASI PEMBAYARAN ", style: titleApp20),
                ),
                SPACE(height: 20),
                Container(child: _option(_)),
                SPACE(height: 20),
                if (_.optionIndex == 0) _.userBankView,
                if (_.optionIndex == 1) _.userHistoryView
              ],
            ),
          ),
        );
      },
    );
  }

  Row _option(PaymentInformationController _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async => await _.onChangeOption(0),
            child: Container(
              decoration: BoxDecoration(
                color: _.optionIndex == 0 ? BLUEKALM : Colors.grey[400],
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(25),
                  bottomStart: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Center(
                  child: TEXT(
                    "Informasi Rekening",
                    style: COSTUM_TEXT_STYLE(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SPACE(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async => await _.onChangeOption(1),
            child: Container(
              decoration: BoxDecoration(
                color: _.optionIndex == 1 ? BLUEKALM : Colors.grey[400],
                borderRadius: const BorderRadiusDirectional.only(
                  topEnd: Radius.circular(25),
                  bottomEnd: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Center(
                  child: TEXT(
                    "History",
                    style: COSTUM_TEXT_STYLE(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentInformationController extends GetxController {
  int optionIndex = 0;
  UserBankModel userBankModel =
      PRO.userData?.userBankModel ?? UserBankModel.initial();
  Map<String, dynamic> userBankModelPayload = UserBankModel().toJson();
  List<TextEditingController> userBankController = [];
  Widget userBankView = Container();
  Widget userHistoryView = Container();
  List<CounselorPayout> counselorPayout = [];
  initState() {
    // text ediiting controller
    userBankController = [
      TextEditingController(text: PRO.userData?.userBankModel?.bankName ?? ""),
      TextEditingController(
          text: PRO.userData?.userBankModel?.bankBranchAddress ?? ""),
      TextEditingController(
          text: PRO.userData?.userBankModel?.accountNumber ?? ""),
      TextEditingController(
          text: PRO.userData?.userBankModel?.accountHolder ?? ""),
    ];
    // value userBank modal
    userBankModel.toJson().keys.toList().forEach(
      (element) {
        userBankModelPayload.update(element,
            (value) => PRO.userData?.userBankModel?.toJson()[element] ?? "");
      },
    );
    // counsleor payout
    counselorPayout = PRO.userData?.counselorPayout ?? [];
    // user bank widget
    userBankView = _bankView();
    userHistoryView = _historyView();
  }

  // logic change option view
  Future<void> onChangeOption(int i) async {
    optionIndex = i;
    update();
    // if (i == 1) {
    //   await PRO.getPendingPayment(useLoading: false);
    // }
  }

  // widget user bank
  Widget _selectFormField({
    required int index,
    required TextEditingController? controller,
    required Function onChanged,
    required TextInputType? keyboardType,
    required List<TextInputFormatter>? inputFormatters,
  }) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        onChanged: (value) => onChanged(index, value),
        // onSubmitted: (value) => print("data"),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      );
    } else {
      return TextFormField(
        onChanged: (value) => onChanged(index, value),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 136, 130, 130),
            ),
          ),
          contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        ),
      );
    }
  }

  String question(int i) {
    var key = userBankModel.toJson().keys.toList()[i];
    switch (key) {
      case "bank_name":
        return "Nama Bank*";
      case "bank_branch_address":
        return "Alamat Cabang Bank*";
      case "account_number":
        return "Nomor Rekening*";
      case "account_holder":
        return "Nama Pemilik Rekening*";
      default:
        return "";
    }
  }

  List<TextInputFormatter?>? get userBankInputFormatter {
    return List.generate(userBankModel.toJson().keys.length, (i) {
      if (question(i) == "Nomor Rekening*") {
        return FilteringTextInputFormatter.digitsOnly;
      } else {
        return null;
      }
    });
  }

  List<TextInputType> get userBankInputType {
    return List.generate(
      userBankModel.toJson().keys.length,
      (i) {
        if (question(i) == "Nomor Rekening*") {
          return TextInputType.number;
        } else {
          return TextInputType.text;
        }
      },
    );
  }

  // logic user bank form
  void updateUserBankPayload(int i, String answer) {
    if (answer.isEmpty || answer == "") {
      validatedFieldMessageUserBank[i] = "Harap isi data ini";
    } else {
      validatedFieldMessageUserBank[i] = null;
    }
    userBankView = _bankView();
    userBankModelPayload.update(
        userBankModel.toJson().keys.toList()[i], (value) => answer);
    update();
  }

  bool get validatedForm {
    return validatedFieldMessageUserBank.every((e) => e == null);
  }

  List<String?> get validatedFieldMessageUserBank {
    return List.generate(
      userBankController.length,
      (i) {
        if (userBankController[i].text.isEmpty) {
          return "Wajib diisi";
        } else {
          return null;
        }
      },
    );
  }

  // api user bank form
  Future<void> submit() async {
    var _res = await Api()
        .POST(USER_PAYMENT_INFO, userBankModelPayload, useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      SUCCESS_SNACK_BAR("Perhatian", _res?.message);
      Loading.hide();
    } else {
      Loading.hide();
      return;
    }
  }

  // widget history
  Card _payoutDateRange() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
                "Payout from ${_dateTableData(counselorPayout.last.createdAt, separator: "/")} - ${_dateTableData(counselorPayout.first.createdAt, separator: "/")}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                )
                // style: TEXTSTYLE(fontWeight: FontWeight.w500),
                )
          ],
        ),
      ),
    );
  }

  String _dateTableData(String? date, {String? separator}) {
    if (date == null) {
      return "not found";
    } else {
      return DateFormat("dd${separator ?? "-"}MM${separator ?? "-"}y")
          .format(DateTime.parse(date));
    }
  }

  Table _tableHeader() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        // 0: IntrinsicColumnWidth(),
        // 1: FlexColumnWidth(),
        // 2: FixedColumnWidth(64),
      },
      children: const [
        TableRow(
          children: <Widget>[
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SizedBox(
                    height: 30,
                    child: Center(
                        child: Text("Tanggal",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ))))),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SizedBox(
                    height: 30,
                    child: Center(
                        child: Text("Pendapatan",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ))))),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SizedBox(
                    height: 30,
                    child: Center(
                        child: Text("Mutasi",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ))))),
          ],
        ),
      ],
    );
  }

  Table _tableColumn() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        // 0: IntrinsicColumnWidth(),
        // 1: FlexColumnWidth(),
        // 2: FixedColumnWidth(64),
      },
      children: List.generate(counselorPayoutTable.length, (i) {
        var _data = counselorPayoutTable[i];
        return TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Text(_dateTableData(_data.createdAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Text("Rp.${PARSE_TO_CURRENCY.format(_data.amount)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: SizedBox(
                height: 30,
                child: Center(
                  child: Text("Rp.${PARSE_TO_CURRENCY.format(_data.mutation)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  //logic history
  List<CounselorPayoutTable> get counselorPayoutTable {
    return List.generate(
      counselorPayout.length,
      (i) => CounselorPayoutTable(
        amount: counselorPayout[i].amount!,
        createdAt: counselorPayout[i].createdAt!,
        mutation: _mutation(
          i,
          counselorPayout.map((e) => e.amount!).toList(),
        ),
      ),
    );
  }

  int _mutation(int index, List<int> amount) {
    if (index == 0) {
      return amount[index];
    } else {
      return amount[index] + amount[index - 1];
    }
  }

  // widget render view paymentinformation
  Expanded _bankView() {
    return Expanded(
      child: ListView(
        children: List.generate(userBankModelPayload.keys.toList().length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SPACE(height: 15),
                TEXT(question(i)),
                SPACE(height: 5),
                _selectFormField(
                  index: i,
                  controller: userBankController[i],
                  onChanged: updateUserBankPayload,
                  keyboardType: userBankInputType[i],
                  inputFormatters: userBankInputFormatter?[i] != null
                      ? [userBankInputFormatter![i]!]
                      : null,
                ),
                if (validatedFieldMessageUserBank[i] != null)
                  Column(
                    children: [
                      SPACE(height: 5),
                      ERROR_VALIDATION_FIELD(validatedFieldMessageUserBank[i]),
                    ],
                  ),
                if ((i + 1) == userBankModelPayload.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: BUTTON(
                      "SIMPAN",
                      onPressed: () async => submit(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Expanded _historyView() {
    return counselorPayout.isEmpty
        ? Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset("assets/icon/alert.png", scale: 1.5),
                ),
                TEXT("Belum Ada History", textAlign: TextAlign.center),
              ],
            ),
          )
        : Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _payoutDateRange(),
                      SPACE(),
                      _tableHeader(),
                      _tableColumn(),
                      SPACE(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total Rp. ${PARSE_TO_CURRENCY.format(counselorPayoutTable.last.mutation)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

  @override
  void onInit() {
    initState();
    super.onInit();
  }

  @override
  void onClose() {
    for (var i = 0; i < userBankController.length; i++) {
      userBankController[i].dispose();
    }
    Get.delete<PaymentInformationController>();
    super.onClose();
  }
}

class CounselorPayoutTable {
  int amount;
  int mutation;
  String createdAt;

  CounselorPayoutTable(
      {required this.amount, required this.mutation, required this.createdAt});

  factory CounselorPayoutTable.fromJson(Map<String, dynamic> json) {
    return CounselorPayoutTable(
      amount: json['amount'],
      mutation: json['mutation'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = amount;
    data['mutation'] = mutation;
    data['created_at'] = createdAt;
    return data;
  }
}
