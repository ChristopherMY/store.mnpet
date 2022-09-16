import 'package:flutter/material.dart';

///加载更多回调
typedef LoadMoreCallback = Future<void> Function();

///构建自定义状态返回
typedef LoadMoreBuilder = Widget Function(
    BuildContext context, LoadStatus status);

///加载状态
enum LoadStatus {
  normal, //正常状态
  error, //加载错误
  loading, //加载中
  completed, //加载完成
}

///加载更多 Widget
class LoadAny extends StatefulWidget {
  ///加载状态
  final LoadStatus status;

  ///加载更多回调
  final LoadMoreCallback onLoadMore;

  //final LoadMoreCallback? onLoadFilters;

  ///自定义加载更多 Widget
  final LoadMoreBuilder? loadMoreBuilder;

  ///CustomScrollView
  final CustomScrollView child;

  ///到底部才触发加载更多
  final bool endLoadMore;

  ///加载更多底部触发距离
  final double bottomTriggerDistance;

  ///底部 loadmore 高度
  final double footerHeight;

  ///Footer key
  final Key _keyLastItem = Key("__LAST_ITEM");

  ///Text displayed during load
  final String loadingMsg;

  ///Text displayed in case of error
  final String errorMsg;

  ///Text displayed when loading is finished
  final String finishMsg;

  LoadAny({
    Key? key,
    required this.status,
    required this.child,
    required this.onLoadMore,
    //required this.onLoadFilters,
    this.endLoadMore = true,
    this.bottomTriggerDistance = 200,
    this.footerHeight = 40,
    this.loadMoreBuilder,
    this.loadingMsg = '加载中...',
    this.errorMsg = '加载失败，点击重试',
    this.finishMsg = '没有更多了',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadAnyState();
}

class _LoadAnyState extends State<LoadAny> {
  @override
  Widget build(BuildContext context) {
    dynamic check =
        widget.child.slivers.elementAt(widget.child.slivers.length - 1);

    if (check is SliverSafeArea && check.key == widget._keyLastItem) {
      widget.child.slivers.removeLast();
    }

    widget.child.slivers.add(
      SliverSafeArea(
        key: widget._keyLastItem,
        top: false,
        left: false,
        right: false,
        sliver: SliverToBoxAdapter(child: _buildLoadMore(widget.status)),
      ),
    );
    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: widget.child,
    );
  }

  Widget _buildLoadMore(LoadStatus status) {
    if (widget.loadMoreBuilder != null) {
      Widget loadMore = widget.loadMoreBuilder!(context, status);
      if (loadMore != null) {
        return loadMore;
      }
    }

    if (status == LoadStatus.loading) {
      return _buildLoading();
    } else if (status == LoadStatus.error) {
      return _buildLoadError();
    } else if (status == LoadStatus.completed) {
      return _buildLoadFinish();
    } else {
      return Container(height: widget.footerHeight);
    }
  }

  Widget _buildLoading() {
    return SizedBox(
      height: widget.footerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(width: 10),
          Text(
            widget.loadingMsg,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadError() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onLoadMore();
      },
      child: SizedBox(
        height: widget.footerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.errorMsg,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadFinish() {
    return SizedBox(
      height: widget.footerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 10,
            child: Divider(
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.finishMsg,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          const SizedBox(
            width: 10,
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }


  bool _handleNotification(ScrollNotification notification) {

    double currentExtent = notification.metrics.pixels;

    double maxExtent = notification.metrics.maxScrollExtent;

    if (notification.metrics.axisDirection == AxisDirection.down &&
        (notification is ScrollUpdateNotification) &&
        !widget.endLoadMore) {
      return _checkLoadMore(
          (maxExtent - currentExtent <= widget.bottomTriggerDistance));
    }

    if (notification.metrics.axisDirection == AxisDirection.down &&
        (notification is ScrollEndNotification) &&
        widget.endLoadMore) {
      return _checkLoadMore((currentExtent >= maxExtent));
    }

    return false;
  }

  bool _checkLoadMore(bool canLoad) {
    if (canLoad && widget.status == LoadStatus.normal) {
      widget.onLoadMore();
      return true;
    }
    return false;
  }
}
