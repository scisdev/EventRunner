import 'package:event_runner/business_logic/api/scan_qr_api.dart';
import 'package:event_runner/business_logic/cubit/scan_qr/cubit.dart';
import 'package:event_runner/main.dart';
import 'package:event_runner/ui/add_event/add_event.dart';
import 'package:event_runner/ui/main/view/screens/home.dart';
import 'package:event_runner/ui/main/view/screens/profile.dart';
import 'package:event_runner/ui/scan_qr/view.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../business_logic/cubit/cubit.dart';

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
  SelectedScreen _selectedScreen = Main(false);

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
                child: _selectedScreen.mapToWidget,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MainAppBar(_selectedScreen.mapToPosition),
            ),
          ],
        ),
      ),
    );
  }

  void goToMainScreen(bool loadData) {
    if (_selectedScreen is Main) return;
    setState(() {
      _selectedScreen = Main(loadData);
    });
  }

  void goToEventCreation() {
    if (_selectedScreen is CreateEvent) return;
    setState(() {
      _selectedScreen = CreateEvent();
    });
  }

  void goToProfile() {
    if (_selectedScreen is Profile) return;
    setState(() {
      _selectedScreen = Profile();
    });
  }

  void goToQrScan() {
    Navigator.of(context).push(NavigatorPage(builder: (_) {
      return BlocProvider<QrScanCubit>(
        create: (_) => QrScanCubit(
          ScanQrApiDBImpl(
            RepositoryProvider.of<Database>(context),
          ),
        ),
        child: const QrView(),
      );
    }));
  }
}

class MainAppBar extends StatelessWidget {
  final int selected;

  const MainAppBar(this.selected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (ctx, vis) {
        return IgnorePointer(
          ignoring: vis,
          child: AnimatedOpacity(
            child: bar(ctx),
            duration: const Duration(milliseconds: 200),
            opacity: vis ? 0 : 1,
          ),
        );
      },
    );
  }

  Widget bar(BuildContext context) {
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
              item(
                context,
                0,
                'Главная',
                ThemeDrawable.home,
                () {
                  MainScreen.of(context).goToMainScreen(false);
                },
              ),
              item(
                context,
                1,
                'Создать',
                ThemeDrawable.edit,
                () {
                  MainScreen.of(context).goToEventCreation();
                },
              ),
              item(
                context,
                2,
                'QR-сканнер',
                null,
                () {
                  MainScreen.of(context).goToQrScan();
                },
              ),
              item(
                context,
                3,
                'События',
                ThemeDrawable.notifications,
                () {},
              ),
              item(
                context,
                4,
                'Профиль',
                ThemeDrawable.profile,
                () {
                  MainScreen.of(context).goToProfile();
                },
              ),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              MainScreen.of(context).goToQrScan();
            },
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
        ),
      ]),
    );
  }

  Widget item(
    BuildContext context,
    int position,
    String name,
    String? iconPath,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Column(children: [
            const Spacer(),
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                color: position == selected ? ThemeColors.primary : null,
              ),
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

abstract class SelectedScreen {
  Widget get mapToWidget {
    if (this is Main) {
      return HomeScreen(forceLoadData: (this as Main).loadData);
    } else if (this is CreateEvent) {
      return const CreateEventPage();
    } else if (this is Profile) {
      return const ProfileScreen();
    } else {
      throw UnimplementedError();
    }
  }

  int get mapToPosition {
    if (this is Main) {
      return 0;
    } else if (this is CreateEvent) {
      return 1;
    } else if (this is Profile) {
      return 4;
    } else {
      throw UnimplementedError();
    }
  }
}

class Main extends SelectedScreen {
  final bool loadData;

  Main(this.loadData);
}

class CreateEvent extends SelectedScreen {}

class Profile extends SelectedScreen {}
