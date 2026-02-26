import 'package:get_it/get_it.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_bloc.dart';

void registerOnboardingDependencies(GetIt sl) {
  // BLoC — registered as factory so each call creates a fresh instance
  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc());
}
