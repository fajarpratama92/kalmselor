import 'package:firebase_core/firebase_core.dart';

import '../api/api.dart';

/// FIREBASE
var iosFirebaseOption = IsStaging ? const FirebaseOptions(
  apiKey: 'AIzaSyAuei8OWk--zvCUdR-LBcLyh9frXp0rBBg',
  appId: '1:626350561336:ios:707e2e31278d3dfe6f6ecd',
  messagingSenderId: '626350561336',
  projectId: 'kalm-counselor-202007',
  databaseURL: 'https://kalm-counselor-202007.firebaseio.com',
  storageBucket: 'kalm-counselor-202007.appspot.com',
) : const FirebaseOptions(
  apiKey: 'AIzaSyAaPpgNbcfWnXMkUJGzwpl-lD_nlBCNPi4',
  appId: '1:134928977447:ios:827236cf421c2687',
  messagingSenderId: '134928977447',
  projectId: 'kalm-6da40',
  databaseURL: 'https://kalm-6da40.firebaseio.com',
  storageBucket: 'kalm-6da40.appspot.com',
);
var androidFirebaseOption = IsStaging ? const FirebaseOptions(
  apiKey: 'AIzaSyAuei8OWk--zvCUdR-LBcLyh9frXp0rBBg',
  appId: '1:626350561336:android:8d0cc5daf4ff06996f6ecd',
  messagingSenderId: '626350561336',
  projectId: 'kalm-counselor-202007',
  databaseURL: 'https://kalm-counselor-202007.firebaseio.com',
  storageBucket: 'kalm-counselor-202007.appspot.com',
) : const FirebaseOptions(
  apiKey: 'AIzaSyAaPpgNbcfWnXMkUJGzwpl-lD_nlBCNPi4',
  appId: '1:134928977447:android:763f0f228fac7813',
  messagingSenderId: '134928977447',
  projectId: 'kalm-6da40',
  databaseURL: 'https://kalm-6da40.firebaseio.com',
  storageBucket: 'kalm-6da40.appspot.com',
);
