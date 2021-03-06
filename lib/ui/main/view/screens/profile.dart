import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/business_logic/cubit/cubit.dart' as c;
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/main/widgets/widgets.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ProfileCubit>(context).loadInfo(reload: true);
        },
        child: CustomScrollView(
          slivers: [
            const SliverList(
              delegate: SliverChildListDelegate.fixed([
                ShareButton(),
                Avatar(),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: ProfileInfo(),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                CustomDivider(),
              ]),
            ),
            BlocBuilder<ProfileCubit, ProfileState>(builder: (ctx, state) {
              if (state.status.isLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state.status.isFailure) {
                return SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('???????????? ?????? ?????????????????? QR-??????????'),
                      const SizedBox(height: 24),
                      AccentButton(
                        content: const Text('?????????????????? ??????????????'),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              } else {
                return const SliverToBoxAdapter();
              }
            }),
            BlocBuilder<ProfileCubit, ProfileState>(builder: (ctx, state) {
              if (state.status.isSuccess) {
                return SliverStickyHeader(
                  header: const HeaderWithDivider('??????????????????????'),
                  sliver: CreatedEvents(state.profileInfo!.createdEvents),
                );
              } else {
                return const SliverToBoxAdapter();
              }
            }),
            BlocBuilder<ProfileCubit, ProfileState>(builder: (ctx, state) {
              if (state.status.isSuccess) {
                return SliverStickyHeader(
                  header: const HeaderWithDivider('???????????????????? ??????????????????????'),
                  sliver: AttendedEvents(state.profileInfo!.attendedEvents),
                );
              } else {
                return const SliverToBoxAdapter();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share!'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<c.ProfileCubit, c.ProfileState>(
      builder: (ctx, state) {
        return Column(
          children: [
            SizedBox.square(
              dimension: MediaQuery.of(context).size.width / 3,
              child: ClipPath(
                clipper: const ShapeBorderClipper(
                  shape: CircleBorder(),
                ),
                child: CachedNetworkImage(
                  imageUrl: state.currentUser.avatarUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                state.currentUser.displayName,
                style: ThemeFonts.h2,
              ),
            ),
          ],
        );
      },
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
    BlocProvider.of<c.ProfileCubit>(context).loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<c.ProfileCubit, c.ProfileState>(
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
                  '??????????????????????',
                  state.profileInfo!.createdEvents.length,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: item(
                  '????????????????????',
                  state.profileInfo!.attendedEvents.length,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: item(
                  '????????????????????',
                  state.profileInfo!.achievements.length,
                ),
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

class HeaderWithDivider extends StatelessWidget {
  final String title;

  const HeaderWithDivider(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          color: ThemeColors.background,
          child: Center(
            child: Text(
              title,
              style: ThemeFonts.h2,
            ),
          ),
        ),
        Container(
          height: 3,
          width: double.infinity,
          color: ThemeColors.primary,
        ),
      ],
    );
  }
}

class CreatedEvents extends StatelessWidget {
  final List<Event> events;
  const CreatedEvents(this.events, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 320,
          crossAxisSpacing: 26,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => EventEntry(
            events[i],
          ),
          childCount: events.length,
        ),
      ),
    );
  }

  Widget loading() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ]),
    );
  }

  Widget empty() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 24.0,
          ),
          child: Center(
            child: Text(
              '???? ???????? ?????? ???? ?????????????? ???? ???????????? ??????????????????????',
              textAlign: TextAlign.center,
              style: ThemeFonts.s,
            ),
          ),
        )
      ]),
    );
  }

  Widget somethingsWrong() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([]),
    );
  }
}

class AttendedEvents extends StatelessWidget {
  final List<Event> events;
  const AttendedEvents(this.events, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: 120.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => EventEntryMini(
            events[i],
          ),
          childCount: events.length,
        ),
      ),
    );
  }

  Widget loading() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ]),
    );
  }

  Widget empty() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 24.0,
          ),
          child: Center(
            child: Text(
              '???? ???????? ?????? ???? ?????????????? ???? ???????????? ??????????????????????',
              textAlign: TextAlign.center,
              style: ThemeFonts.s,
            ),
          ),
        )
      ]),
    );
  }

  Widget somethingsWrong() {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([]),
    );
  }
}
