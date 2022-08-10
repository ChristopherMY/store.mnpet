import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/photoview_wrapper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/star_rating.dart';
class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List lstColors = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  List tempArr = [1, 2, 3, 4];
  NavigatorState? _navigator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      //8 backgroundColor: kSecondaryBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.black,
        bottomOpacity: 0.0,
        title: const Text(
          "Valoraciones",
          style: TextStyle(color: Colors.white, fontSize: kFontSizeTitleAppBar),
        ),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:const Icon(Icons.close),
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        //controller: _scrollController,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildFilters(context: context),
          _buildHeader(context: context),
          _buildDivider(context: context),
          _buildBody(context: context),
        ],
      ),
    );
  }

  _buildHeader({BuildContext? context}) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      leading: SizedBox(),
      toolbarHeight: 62,
      backgroundColor: kSecondaryBackgroundColor,
      leadingWidth: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            height: 35,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildFilterSelector(
                    context: context!,
                    child: Text(
                      "Todos (10)",
                      style: TextStyle(fontSize: 12, color: kPrimaryColorRed),
                    ),
                    onTap: () => setState(() => reduxColor(position: 0)),
                    color: lstColors[0]),
                _buildFilterSelector(
                    context: context,
                    child: _buildStartsOption(
                        context: context, size: 12, stars: 1),
                    onTap: () => setState(() => reduxColor(position: 1)),
                    color: lstColors[1]),
                _buildFilterSelector(
                    context: context,
                    child: _buildStartsOption(
                        context: context, size: 12, stars: 2),
                    onTap: () => setState(() => reduxColor(position: 2)),
                    color: lstColors[2]),
                _buildFilterSelector(
                    context: context,
                    child: _buildStartsOption(
                        context: context, size: 12, stars: 3),
                    onTap: () => setState(() => reduxColor(position: 3)),
                    color: lstColors[3]),
                _buildFilterSelector(
                    context: context,
                    child: _buildStartsOption(
                        context: context, size: 12, stars: 4),
                    onTap: () => setState(() => reduxColor(position: 4)),
                    color: lstColors[4]),
                _buildFilterSelector(
                    context: context,
                    child: _buildStartsOption(
                        context: context, size: 12, stars: 5),
                    onTap: () => setState(() => reduxColor(position: 5)),
                    color: lstColors[5]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildFilters({BuildContext? context}) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 155,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4.7",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text("/5")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StarRating(
                        rating: 4.7,
                        size: 17,
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 85,
                        child: Text(
                          "55 Calificaciones",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  chartRow(context: context, label: '5', pct: 89, rating: 1),
                  chartRow(context: context, label: '5', pct: 14, rating: 2),
                  chartRow(context: context, label: '5', pct: 3, rating: 3),
                  chartRow(context: context, label: '5', pct: 26, rating: 4),
                  chartRow(context: context, label: '5', pct: 1, rating: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStartsOption({
    BuildContext? context,
    required double size,
    required int stars,
  }) {
    return Row(
        children: new List.generate(stars,
            (index) => Icon(Icons.star, size: size, color: kPrimaryColorRed)));
  }

  _buildFilterSelector({
    BuildContext? context,
    required Widget child,
    required GestureTapCallback onTap,
    required Color color,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            //margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                //kPrimaryColorRed
                color: Colors.white,
                border: Border.all(color: color)),
            child: child,
          ),
        ),
        SizedBox(
          width: 7,
        )
      ],
    );
  }

  _buildDivider({BuildContext? context}) {
    return SliverToBoxAdapter(
      child: Divider(
        color: kPrimaryBackgroundColor,
        height: 2,
      ),
    );
  }

  _buildBody({BuildContext? context}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
          children: [_buildRowComment(), Divider(height: 1)],
        );
      }, semanticIndexCallback: (Widget widget, int localIndex) {
        if (localIndex.isEven) {
          return localIndex ~/ 2;
        }
        return null;
      }, childCount: 25),
    );
  }

  _buildRowComment() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/call-center-agent.png"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Juan Tito Carrisales"),
                            SizedBox(height: 5),
                            DefaultTextStyle(
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("23 Dec 2021"),
                                  Text("Color: azul, medida: 14m"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      StarRating(rating: 3.5, size: 12)
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Lporwseopm dpaodjkaopd wpaijdpia wdji dwdad adawd addwadadawdw dwdw adw"),
                  SizedBox(height: 10),
                  Container(
                    height: tempArr.length < 4
                        ? 105
                        : tempArr.length < 7
                            ? 215
                            : tempArr.length < 10
                                ? 325
                                : tempArr.length < 13
                                    ? 435
                                    : 540,
                    child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(0),
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        crossAxisCount: 3,
                        children: tempArr
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  //if (widget.product.galleryHeader[position].type == "image")
                                  /*_openGalleryHeader(
                                    context: context,
                                    index: 1,
                                    //gallery: widget.product.galleryHeader,
                                    type: "single",
                                    //  key: _scaffoldKey,
                                  );*/
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://via.placeholder.com/120",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset("assets/no-image.png"),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList()
                            .cast()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openGalleryHeader(
      {BuildContext? context,
      required int index,
      required List gallery,
      required String type,
      required Key key}) {
    Route route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => GalleryPhotoViewWrapper(
        type: type,
        gallery: gallery,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        initialIndex: index,
        scrollDirection: Axis.horizontal,
      ),
    );

    _navigator!.push(route);
  }

  Widget chartRow({
    BuildContext? context,
    required String label,
    required int pct,
    required double rating,
  }) {
    return Row(
      children: [
        StarRating(rating: 3, size: 10),
        SizedBox(height: 22),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
            child: Stack(
              children: [
                Container(
                  width: SizeConfig.screenWidth! * 0.7,
                  height: 2,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(''),
                ),
                Container(
                  width: SizeConfig.screenWidth! * (pct / 100) * 0.7,
                  height: 2,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(''),
                ),
              ],
            ),
          ),
        ),
        Text(
          pct.toString(),
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void reduxColor({required int position}) {
    lstColors.forEachIndexed((index, element) {
      if (index == position)
        lstColors[index] = kPrimaryColorRed;
      else
        lstColors[index] = Colors.grey;
    });

    setState(() {});
  }
}
