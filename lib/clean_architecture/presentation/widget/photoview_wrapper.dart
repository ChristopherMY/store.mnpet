import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/custom_toast.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';

import '../../domain/usecase/page.dart';
import '../provider/product/product_bloc.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  const GalleryPhotoViewWrapper({
    Key? key,
    //this.loadingBuilder,
    required this.managerTypePhotoViewer,
    required this.backgroundDecoration,
    required this.isAppBar,
    this.minScale,
    this.maxScale,
    this.scrollDirection = Axis.horizontal,
  }) : super(key: key);

  final ManagerTypePhotoViewer managerTypePhotoViewer;
  final bool isAppBar;

  //final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  final Axis scrollDirection;

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper>
    with SingleTickerProviderStateMixin {
  final _url = Environment.API_DAO;
  final toast = CustomToast();
  late PageController pageController;
  late AnimationController _controller;
  List<MainImage> gallery = <MainImage>[];

  List strings = [
    " woadaipwdjwiaddawdad dwa dphawd auhdwh 9uhdaw87dya wdy8aw u8auda8 dw8",
    "-oakwdaj0idj a8wudaw8wdwada",
    "88wdaoid 9w9dw9 dwdw w",
    "88wdaoid 9w9dw9 dwdw w",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();

    if (widget.isAppBar) {
      gallery = productBloc.product!.galleryHeader!;
      pageController =
          PageController(initialPage: productBloc.indexPhotoViewer);
    } else {
      gallery = productBloc.product!.galleryDescription!;
      pageController =
          PageController(initialPage: productBloc.indexPhotoViewerDescription);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              child: managerPhotoViewer(
                gallery: gallery,
                managerType: widget.managerTypePhotoViewer,
                position: widget.isAppBar
                    ? productBloc.indexPhotoViewer
                    : productBloc.indexPhotoViewerDescription,
                onPhotoPageChanged: (index) async {
                  print("index pass: $index");

                  return await productBloc.onChangedPhotoPage(
                    index,
                    widget.isAppBar,
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              height: getProportionateScreenHeight(79.0),
              width: SizeConfig.screenWidth,
              child: Transform.translate(
                offset: Offset(0, -_controller.value * 67),
                child: SizedBox(
                  height: getProportionateScreenHeight(79.0),
                  child: AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,

                    leading: const BackButton(
                      color: Colors.white,
                    ),
                    // title: widget.managerTypePhotoViewer ==
                    //         ManagerTypePhotoViewer.single
                    //     ? Container(
                    //         alignment: Alignment.center,
                    //         color: Colors.transparent,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(20.0),
                    //           child: Text(
                    //             "${0 + 1} / ${gallery.length}",
                    //             style: const TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 18.0,
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox.shrink(),
                    actions: [
                      IconButton(
                        onPressed: () {
                          final index = widget.isAppBar
                              ? productBloc.indexPhotoViewer
                              : productBloc.indexPhotoViewerDescription;

                          onDownload(
                            context: context,
                            fileUrl: "$_url/${gallery[index].src}",
                          );
                        },
                        icon: const Icon(Icons.save),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // if (widget.managerTypePhotoViewer == ManagerTypePhotoViewer.single)
            //   Positioned(
            //     bottom: 0,
            //     height: 100,
            //     width: SizeConfig.screenWidth,
            //     child: Transform.translate(
            //       offset: Offset(0, _controller.value * 100),
            //       child: Container(
            //         color: Colors.black87,
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: Padding(
            //             padding: const EdgeInsets.only(left: 15, right: 15),
            //             child: Text(
            //               strings[0],
            //               style: const TextStyle(
            //                 fontSize: 15,
            //                 color: Colors.white,
            //               ),
            //               textAlign: TextAlign.center,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            if (widget.managerTypePhotoViewer ==
                ManagerTypePhotoViewer.navigation)
              Positioned(
                bottom: 0,
                height: 50,
                width: SizeConfig.screenWidth,
                child: Transform.translate(
                  offset: Offset(0, _controller.value * 100),
                  child: Container(
                    color: Colors.black87,
                    child: Align(
                      alignment: Alignment.center,
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: gallery.length,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.red,
                          paintStyle: PaintingStyle.fill,
                          type: WormType.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onDownload({
    required BuildContext context,
    required String fileUrl,
  }) async {
    try {
      var imageId = await ImageDownloader.downloadImage(fileUrl);
      if (imageId == null) {
        return;
      }

      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);

      toast.showToast(
        context: context,
        message: "Guardado en: $path",
        type: "success",
      );
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Widget managerPhotoViewer({
    required ManagerTypePhotoViewer managerType,
    required List<MainImage> gallery,
    required Function(int) onPhotoPageChanged,
    required int position,
  }) {
    if (managerType == ManagerTypePhotoViewer.single) {
      return PhotoView(
        imageProvider:
            CachedNetworkImageProvider("$_url/${gallery[position].src}"),
        backgroundDecoration: widget.backgroundDecoration,
        minScale: PhotoViewComputedScale.contained * (0.5 + position / 10),
        maxScale: PhotoViewComputedScale.covered * 4.1,
        heroAttributes: PhotoViewHeroAttributes(
          tag: gallery[position].id!,
          transitionOnUserGestures: true,
        ),
      );
    }

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        final item = gallery[index];

        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider("$_url/${item.src}"),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
          maxScale: PhotoViewComputedScale.covered * 4.1,
          heroAttributes: PhotoViewHeroAttributes(
            tag: item.id!,
            transitionOnUserGestures: true,
          ),
        );
      },
      itemCount: gallery.length,
      //loadingBuilder: widget.loadingBuilder,
      // allowImplicitScrolling: true,
      backgroundDecoration: widget.backgroundDecoration,
      pageController: pageController,
      onPageChanged: onPhotoPageChanged,
      scrollDirection: widget.scrollDirection,
    );
  }
}
