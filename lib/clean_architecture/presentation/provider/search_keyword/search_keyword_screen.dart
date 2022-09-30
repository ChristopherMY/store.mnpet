import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/keyword.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_keyword/search_keyword_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/header.dart';

class SearchKeywordScreen extends StatelessWidget {
  const SearchKeywordScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SearchKeywordBloc>(
      create: (context) => SearchKeywordBloc(
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      )..handleInitKeywords(),
      child: const SearchKeywordScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchKeywordBloc = context.read<SearchKeywordBloc>();

    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kPrimaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Header(
          showLogo: false,
          onSearch: () {},
          onField: () {},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: searchKeywordBloc.searchResults,
                  builder: (context, List<Keyword> value, child) {
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black26,
                        height: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: value.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchDetailScreen.init(
                                  context: context,
                                  keywords: value[index],
                                  typeFilter: TypeFilter.keyword,
                                  search: "",
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 15.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                // Text(value[index].name!)
                                child: searchKeywordBloc.boldTextPortion(
                                  value[index].name!,
                                  searchKeywordBloc.searchText,
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.arrow_up_left,
                                size: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
