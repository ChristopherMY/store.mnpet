import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class Categories extends StatelessWidget {
  final List<MasterCategory> categories;
  final LoadStatus status;
  final _cloudFront = Environment.CLOUD_FRONT;

  const Categories({
    Key? key,
    required this.categories,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Material(
        color: kPrimaryColor,
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
                style: Theme.of(context).textTheme.headline3,
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
                                maxWidth: getProportionateScreenWidth(50.0)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(
                                    getProportionateScreenWidth(5.0),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(
                                          int.parse("0xFF${element.hexa}")),
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
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
                                    color: Colors.white,
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
                // ],
                // children: List.generate(
                //   4,
                //   (index) => GestureDetector(
                //     onTap: () {},
                //     child: ConstrainedBox(
                //       constraints: BoxConstraints(
                //           maxWidth: getProportionateScreenWidth(50.0)),
                //       child: Column(
                //         children: <Widget>[
                //           Container(
                //             padding: EdgeInsets.all(
                //                 getProportionateScreenWidth(6.0),
                //             ),
                //             decoration: BoxDecoration(
                //               color: Color(int.parse("0xFFff6a71")),
                //               shape: BoxShape.circle,
                //             ),
                //             child: _buildImage(
                //               src: "categories/bcdd0281-fb68-431c-a03e-9bf98ace74a4.png",
                //             ),
                //           ),
                //           Text(
                //             "Todo animales",
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.center,
                //             style: const TextStyle(
                //               fontSize: 12.0,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                //     ),
                //   ),
                // ),
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
      imageUrl: "$_cloudFront/$src",
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
