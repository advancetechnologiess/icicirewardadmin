import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/environment.dart';
import 'package:web_admin/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(
    apiBaseUrl: 'https://example.com',
  );

  FirebaseOptions options = const FirebaseOptions(
      apiKey: "AIzaSyCs73nk6dJJBUYFq3DALrYdOuso76lSj64",
      authDomain: "icici-rewards-282d1.firebaseapp.com",
      projectId: "icici-rewards-282d1",
      storageBucket: "icici-rewards-282d1.appspot.com",
      messagingSenderId: "206554921520",
      appId: "1:206554921520:web:3923083d3f9a70ffae0bf5",
      measurementId: "G-2LT08P3XX5"
  );
  await Firebase.initializeApp(
    options: options,
  );

  runApp(const RootApp());
}
