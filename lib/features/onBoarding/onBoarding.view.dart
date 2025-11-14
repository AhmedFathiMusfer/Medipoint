import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        page.image,
                        height: 470.h,
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
                      30.verticalSpace,
                      Text(
                        page.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          page.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: SimpleButton(
                text:
                    _currentPage == onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Next',
                onPressed: () {
                  if (_currentPage < onboardingPages.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.pushReplacementNamed(Routers.registrationView);
                  }
                },
              ),
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardingPages.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 30 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.r),
                    color:
                        _currentPage == index
                            ? Color.fromRGBO(38, 35, 47, 1)
                            : Color.fromRGBO(155, 155, 155, 1),
                  ),
                );
              }),
            ),
            20.verticalSpace,
            TextButton(
              onPressed: () {
                context.pushReplacementNamed(Routers.registrationView);
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    image: 'assets/image/first_on_obourding_image.png',
    title: 'Meet Doctors Online',
    description:
        'Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.',
  ),
  OnboardingPage(
    image: 'assets/image/sconde_on_obourding_image.png',
    title: 'Connect with Specialists',
    description:
        'Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.',
  ),
  OnboardingPage(
    image: 'assets/image/final_on_obourding_image.png',
    title: 'Thousands of Online Specialists',
    description:
        'Explore a Vast Array of Online Medical Specialists, Offering an Extensive Range of Expertise Tailored to Your Healthcare Needs.',
  ),
];

class OnboardingPage {
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}
