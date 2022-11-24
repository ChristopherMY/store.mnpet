import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/order_detail.dart'
    as od;
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/order_detail/order_detail_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/loading_bag_full_screen.dart';

const url = Environment.API_DAO;

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen._({
    Key? key,
    required this.paymentId,
  }) : super(key: key);

  final int paymentId;

  static Widget init({
    required BuildContext context,
    required int paymentId,
  }) {
    return ChangeNotifierProvider<OrderDetailBloc>(
      create: (context) => OrderDetailBloc(
          userRepositoryInterface: context.read<UserRepositoryInterface>()),
      builder: (_, __) => OrderDetailScreen._(paymentId: paymentId),
    );
  }

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  void init() async {
    final orderDetailBloc = context.read<OrderDetailBloc>();
    await orderDetailBloc.getOrderDetailById(widget.paymentId, context);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderDetailBloc = context.watch<OrderDetailBloc>();

    if (orderDetailBloc.orderDetail is! od.OrderDetail) {
      return const LoadingBagFullScreen();
    }

    final orderDetail = orderDetailBloc.orderDetail;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        leading: const BackButton(color: Colors.black),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kBackGroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          "Detalle de orden",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Order N° ${orderDetail.paymentId}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        "${orderDetail.utcData}",
                        style: const TextStyle(color: Colors.black38),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              "Estado: ",
                              style: TextStyle(color: Colors.black38),
                            ),
                            Text(
                              orderDetailStatus(
                                status: orderDetail.status!,
                              ).toString(),
                              style: TextStyle(
                                fontSize: 14,
                                //fontWeight: FontWeight.w700,
                                color: getStatusColor(
                                  status: orderDetail.status!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "${orderDetail.items!.length} ${orderDetail.items!.isNotEmpty ? "items" : "item"}",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                  //----------------------
                  // List Order Client
                  //----------------------
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: orderDetail.items!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = orderDetail.items![index];

                      return _OrderDetailCard(item: item);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 18.0);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Información de la orden",
                      style: Theme.of(context).textTheme.subtitle2!,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(130),
                        child: const Text(
                          "Dirección de envío: ",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          orderDetail.payer!.address!.direction!,
                          maxLines: 3,
                          softWrap: true,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(130.0),
                          child: const Text(
                            "Ubigueo: ",
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${orderDetail.payer!.address!.department} - ${orderDetail.payer!.address!.province} - ${orderDetail.payer!.address!.district}",
                            maxLines: 3,
                            softWrap: true,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(130.0),
                        child: const Text(
                          "Número de contacto: ",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      Text(
                        "${orderDetail.payer!.phone!.number!}",
                        maxLines: 3,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(130),
                          child: const Text(
                            "Costo de envió: ",
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                        Text(
                          "S/ ${parseDouble(orderDetail.shipPrice.toString())}",
                          maxLines: 3,
                          softWrap: true,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(130.0),
                        child: const Text(
                          "Total pagado: ",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      Text(
                        "S/ ${parseDouble(orderDetail.transactionAmount.toString())}",
                        maxLines: 3,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // SubmitButton(
                  //   title: "Solicitar devolución",
                  //   act: () {
                  //     const orderId = "";
                  //     const description =
                  //         "Buenas tardes estimad@, necesito devolución referente al pedido: $orderId\nPor motivo de:";
                  //     _general.whatsappMessage(
                  //       context: context,
                  //       description: description,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderDetailCard extends StatelessWidget {
  const _OrderDetailCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final od.Item item;

  @override
  Widget build(BuildContext context) {
    return Material(
      // margin: const EdgeInsets.only(bottom: 18),
      //  decoration: const BoxDecoration(
      //    color: Colors.white,
      //    boxShadow: [
      //      BoxShadow(
      //        color: Colors.black12,
      //        spreadRadius: 1,
      //        blurRadius: 3,
      //      )
      //    ],
      //  ),
      color: Colors.white,
      elevation: 1,

      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: getProportionateScreenHeight(119),
              ),
              child: CachedNetworkImage(
                imageUrl: "$url/${item.mainImage!.src}",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/no-image.png", fit: BoxFit.cover),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${item.name}",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "${item.categories!.first.name}",
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ),

                    //----------------------
                    // Create List Attributes
                    //----------------------

                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(
                          item.variation!.attributes!.length,
                          (index) {
                            final attribute =
                                item.variation!.attributes![index];
                            return Row(
                              children: [
                                Text(
                                  "${attribute.name}: ",
                                  style: const TextStyle(color: Colors.black38),
                                ),
                                Text(
                                  "${attribute.term!.label}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Unidades: ${item.quantity}",
                            style: const TextStyle(color: Colors.black38),
                          ),
                        ),
                        Text(
                          "S/ ${parseDouble(item.price!.sale!)}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
