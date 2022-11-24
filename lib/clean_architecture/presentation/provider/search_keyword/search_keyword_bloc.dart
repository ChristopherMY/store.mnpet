import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/keyword.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

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

  void handleInitKeywords(BuildContext context) async {
    if (keywords is! List<Keyword>) {
      final responseApi = await localRepositoryInterface.getKeywords();

      if (responseApi.data == null) {
        keywords = <Keyword>[];
        final statusCode = responseApi.error!.statusCode;
        if (statusCode == -1) {
          GlobalSnackBar.showWarningSnackBar(context, kNoInternet);
        }
      }

      keywords = (responseApi.data as List).map((x) => Keyword.fromMap(x)).toList();
    }
  }

  void handleSubmitSearch({
    required BuildContext context,
    required String searchText,
  }) {
    if (searchText.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SearchDetailScreen.init(
              context: context,
              search: searchText,
              typeFilter: TypeFilter.search,
            );
          },
        ),
      );
    }
  }

  void onSearchTextChanged({required String text}) {
    searchText = text.toLowerCase();
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
