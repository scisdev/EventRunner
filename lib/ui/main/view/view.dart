import 'package:event_runner/ui/main/view/screens/home.dart';
import 'package:event_runner/ui/main/view/screens/profile.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();

  static _MainScreenState of(BuildContext context) {
    final res = context.findAncestorStateOfType<_MainScreenState>();
    if (res == null) {
      throw Exception('Could not find _MainScreenState above this Context!');
    }

    return res;
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: SizedBox.expand(
                key: ValueKey(_selectedScreen),
                child: _selectChild(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MainAppBar(_selectedScreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectChild() {
    if (_selectedScreen == 0) {
      return const HomeScreen();
    } else {
      return const ProfileScreen();
    }
  }

  void selectScreen(int screen) {
    setState(() {
      _selectedScreen = screen;
    });
  }
}

class MainAppBar extends StatelessWidget {
  final int selected;

  const MainAppBar(this.selected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: 120,
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 95,
            color: ThemeColors.background,
            alignment: Alignment.topCenter,
            child: Row(children: [
              item(context, 0, 'Главная', ThemeDrawable.home),
              item(context, 1, 'Создать', ThemeDrawable.edit),
              item(context, 2, 'QR-сканнер', null),
              item(context, 3, 'События', ThemeDrawable.notifications),
              item(context, 4, 'Профиль', ThemeDrawable.profile),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: ThemeColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(ThemeDrawable.qrScan),
            ),
          ),
        ),
      ]),
    );
  }

  Widget item(BuildContext context, int num, String name, String? iconPath) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          MainScreen.of(context).selectScreen(num);
        },
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Column(children: [
            const Spacer(),
            if (iconPath != null) SvgPicture.asset(iconPath),
            const Spacer(),
            Text(
              name,
              style: ThemeFonts.s.copyWith(
                color: ThemeColors.secondaryText,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
