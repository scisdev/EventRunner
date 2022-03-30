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
        child: Column(
          children: [
            Avatar(state.currentUser),
            const SizedBox(height: 24),
            Text(state.currentUser.displayName, style: ThemeFonts.h2),
          ],
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

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
