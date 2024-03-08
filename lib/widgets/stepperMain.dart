import 'package:flutter/material.dart';
import 'package:mealready/utils/appTheme.dart';

class MyStepperWidget extends StatefulWidget {
  @override
  _MyStepperWidgetState createState() => _MyStepperWidgetState();
}

class _MyStepperWidgetState extends State<MyStepperWidget> {
  int _currentStep = 0;
  PageController _pageController = PageController();

  // Sample titles for each step
  final List<String> stepTitles = [
    'Choose your preferred meal',
    'Add flat members in your group',
    'Order a group meal and get discount all time',
    'Enable auto-order and get meals regularly',
    'We will deliver your meal in time',
  ];

  // Sample images for each step
  final List<String> stepImages = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  // Function to preload images
  void _precacheImages() {
    for (String imagePath in stepImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the function to preload images
    _precacheImages();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.only(
                top: 28.0,
              ),
              child: const Text(
                'How it works!',
                style: TextStyle(
                  fontSize: text3xl,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: stepImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    stepImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60.0,
              child: Text(
                _currentStep < stepTitles.length
                    ? stepTitles[_currentStep]
                    : '',
                style: TextStyle(
                  fontSize: text2xl,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 4) {
                  setState(() {
                    _currentStep += 1;
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                }
              },
              steps: List.generate(
                5,
                (index) => Step(
                  title: const SizedBox.shrink(),
                  content: Container(),
                  isActive: _currentStep == index,
                ),
              ),
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
                String continueLabel =
                    _currentStep < 4 ? 'Continue' : 'Visit Home';
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed:
                          _currentStep > 0 ? controls.onStepCancel : null,
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 4) {
                          controls.onStepContinue?.call();
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed('/screens/home');
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        child: Center(
                          child: Text(
                            continueLabel,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
