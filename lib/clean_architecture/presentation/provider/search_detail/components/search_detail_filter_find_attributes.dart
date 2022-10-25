import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';

class SearchDetailFilterFindAttributes extends StatelessWidget {
  const SearchDetailFilterFindAttributes._({
    Key? key,
  }) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SearchDetailBloc>.value(
      value: context.read<SearchDetailBloc>(),
      builder: (_, __) {
        return const SearchDetailFilterFindAttributes._();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchDetailBloc = context.read<SearchDetailBloc>();
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: searchDetailBloc.searchResults,
        builder: (_, List<Term> terms, __) {
          return Scaffold(
            backgroundColor: kBackGroundColor,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              centerTitle: false,
              title: Text(
                searchDetailBloc.attributeSelected.pluralName!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              actions: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Badge(
                      position: const BadgePosition(
                        top: -15,
                        isCenter: false,
                        end: -15,
                      ),
                      animationType: BadgeAnimationType.slide,
                      badgeContent: SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: Text(
                          "${terms.where((element) => element.checked == true).length}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      elevation: 2,
                      toAnimate: true,
                      child: const Icon(Icons.playlist_add_check),
                    ),
                  ),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(15.0),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          controller: searchDetailBloc.searchEditingController,
                          keyboardType: TextInputType.text,
                          onChanged: searchDetailBloc.onChangeSearchAttr,
                          onSubmitted: searchDetailBloc.onSubmittedSearchAttr,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.black.withOpacity(.75),
                                    height: 1.4,
                                  ),
                          decoration: InputDecoration(
                            hintText: "Buscar...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(bottom: 0.0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(.75),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: searchDetailBloc.onClearSearchAttr,
                              child: Icon(
                                Icons.clear,
                                color: Colors.black.withOpacity(searchDetailBloc
                                        .searchEditingController.text.isEmpty
                                    ? 0
                                    : 0.75),
                              ),
                            ),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(height: 1.4),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorStyle: const TextStyle(height: 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // *******************
                // List Terms from Product Variation
                // *******************

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: terms.length,
                      (context, index) {
                        final term = terms[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: CheckboxListTile(
                            value: term.checked,
                            tileColor: Colors.white,
                            title: Text(
                              term.label!,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            secondary: Container(
                              width: 25,
                              height: 25,
                              color: Color(int.parse("0XFF${term.hexa!}")),
                            ),
                            activeColor: kPrimaryColor,
                            dense: true,
                            enableFeedback: false,
                            isThreeLine: false,
                            tristate: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                              side: const BorderSide(color: Colors.black12),
                            ),
                            onChanged: (bool? value) {
                              searchDetailBloc.onChangeCheckBoxTerm(
                                index,
                                value,
                              );
                            },
                            // contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
