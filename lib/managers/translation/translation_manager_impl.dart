import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:how_to_cook/common/rest/api_constants.dart';
import 'package:how_to_cook/common/rest/body_parameters.dart';
import 'package:how_to_cook/common/rest/environment_constants.dart';
import 'package:how_to_cook/common/rest/formats.dart';
import 'package:how_to_cook/common/rest/headers_constants.dart';
import 'package:how_to_cook/managers/translation/translation_manager.dart';
import 'package:http/http.dart' as http;

class TranslationManagerImpl implements TranslationManager {
  @override
  Future<String> translate(String text, String targetLanguage) async {
    final result = await _sendTranslationRequest([text], targetLanguage);
    return result.isNotEmpty ? result.first : '';
  }

  @override
  Future<List<String>> translateMany(List<String> text, String targetLanguage) {
    return _sendTranslationRequest(text, targetLanguage);
  }

  Future<List<String>> _sendTranslationRequest(List<String> text, String targetLanguage) async {
    final response = await http.post(
      Uri.https(EnvironmentConstants.deepLUrl, ApiConstants.translate),
      headers: {
        HeadersConstants.contentType: Formats.headerJson,
        HeadersConstants.authorization: 'DeepL-Auth-Key ${EnvironmentConstants.DeepLKey}',
      },
      body: jsonEncode(
        {
          BodyParameters.text: text,
          BodyParameters.targetLanguage: targetLanguage,
        },
      ),
    );

    if (response.statusCode != 200) {
      Fluttertoast.showToast(
        msg: 'Failed to translate text: ${response.statusCode} ${response.reasonPhrase}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      log('Failed to translate text: ${response.statusCode} ${response.reasonPhrase}, ${response.body}');
      return [];
    }

    final decodedBody = utf8.decode(response.bodyBytes);
    final json = List.from(jsonDecode(decodedBody)[BodyParameters.translations]);

    final result = json.map((e) => e[BodyParameters.text] as String).toList();

    return result;
  }
}
