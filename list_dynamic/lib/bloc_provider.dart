import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/form/form_bloc.dart';
import 'package:list_dynamic/bloc/form/form_event.dart';
import 'package:list_dynamic/bloc/splash/splash_bloc.dart';
import 'package:list_dynamic/repo/repository_form.dart';

class AppBlocProvider {
  get allBlocProviders => [
    BlocProvider(
      create: (context) {
        final bloc = FormBloc(FormRepository());
        bloc.add(LoadFormDataEvent());
        return bloc;
      },
    ),
    BlocProvider(create: (context) => SplashBloc()),
  ];
}
