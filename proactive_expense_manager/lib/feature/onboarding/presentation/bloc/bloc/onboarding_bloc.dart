import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_event.dart';
import 'package:proactive_expense_manager/feature/onboarding/presentation/bloc/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>((event, emit) {
      emit(OnboardingState(currentPage: event.pageIndex));
    });
  }
}
