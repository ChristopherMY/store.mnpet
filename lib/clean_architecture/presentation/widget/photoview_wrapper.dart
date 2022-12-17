import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/custom_toast.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/image_downloader.dart';
import '../../helper/http.dart';
import '../../domain/usecase/page.dart';
import '../provider/product/product_bloc.dart';

const String _url = Environment.API_DAO;

class GalleryPhotoViewWrapper extends StatefulWidget {
  const GalleryPhotoViewWrapper({
    Key? key,
    // this.loadingBuilder,
    required this.managerTypePhotoViewer,
    required this.backgroundDecoration,
    required this.isAppBar,
    this.minScale,
    this.maxScale,
    this.scrollDirection = Axis.horizontal,
    required this.code,
  }) : super(key: key);

  final ManagerTypePhotoViewer managerTypePhotoViewer;
  final bool isAppBar;

  // final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  final Axis scrollDirection;
  final String code;

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper>
    with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                  return;
                }

                _controller.forward();
              },
              child: _ManagerPhotoViewer(
                gallery: gallery,
                managerType: widget.managerTypePhotoViewer,
                position: widget.isAppBar
                    ? productBloc.indexPhotoViewer
                    : productBloc.indexPhotoViewerDescription,
                onPhotoPageChanged: (index) async {
                  return await productBloc.onChangedPhotoPage(
                    index,
                    widget.isAppBar,
                  );
                },
                pageController: pageController,
                scrollDirection: widget.scrollDirection,
                backgroundDecoration: widget.backgroundDecoration,
                code: widget.code,
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
      var http = Http(logsEnabled: true);
      var path = await http.download(fileUrl);
      if (path.isEmpty) {
        return;
      }

      // var imageId = await ImageDownloader.downloadImage(fileUrl);

      // print("imageId: $imageId");
      // if (imageId == null) {
      //   return;
      // }

      // var fileName = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);

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
}

class _ManagerPhotoViewer extends StatelessWidget {
  const _ManagerPhotoViewer({
    Key? key,
    required this.managerType,
    required this.gallery,
    required this.onPhotoPageChanged,
    required this.position,
    required this.scrollDirection,
    required this.pageController,
    required this.backgroundDecoration,
    required this.code,
  }) : super(key: key);

  final ManagerTypePhotoViewer managerType;
  final List<MainImage> gallery;
  final Function(int) onPhotoPageChanged;
  final int position;
  final Axis scrollDirection;
  final PageController pageController;
  final BoxDecoration backgroundDecoration;
  final String code;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();

    if (managerType == ManagerTypePhotoViewer.single) {
      return PhotoView(
        imageProvider:
            CachedNetworkImageProvider("$_url/${gallery[position].src}"),
        backgroundDecoration: backgroundDecoration,
        minScale: PhotoViewComputedScale.contained * (0.5 + position / 10),
        maxScale: PhotoViewComputedScale.covered * 4.1,
        heroAttributes: PhotoViewHeroAttributes(
          tag: "image-${gallery[position].id!}-$code",
          transitionOnUserGestures: true,
        ),
      );
    }

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext _, int index) {
        final item = gallery[index];

        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider("$_url/${item.src}"),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
          maxScale: PhotoViewComputedScale.covered * 4.1,
          heroAttributes: PhotoViewHeroAttributes(
            tag: "image-${item.id!}-$code",
            transitionOnUserGestures: true,
          ),
        );
      },
      itemCount: gallery.length,
      //loadingBuilder: widget.loadingBuilder,
      // allowImplicitScrolling: true,
      backgroundDecoration: backgroundDecoration,
      pageController: pageController,
      onPageChanged: onPhotoPageChanged,
      scrollDirection: scrollDirection,
    );
  }
}
