import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/keyword.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';

class SearchKeywordBloc extends ChangeNotifier {
  LocalRepositoryInterface localRepositoryInterface;

  SearchKeywordBloc({
    required this.localRepositoryInterface,
  });

  TextEditingController searchController = TextEditingController();
  dynamic keywords;
  String searchText = "";
  ValueNotifier<List<Keyword>> searchResults = ValueNotifier(<Keyword>[]);
  ValueNotifier<List<Text>> textSearchResult = ValueNotifier(<Text>[]);

  void handleInitKeywords() async {
    if (keywords is! List<Keyword>) {
      final response = await localRepositoryInterface.getKeywords();
      if (response is http.Response) {
        if (response.statusCode == 200) {
          final decode = jsonDecode(response.body);
          keywords =
              decode.map((element) => Keyword.fromMap(element)).toList().cast();
          return;
        }
      }

      keywords = <Keyword>[];
    }
  }

  void handleSubmitSearch({
    required BuildContext context,
    required String searchText,
  }) {
    if (searchText.isNotEmpty) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => MainProductList(
      //       categorySlug: "",
      //       title: searchText,
      //       search: searchText,
      //       keywordSlug: "",
      //       relations: [],
      //     ),
      //   ),
      // );
    }
  }

  void onSearchTextChanged({required String text}) {
    searchText = text;
    List<Keyword> values = List.from(searchResults.value);
    values.clear();
    if (text.isEmpty || text == "") {
      return;
    }

    for (var keywordDetail in keywords) {
      if (keywordDetail.name.toLowerCase().contains(text.toLowerCase())) {
        values.add(keywordDetail);
      } else {
        continue;
      }
    }

    searchResults.value = values;
  }

  Text boldTextPortion(
    String fullText,
    String textToBold,
  ) {
    final texts = fullText.split(textToBold);
    final textSpans = List.empty(growable: true);

    texts.asMap().forEach(
      (index, value) {
        textSpans.add(TextSpan(text: value));
        if (index < (texts.length - 1)) {
          textSpans.add(
            TextSpan(
              text: textToBold,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );

    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }
}
