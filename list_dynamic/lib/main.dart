import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc_provider.dart';
import 'package:list_dynamic/service/sync_manager.dart';
import 'package:list_dynamic/view/screen/form_choice_page.dart';
import 'package:list_dynamic/view/screen/form_page.dart';
import 'package:list_dynamic/view/screen/form_review_page.dart';
import 'package:list_dynamic/view/screen/form_splash_page.dart';
import 'package:list_dynamic/view/screen/form_view_information.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SyncManagers().startSyncTimer();
  await Firebase.initializeApp();

  // final dbPath = await getDatabasesPath();
  // final path = join(dbPath, 'form_data.db');
  // await deleteDatabase(path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AppBlocProvider().allBlocProviders],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: SplashScreen(),
        routes: {
          '/formPage': (context) => FormPage(),
          '/formPageReview': (context) => FormReviewPage(),
          '/formChoicePag': (context) => FormChoicePage(),
          '/pageViewInformation': (context) => PageViewInformation(data: []),
        },
      ),
    );
  }
}
