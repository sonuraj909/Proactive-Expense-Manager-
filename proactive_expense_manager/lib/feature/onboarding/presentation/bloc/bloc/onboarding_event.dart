abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;
  const OnboardingPageChanged(this.pageIndex);
}
