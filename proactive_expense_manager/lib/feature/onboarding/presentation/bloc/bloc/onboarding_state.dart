import 'package:proactive_expense_manager/feature/onboarding/data/models/onboarding_content_model.dart';

class OnboardingState {
  final int currentPage;

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == onboardingData.length - 1;

  const OnboardingState({this.currentPage = 0});
}
