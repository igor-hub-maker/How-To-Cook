import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/constants.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/widgets/pages/more/more_cubit.dart';
import 'package:how_to_cook/widgets/pages/more/more_state.dart';
import 'package:how_to_cook/widgets/views/loading_indicator.dart';
import 'package:injector/injector.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final screenCubit = MoreCubit();

  @override
  void initState() {
    screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MoreCubit, MoreState>(
        bloc: screenCubit,
        listener: (BuildContext context, MoreState state) {
          if (state.error != null) {
            log("More page error: ${state.error!}");
          }
        },
        builder: (BuildContext context, MoreState state) {
          if (state.isLoading) {
            return const LoadingIndicator();
          }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(MoreState state) {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                if (Platform.isAndroid) const SizedBox(height: 36),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.colorScheme.primary,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      "assets/images/app_icon.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                InkWell(
                  onTap: changeLocale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: AppColors.colorScheme.primary,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.ChangeLanguage.tr(),
                          style: TextStyle(
                            fontFamily: Fonts.Comfortaa,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorScheme.primary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  LocaleKeys.DevelopedBy.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.Comfortaa,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorScheme.primary.withOpacity(0.6),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => screenCubit.openLink(Constants.githubLink),
                      icon: SvgPicture.asset(
                        'assets/images/ic_github.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                          AppColors.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => screenCubit.openLink(Constants.emailLink),
                      icon: Icon(
                        Icons.email_outlined,
                        size: 40,
                        color: AppColors.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => screenCubit.openLink(Constants.instagramLink),
                      icon: SvgPicture.asset(
                        'assets/images/ic_instagram.svg',
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(
                          AppColors.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> changeLocale() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.ChangeLanguage.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              context.supportedLocales.length,
              (index) {
                final locale = context.supportedLocales[index];
                return ListTile(
                  title: Text(
                    switch (locale.languageCode) {
                      'en' => LocaleKeys.English.tr(),
                      'uk' => LocaleKeys.Ukrainian.tr(),
                      'de' => LocaleKeys.German.tr(),
                      _ => ""
                    },
                  ),
                  trailing: locale == context.locale ? const Icon(Icons.check) : null,
                  onTap: () {
                    context.setLocale(locale);

                    Constants.currentLocale = locale.languageCode;
                    screenCubit.productsCartManager.localizeCartItems();

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      );
}
