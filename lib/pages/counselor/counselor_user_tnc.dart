import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/counselor-chat-controller.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/widget/appbar/main-appbar.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CounselorUserTncPage extends StatelessWidget {
  final ClientStatusModel client;
  CounselorUserTncPage({Key? key, required this.client}) : super(key: key);
  final _controller = Get.put(CounselorUserTncController());
  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      context: context,
      child: GetBuilder<CounselorUserTncController>(
        initState: (st) {
          _controller.tncView(client.code!);
        },
        builder: (_) {
          return Builder(
            builder: (context) {
              if (_.tncViewResModel == null) {
                return Center(child: CustomWaiting().defaut());
              } else {
                var _data = _.tncViewResModel?.data;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Persetujuan Kalmselor - Klien",
                            style: titleApp20,
                            textAlign: TextAlign.center,
                          ),
                          const Divider(thickness: 1),
                          Text(
                            "Persetujuan ini telah Anda setujui pada",
                            style: descriptionApp14Gray,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                              "Tanggal : ${_.tncDate(client.updateTncAt ?? "")}",
                              textAlign: TextAlign.center,
                              style: descriptionApp14Gray),
                          SPACE(height: 20),
                          Text(
                            "${STATE(context).userData?.firstName?.capitalizeFirst ?? ""} ${(STATE(context).userData?.lastName ?? "").capitalizeFirst}",
                            style: titleApp20,
                          ),
                          const Divider(thickness: 1),
                          Column(
                            children: List.generate(
                              _data!.length,
                              (i) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const Divider(),
                                      SPACE(),
                                      SizedBox(
                                        child: Text(
                                          _data[i].name ?? "",
                                          style: titleApp16,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SPACE(),
                                      // const Divider(),
                                      Container(
                                        width: Get.width,
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                          top: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          _data[i].description ?? "",
                                          style: descriptionApp14Gray,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}

class CounselorUserTncController extends GetxController {
  TncViewResModel? tncViewResModel;
  String tncDate(String date) {
    return "${DateFormat("EEEE, dd MMMM y ").format(DateTime.parse(date))}\n${DateFormat("jm").format(DateTime.parse(date))}";
  }

  Future<void> tncView(String clientCode) async {
    WrapResponse? dataRes = await Api()
        .GET(TNC_VIEW(clientCode), useToken: true, useLoading: false);
    TncViewResModel? _res = TncViewResModel.fromJson(dataRes?.data);
    tncViewResModel = _res;
    update();
  }
}

class TncViewResModel {
  int? status;
  String? message;
  List<TncViewResData>? data;
  TncViewResModel({this.status, this.message, this.data});
  TncViewResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TncViewResData>[];
      json['data'].forEach((v) {
        data?.add(TncViewResData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class TncViewResData {
  int? id;
  int? userId;
  int? counselorId;
  String? name;
  String? description;
  int? order;
  String? createdAt;
  String? updatedAt;

  TncViewResData({
    this.id,
    this.userId,
    this.counselorId,
    this.name,
    this.description,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  TncViewResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    counselorId = json['counselor_id'];
    name = json['name'];
    description = json['description'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['counselor_id'] = counselorId;
    data['name'] = name;
    data['description'] = description;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
