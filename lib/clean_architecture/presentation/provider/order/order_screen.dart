import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/order.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/order/components/order_detail_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/order/order_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loading_full_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen._({Key? key}) : super(key: key);

  //----------------------
  // Patron singleton widget
  //----------------------

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<OrderBloc>(
      create: (context) {
        return OrderBloc(
            userRepositoryInterface: context.read<UserRepositoryInterface>());
      },
      builder: (_, __) => const OrderScreen._(),
    );
  }

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void init() async {
    final mainBloc = context.read<MainBloc>();
    final orderBloc = context.read<OrderBloc>();
    final credentialsAuth = await mainBloc.loadCredentialsAuth();

    orderBloc.headers[HttpHeaders.authorizationHeader] =
        "Bearer ${credentialsAuth.token}";

    final response = await orderBloc.getOrdersDetails();

    if (response is List<Order>) {
      orderBloc.orders = response;
      orderBloc.refreshBloc();
      return;
    }
    if (!mounted) return;
    GlobalSnackBar.showWarningSnackBar(
      context,
      "Ups, vuelva a intentarlo más tarde",
    );
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderBloc = context.watch<OrderBloc>();

    if (orderBloc.orders is! List<Order>) {
      return const LoadingFullScreen();
    }

    return SafeArea(
      child: Material(
        color: kBackGroundColor,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: kBackGroundColor,
              leading: BackButton(color: Colors.black),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: kBackGroundColor,
                statusBarIconBrightness: Brightness.dark,
              ),
              title: Text(
                "Mis ordenes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              pinned: true,
              centerTitle: false,
              elevation: 0,
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: getProportionateScreenHeight(50),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _OrderCategory(
                        title: "Proceso",
                        onSelected: (value) {},
                      ),
                      const SizedBox(width: 10.0),
                      _OrderCategory(
                        title: "Cancelar",
                        onSelected: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final order = orderBloc.orders[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: _OrderDetail(order: order),
                  );
                },
                // 40 list items
                childCount: orderBloc.orders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCategory extends StatelessWidget {
  const _OrderCategory({
    Key? key,
    required this.title,
    required this.onSelected,
  }) : super(key: key);

  final String title;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15 / 2),
      child: ChoiceChip(
        selected: true,
        selectedColor: Colors.black,
        padding: const EdgeInsets.all(8.0),
        backgroundColor: Colors.black,
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        onSelected: onSelected,
      ),
    );
  }
}

class _OrderDetail extends StatelessWidget {
  const _OrderDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.0,
            blurRadius: 3.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Order N° ${order.paymentId}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "${order.utcData}",
                style: const TextStyle(color: Colors.black38),
              )
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              const Text(
                "Ubigeo: ",
                style: TextStyle(color: Colors.black38),
              ),
              Flexible(
                child: Text(
                  "${order.payer!.department!} - ${order.payer!.province!} - ${order.payer!.district!}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7.0),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      "Cantidad: ",
                      style: TextStyle(color: Colors.black38),
                    ),
                    Text(
                      "${order.items!.length}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  const Text(
                    "Monto Total: ",
                    style: TextStyle(color: Colors.black38),
                  ),
                  Text(
                    "S/ ${order.transactionAmount}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 17.0),
          Row(
            children: [
              Material(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, secondaryAnimation) {
                          return OrderDetailScreen.init(
                            context: context,
                            paymentId: order.paymentId!,
                          );
                        },
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 30.0,
                    ),
                    child: Text("Detalle"),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                orderDetailStatus(status: order.status!).toString(),
                style: TextStyle(color: getStatusColor(status: order.status!)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

