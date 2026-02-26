import 'package:proactive_expense_manager/gen/assets.gen.dart';

class OnboardingContent {
  final String title;
  final String subtitle;
  final AssetGenImage image;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

final List<OnboardingContent> onboardingData = [
  OnboardingContent(
    title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
    subtitle: 'No ads. No trackers. No third-party analytics.',
    image: Assets.images.onboarding,
  ),
  OnboardingContent(
    title: 'Insights That Help You Spend Better Without Complexity',
    subtitle: 'See category-wise spending, recent activity.',
    image: Assets.images.onboarding,
  ),
  OnboardingContent(
    title: 'Local-First Tracking That Stays Fully On Your Device',
    subtitle: 'Your finances stay on your phone.',
    image: Assets.images.onboarding,
  ),
];
