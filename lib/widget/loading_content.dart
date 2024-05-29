import 'package:counselor/widget/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/widget/loading.dart';

// Widget LOADING({required BuildContext context}) => Center(
//     child: SizedBox(
//         height: 100, width: 100, child: Loading().LOADING_ICON(context)));

Widget LOADING({required BuildContext context}) => CustomWaiting().defaut();
