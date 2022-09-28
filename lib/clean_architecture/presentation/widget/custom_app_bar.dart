import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/dotted_swiper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/photoview_wrapper.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CustomSliverPersistentHeaderDelegate(),
      pinned: true,
      floating: true,
    );
  }
}

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 393.0;

  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print("overlapsContent: $overlapsContent");
    final productBloc = context.read<ProductBloc>();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: SizeConfig.screenWidth!,
      ),
      child: FlexibleSpaceBar(
        background: Container(
          color: Colors.transparent,
          child: Swiper(
            layout: SwiperLayout.DEFAULT,
            controller: productBloc.swiperController,
            itemHeight: 10,
            itemCount: productBloc.headerContent.length,
            itemBuilder: (_, index) => productBloc.headerContent[index],
            autoplay: false,
            duration: 3,
            onTap: (index) => productBloc.onOpenGallery(
              context: context,
              isAppBar: true,
              managerTypePhotoViewer: ManagerTypePhotoViewer.navigation,
            ),
            onIndexChanged: (index) {
              // productBloc.onChangedIndex(index: index);
            },
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: DotCustomSwiperPaginationBuilder(
                color: Colors.grey,
                activeColor: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
