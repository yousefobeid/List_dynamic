import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/form_chosse_page/form_chosse_bloc.dart';
import 'package:list_dynamic/bloc/splash/splash_bloc.dart';
import 'package:list_dynamic/core/service/database_helper.dart';
import 'package:list_dynamic/model/form_model.dart';
import 'package:list_dynamic/repo/repository_form.dart';

class AppBlocProvider {
  get allBlocProviders => [
    BlocProvider(
      create: (context) {
        final bloc = FormBloc(
          FormRepository(formModel: FormModel(elements: [], rules: [])),
          DatabaseHelper.instance,
          FormModel(elements: [], rules: []),
        );
        bloc.add(LoadFormDataEvent());
        return bloc;
      },
    ),
    BlocProvider(create: (context) => SplashBloc()),
    BlocProvider(create: (context) => FormChosseBloc(DatabaseHelper.instance)),
  ];
}
