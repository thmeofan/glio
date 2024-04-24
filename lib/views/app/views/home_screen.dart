import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../consts/app_colors.dart';
import '../../../data/model/news_model.dart';
import '../../news/views/news_screen.dart';
import '../../operation/views/finance_screen.dart';
import '../../quiz/views/quiz_screen.dart';
import '../../settings/views/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> homeWidgets = [
    FinanceScreen(),
    NewsScreen(
      newsModel: news,
    ),
    QuizScreen(),
    SettingsScreen(),
    // const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.blackColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: homeWidgets[currentIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/finance.svg',
                  width: size.height * 0.025,
                  height: size.height * 0.025,
                  color: currentIndex == 0
                      ? AppColors.lightBlueColor
                      : AppColors.whiteColor,
                ),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/news.svg',
                  width: size.height * 0.025,
                  height: size.height * 0.025,
                  color: currentIndex == 1
                      ? AppColors.lightBlueColor
                      : AppColors.whiteColor,
                ),
                label: 'news',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/quiz.svg',
                    width: size.height * 0.025,
                    height: size.height * 0.025,
                    color: currentIndex == 2
                        ? AppColors.lightBlueColor
                        : AppColors.whiteColor,
                  ),
                  label: 'quiz'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    width: size.height * 0.025,
                    height: size.height * 0.025,
                    color: currentIndex == 3
                        ? AppColors.lightBlueColor
                        : AppColors.whiteColor,
                  ),
                  label: 'settings'),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.darkBlueColor,
            unselectedItemColor: AppColors.whiteColor,
            selectedItemColor: AppColors.darkBlueColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
                // color: AppColors.lightBlueColor,
                ),
            unselectedLabelStyle: const TextStyle(
              color: AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
