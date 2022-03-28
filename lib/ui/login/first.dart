import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/main.dart';
import 'package:event_runner/ui/login/cubit/login_cubit.dart';
import 'package:event_runner/ui/login/cubit/login_state.dart';
import 'package:event_runner/ui/main/main.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(RepositoryProvider.of<Database>(context)),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (ctx, state) {
          if (state is LoginSuccess) {
            BlocProvider.of<ProfileCubit>(context).onUserLoggedIn(
              state.profileFromBackend,
            );

            Navigator.pushReplacement(
              context,
              NavigatorPage(builder: (_) {
                return const MainScreen();
              }),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorDescription),
            ));
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: const Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: SingleChildScrollView(
                  child: Screen(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  bool obscuring = true;

  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    mailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 120),
        const Text(
          'Добро пожаловать!',
          style: ThemeFonts.h1,
        ),
        const SizedBox(height: 8),
        const Text(
          'Пожалуйста, войдите в аккаунт',
          style: ThemeFonts.p2,
        ),
        const SizedBox(height: 32),
        InputField(
          controller: mailController,
          hintText: 'Адрес почты',
          keyboardType: TextInputType.emailAddress,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: SvgPicture.asset(
              ThemeDrawable.emailIcon,
              height: 17,
              width: 20,
            ),
          ),
        ),
        const SizedBox(height: 16),
        InputField(
          controller: passController,
          hintText: 'Пароль',
          keyboardType: TextInputType.visiblePassword,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: SvgPicture.asset(
              ThemeDrawable.passwordIcon,
              height: 17,
              width: 20,
            ),
          ),
          obscureText: obscuring,
          postfix: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                obscuring = !obscuring;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset(
                ThemeDrawable.obscuringIcon,
                height: 17,
                width: 20,
                color: obscuring ? ThemeColors.mainText : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Забыли пароль?',
            style: ThemeFonts.p2,
          ),
        ),
        const SizedBox(height: 72),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return AccentButton(
              content: Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Войти'),
                  ),
                  if (state is LoginLoading)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              onTap: state is LoginLoading
                  ? null
                  : () {
                      BlocProvider.of<LoginCubit>(context).tryLogin(
                        mailController.text,
                        passController.text,
                      );
                    },
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Или продолжить с помощью',
          style: ThemeFonts.p2,
        ),
        const SizedBox(height: 24),
        AccentButton(
          color: ThemeColors.primaryRed,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ThemeDrawable.googleIcon,
              ),
              const SizedBox(width: 4),
              Text(
                'Google',
                style: ThemeFonts.p2.copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Не торопи коней! Всё будет, но позже, ок?'),
            ));
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ещё нет аккаунта?',
              style: ThemeFonts.p2.copyWith(
                color: ThemeColors.mainText,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Скоро сделаю, расслабься'),
                ));
              },
              child: Text(
                'Регистрация',
                style: ThemeFonts.p2.copyWith(
                  color: ThemeColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 75),
      ],
    );
  }
}
