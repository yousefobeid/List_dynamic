import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_dynamic/bloc/splash/splash_bloc.dart';
import 'package:list_dynamic/bloc/splash/splash_event.dart';
import 'package:list_dynamic/bloc/splash/splash_state.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<SplashBloc>().add(SplashForm());
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToForm) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("/formPage", (route) => false);
        }
      },
      child: Scaffold(
        body: Center(child: Lottie.asset("assets/lottie/splash.json")),
      ),
    );
  }
}
