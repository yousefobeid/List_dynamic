import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form_bloc.dart';
import 'package:list_dynamic/bloc/form_event.dart';
import 'package:list_dynamic/repo/repository_form.dart';
import 'package:list_dynamic/view/screen/form_page.dart';
import 'package:list_dynamic/view/screen/form_review_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = FormBloc(FormRepository());
        bloc.add(LoadFormDataEvent());
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: FormPage(),
        routes: {'/formPageReview': (context) => FormReviewPage()},
      ),
    );
  }
}
