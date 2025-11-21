import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';
import 'package:om_paie_flutter/ui/widgets/carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/login_form_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_form_section.dart';

void main() {
  runApp(const OrangeMoneyApp());
}

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CarouselSection(
            pageController: _pageController,
            currentPage: _currentPage,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          LoginFormSection(
            currentPage: _currentPage,
            phoneController: _phoneController,
            pageController: _pageController,
            onLoginPressed: () {
              if (_phoneController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute<PinCodeScreen>(
                    builder: (BuildContext context) => PinCodeScreen(
                      phoneNumber: _phoneController.text,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }




}

// Écran de saisie du code PIN à 4 chiffres
class PinCodeScreen extends StatefulWidget {
  final String phoneNumber;

  const PinCodeScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PinCarouselSection(),
          PinFormSection(phoneNumber: widget.phoneNumber),
        ],
      ),
    );
  }


}