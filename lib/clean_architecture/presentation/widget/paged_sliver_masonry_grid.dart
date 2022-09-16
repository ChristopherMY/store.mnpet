import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PagedSliverMasonryGrid<PageKeyType, ItemType> extends StatelessWidget {
  const PagedSliverMasonryGrid({
    Key? key,
    required this.pagingController,
    required this.builderDelegate,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
  }) : super(key: key);

  /// Corresponds to [PagedSliverBuilder.pagingController].
  final PagingController<PageKeyType, ItemType> pagingController;

  /// Corresponds to [PagedSliverBuilder.builderDelegate].
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// Corresponds to [SliverMasonryGrid.count]
  final double mainAxisSpacing;

  /// Corresponds to [SliverMasonryGrid.count]
  final double crossAxisSpacing;

  /// Corresponds to [SliverSimpleGridDelegateWithFixedCrossAxisCount]
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return PagedSliverBuilder<PageKeyType, ItemType>(
      pagingController: pagingController,
      builderDelegate: builderDelegate,
      completedListingBuilder: (
        context,
        itemBuilder,
        itemCount,
        noMoreItemsIndicatorBuilder,
      ) {
        return SliverMasonryGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
      loadingListingBuilder: (
        context,
        itemBuilder,
        itemCount,
        progressIndicatorBuilder,
      ) {
        return MultiSliver(
          children: [
            SliverMasonryGrid.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: crossAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childCount: itemCount,
              itemBuilder: itemBuilder,
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Cargando más productos, espere un momento",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black26, fontSize: 12.0),
                ),
              ),
            )
          ],
        );
      },
      errorListingBuilder: (
        context,
        itemBuilder,
        itemCount,
        errorIndicatorBuilder,
      ) {
        return SliverMasonryGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: crossAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
