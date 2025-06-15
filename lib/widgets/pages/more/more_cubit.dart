import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/managers/products_cart/products_cart_manager.dart';
import 'package:how_to_cook/widgets/pages/more/more_state.dart';
import 'package:injector/injector.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(const MoreState(isLoading: true));

  late ProductsCartManager productsCartManager;

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      productsCartManager = Injector.appInstance.get<ProductsCartManager>();

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> openLink(String link) async {
    final url = Uri.parse(link);
    final isCanLaunchUrl = await canLaunchUrl(url);
    if (isCanLaunchUrl) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: LocaleKeys.BrowserOpenFail.tr());
      Clipboard.setData(ClipboardData(text: link));
    }
  }
}
