import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../widgets/profile_skeleton.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_menu_item.dart';
import 'language_settings_page.dart';
import 'theme_settings_page.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        getProfileUseCase: GetProfileUseCase(
          ProfileRepositoryImpl(
            remoteDataSource: ProfileRemoteDataSourceImpl(),
          ),
        ),
      )..add(LoadProfile()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const ProfileSkeleton();
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            profile.fullName.length >= 2
                                                ? profile.fullName
                                                      .substring(0, 2)
                                                      .toUpperCase()
                                                : profile.fullName
                                                      .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppTheme.secondaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  profile.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Personal Details Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.personalDetails,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.personalDetailsSubtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      color: AppTheme.secondaryColor,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.l10n.editDetails,
                                      style: const TextStyle(
                                        color: AppTheme.secondaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Personal Details Card
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  icon: Icons.person,
                                  title: context.l10n.fullName,
                                  subtitle: profile.fullName,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.2),
                                  indent: 64,
                                  endIndent: 16,
                                ),
                                ProfileMenuItem(
                                  icon: Icons.email,
                                  title: context.l10n.email,
                                  subtitle: profile.email,
                                  trailing: profile.isEmailVerified
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.secondaryColor
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                context.l10n.verified,
                                                style: const TextStyle(
                                                  color:
                                                      AppTheme.secondaryColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : null,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.2),
                                  indent: 64,
                                  endIndent: 16,
                                ),
                                ProfileMenuItem(
                                  icon: Icons.phone,
                                  title: context.l10n.phone,
                                  subtitle: profile.phone,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.2),
                                  indent: 64,
                                  endIndent: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // General Settings Header
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.generalSettings,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.generalSettingsSubtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // General Settings Card
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                BlocBuilder<LocaleCubit, Locale>(
                                  builder: (context, locale) {
                                    final languageName =
                                        locale.languageCode == 'id'
                                            ? 'Bahasa Indonesia'
                                            : 'English (US)';
                                    return ProfileMenuItem(
                                      icon: Icons.language,
                                      title: context.l10n.language,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            languageName,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withValues(alpha: 0.6),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LanguageSettingsPage(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                                Divider(
                                  height: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.2),
                                  indent: 64,
                                  endIndent: 16,
                                ),
                                BlocBuilder<ThemeCubit, ThemeMode>(
                                  builder: (context, themeMode) {
                                    String themeText =
                                        context.l10n.systemDefault;
                                    if (themeMode == ThemeMode.light) {
                                      themeText = context.l10n.lightMode;
                                    } else if (themeMode == ThemeMode.dark) {
                                      themeText = context.l10n.darkMode;
                                    }
                                    return ProfileMenuItem(
                                      icon: Icons.brightness_6,
                                      title: context.l10n.theme,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            themeText,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withValues(alpha: 0.6),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ThemeSettingsPage(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withValues(alpha: 0.2),
                                  indent: 64,
                                  endIndent: 16,
                                ),
                                ProfileMenuItem(
                                  icon: Icons.notifications,
                                  title: context.l10n.notifications,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        context.l10n.enabled,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withValues(alpha: 0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign Out Button
                          CustomButton(
                            text: context.l10n.signOut,
                            backgroundColor: Colors.red,
                            onPressed: () {
                              CustomDialog.showWarning(
                                context,
                                title: context.l10n.signOut,
                                message: context.l10n.signOutConfirmation,
                                confirmText: context.l10n.signOut,
                                cancelText: context.l10n.cancel,
                                onConfirm: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
