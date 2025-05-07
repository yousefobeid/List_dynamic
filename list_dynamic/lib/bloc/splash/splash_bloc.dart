import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/splash/splash_event.dart';
import 'package:list_dynamic/bloc/splash/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashForm>((event, emit) async {
      emit(SplashLoading());

      await Future.delayed(const Duration(seconds: 5));

      emit(SplashNavigateToForm());
    });
  }
}
