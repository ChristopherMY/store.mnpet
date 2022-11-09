import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_keyword/search_keyword_bloc.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.showLogo,
    required this.onSearch,
    required this.onField,
  }) : super(key: key);

  final bool showLogo;
  final VoidCallback onSearch;
  final VoidCallback onField;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late SearchKeywordBloc searchKeywordBloc;

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();

    if (!widget.showLogo) {
      searchKeywordBloc = context.read<SearchKeywordBloc>();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.showLogo
              ? SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                height: 40.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 2.5,
                    right: 2.5,
                    bottom: 2.5,
                    left: 10.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: widget.showLogo
                            ? GestureDetector(
                                onTap: widget.onSearch,
                                child: Text(
                                  "Buscar...",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.65),
                                    fontSize: 14.0,
                                  ),
                                ),
                              )
                            : TextField(
                                controller: searchKeywordBloc.searchController,
                                keyboardType: TextInputType.text,
                                autofocus: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      height: 1.5,
                                      color: Colors.black.withOpacity(.65),
                                    ),
                                decoration: InputDecoration(
                                  hintText: 'Buscar...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 8.0),
                                  alignLabelWithHint: true,
                                  isCollapsed: false,
                                ),
                                onChanged: (value) {
                                  if (!widget.showLogo) {
                                    EasyDebounce.debounce(
                                      'my-debouncer',
                                      const Duration(milliseconds: 500),
                                      () {
                                        searchKeywordBloc.onSearchTextChanged(
                                          text: value,
                                        );
                                      },
                                    );
                                  }
                                },
                                onSubmitted: (value) {
                                  if (!widget.showLogo) {
                                    searchKeywordBloc.handleSubmitSearch(
                                      context: context,
                                      searchText: value,
                                    );
                                  }
                                },
                              ),
                      ),
                      const SizedBox(width: 5.0),
                      ElevatedButton(
                        onPressed: widget.onSearch,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kPrimaryColor),
                          elevation: MaterialStateProperty.all<double>(1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldSearch extends StatelessWidget {
  const FieldSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
