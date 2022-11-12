import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';

const cloudFront = Environment.API_DAO;

class Categories extends StatelessWidget {
  final List<MasterCategory> categories;
  final LoadStatus status;
  final Color backgroundColor;

  const Categories({
    Key? key,
    required this.categories,
    required this.status,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15.0),
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Un premio especial a nuevos clientes",
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(height: 15.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1.1,
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: WrapAlignment.start,
                    spacing: getProportionateScreenWidth(12.0),
                    runSpacing: getProportionateScreenWidth(8.0),
                    children: categories.map(
                      (MasterCategory element) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return SearchDetailScreen.init(
                                    context: context,
                                    typeFilter: TypeFilter.category,
                                    category: element,
                                    search: "",
                                  );
                                },
                              ),
                            );
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: getProportionateScreenWidth(55.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(
                                    getProportionateScreenWidth(5.0),
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 57.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kBackGroundColor,
                                    // Color(int.parse("0xFF${element.hexa}")),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: _buildImage(
                                    src: element.image!.src!,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  element.shortName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15.0)
            ],
          ),
        ),
      ),
    );
  }

  _buildImage({required String src}) {
    return CachedNetworkImage(
      imageUrl: src,
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
      ),
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 15;
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
