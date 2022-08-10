import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class CategoriesListView extends StatelessWidget {
  final List<MasterCategory> categories;
  final LoadStatus status;
  final _cloudFront = Environment.CLOUD_FRONT;

  const CategoriesListView({
    Key? key,
    required this.categories,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: SizedBox(
        height: categories.length <= 5 ? 150 : 245,
        width: double.infinity,
        child: Material(
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Un premio especial a nuevos clientes",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 0),
                  height: categories.length <= 5 ? 80 : 175,
                  child: buildGridView(context: context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildGridView({required BuildContext context}) {
    // shrinkWrap: true,
    // scrollDirection: Axis.horizontal,
    return
        // CustomScrollbar(
        // //scrollbarOrientation: ScrollbarOrientation.,
        // thickness: 10,
        // radius: const Radius.circular(20),
        //  crossAxisMargin: 0,
        //  mainAxisMargin: 150,
        //  trackColor: Colors.grey,
        //  thumbColor: kPrimaryColorRed,
        //  trackBorderColor: Colors.grey,
        // // showTrackOnHover: true,
        //  minThumbLength: 10,
        // child:
        GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: categories.length > 10 ? 2 : 1,
        crossAxisSpacing: 0.50,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: categories.isNotEmpty
          ? categories.map(
              (element) {
                return GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MainProductList(
                          categorySlug: element.slug,
                          title: element.name,
                          keywordSlug: "",
                          relations: element.relations,
                        ),
                      ),
                    );*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(int.parse("0xFF${element.hexa}")),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: _buildImage(
                                src: element.image!.src!,
                                type: element.image!.type!,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 55,
                          child: Text(
                            element.shortName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList()
          : [],
      // ),
    );
  }

  _buildImage({required String type, required String src}) {
    if (type == "asset") {
      return const FadeInImage(
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage("assets/no-image.png"),
        image: AssetImage("assets/images/menu.png"),
      );
    }

    return CachedNetworkImage(
      imageUrl: "$_cloudFront/$src",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 20;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
