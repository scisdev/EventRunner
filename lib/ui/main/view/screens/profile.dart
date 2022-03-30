import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (ctx, state) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Avatar(state.currentUser),
              const SizedBox(height: 24),
              Text(state.currentUser.displayName, style: ThemeFonts.h2),
              const SizedBox(height: 24),
              const ProfileInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final Profile profile;

  const Avatar(this.profile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width / 3,
      child: ClipPath(
        clipper: const ShapeBorderClipper(
          shape: CircleBorder(),
        ),
        child: CachedNetworkImage(
          imageUrl: profile.avatarUrl,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Center(
            child: SizedBox.square(
              dimension: 15,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.profileInfo == null) return const SizedBox();

        return Row(
          children: [
            Expanded(
              child: Center(
                child: item(
                  'Мероприятия',
                  state.profileInfo!.createdEvents.length,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: item(
                  'Пройденных',
                  state.profileInfo!.attendedEvents.length,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: item('Достижения', 123),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget item(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: ThemeFonts.h2,
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: ThemeFonts.s,
        ),
      ],
    );
  }
}
