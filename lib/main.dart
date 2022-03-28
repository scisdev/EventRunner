import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/business_logic/storage.dart';
import 'package:event_runner/ui/login/first.dart';
import 'package:event_runner/ui/main/main.dart';
import 'package:event_runner/ui/onboard/onboard.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void initSetup() {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering;

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void main() {
  initSetup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => Database(),
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EventCubit(
                RepositoryProvider.of<Database>(context),
              ),
            ),
            BlocProvider(create: (_) => ProfileCubit()),
          ],
          child: MaterialApp(
            title: 'Event Runner',
            theme: ThemeData(
              backgroundColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: ThemeColors.primary,
                error: ThemeColors.primaryRed,
                background: Colors.white,
              ),
              textTheme: const TextTheme(
                bodyText2: ThemeFonts.p1,
              ),
            ),
            home: const OnBoarding(),
          ),
        );
      }),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();

    Future(() async {
      await RepositoryProvider.of<Database>(context).init();
      final p = await LocalUser.getLocalProfile();
      if (p == null) {
        Navigator.pushReplacement(context, NavigatorPage(
          builder: (_) {
            return const Login();
          },
        ));
      } else {
        BlocProvider.of<ProfileCubit>(context).onUserLoggedIn(p);
        Navigator.pushReplacement(context, NavigatorPage(
          builder: (_) {
            return const MainScreen();
          },
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class NavigatorPage<T> extends PageRouteBuilder<T> {
  NavigatorPage({
    required WidgetBuilder builder,
  }) : super(
          pageBuilder: (context, __, ___) => builder(context),
          transitionsBuilder: (ctx, anim1, anim2, child) {
            return CupertinoPageTransition(
              child: child,
              linearTransition: false,
              primaryRouteAnimation: anim1,
              secondaryRouteAnimation: anim2,
            );
          },
        );
}
