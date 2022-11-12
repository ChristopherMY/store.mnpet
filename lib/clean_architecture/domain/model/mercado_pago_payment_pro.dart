// To parse this JSON data, do
//
//     final mercadoPagoPaymentPro = mercadoPagoPaymentProFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_credit_cart.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_customer.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_tax.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_transaction_detail.dart';

MercadoPagoPaymentPro mercadoPagoPaymentProFromMap(String str) =>
    MercadoPagoPaymentPro.fromMap(json.decode(str));

String mercadoPagoPaymentProToMap(MercadoPagoPaymentPro data) =>
    json.encode(data.toMap());

class MercadoPagoPaymentPro {
  MercadoPagoPaymentPro({
    this.id,
    this.dateCreated,
    this.dateApproved,
    this.dateLastUpdated,
    this.dateOfExpiration,
    this.moneyReleaseDate,
    this.operationType,
    this.issuerId,
    this.paymentMethodId,
    this.paymentTypeId,
    this.status,
    this.statusDetail,
    this.currencyId,
    this.description,
    this.liveMode,
    this.sponsorId,
    this.authorizationCode,
    this.moneyReleaseSchema,
    this.taxesAmount,
    this.counterCurrency,
    this.shippingAmount,
    this.posId,
    this.storeId,
    this.integratorId,
    this.platformId,
    this.corporationId,
    this.collectorId,
    this.payer,
    this.marketplaceOwner,
    this.metadata,
    this.availableBalance,
    this.nsuProcessadora,
    this.order,
    this.externalReference,
    this.transactionAmount,
    this.netAmount,
    this.taxes,
    this.transactionAmountRefunded,
    this.couponAmount,
    this.differentialPricingId,
    this.deductionSchema,
    this.callbackUrl,
    this.transactionDetails,
    this.feeDetails,
    this.captured,
    this.binaryMode,
    this.callForAuthorizedId,
    this.statementDescriptor,
    this.installments,
    this.card,
    this.notificationUrl,
    this.refunds,
    this.processingMode,
    this.merchantAccountId,
    this.acquired,
    this.merchantNumber,
    this.acquirerReconciliation,
  });

  final String? id;
  final DateTime? dateCreated;
  final DateTime? dateApproved;
  final DateTime? dateLastUpdated;
  final DateTime? dateOfExpiration;
  final DateTime? moneyReleaseDate;
  final String? operationType;
  final String? issuerId;
  final String? paymentMethodId;
  final String? paymentTypeId;
  final int? status;
  final String? statusDetail;
  final String? currencyId;
  final String? description;
  final bool? liveMode;
  final String? sponsorId;
  final String? authorizationCode;
  final String? moneyReleaseSchema;
  final double? taxesAmount;
  final String? counterCurrency;
  final double? shippingAmount;
  final String? posId;
  final String? storeId;
  final String? integratorId;
  final String? platformId;
  final String? corporationId;
  final String? collectorId;
  final MercadoPagoCustomer? payer;
  final String? marketplaceOwner;
  final dynamic? metadata;
  final String? availableBalance;
  final String? nsuProcessadora;
  final dynamic? order;
  final String? externalReference;
  final int? transactionAmount;
  final int? netAmount;
  final List<MercadoPagoTax>? taxes;
  final int? transactionAmountRefunded;
  final int? couponAmount;
  final String? differentialPricingId;
  final String? deductionSchema;
  final String? callbackUrl;
  final MercadoPagoTransactionDetail? transactionDetails;
  final dynamic? feeDetails;
  final bool? captured;
  final bool? binaryMode;
  final String? callForAuthorizedId;
  final String? statementDescriptor;
  final int? installments;
  final MercadoPagoCreditCard? card;
  final String? notificationUrl;
  final List<dynamic>? refunds;
  final String? processingMode;
  final String? merchantAccountId;
  final String? acquired;
  final String? merchantNumber;
  final List<dynamic>? acquirerReconciliation;

  factory MercadoPagoPaymentPro.fromMap(Map<String, dynamic> json) =>
      MercadoPagoPaymentPro(
        id: json["id"] == null ? null : json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        dateApproved: json["date_approved"] == null
            ? null
            : DateTime.parse(json["date_approved"]),
        dateLastUpdated: json["date_last_updated"] == null
            ? null
            : DateTime.parse(json["date_last_updated"]),
        dateOfExpiration: json["date_of_expiration"] == null
            ? null
            : DateTime.parse(json["date_of_expiration"]),
        moneyReleaseDate: json["money_release_date"] == null
            ? null
            : DateTime.parse(json["money_release_date"]),
        operationType:
            json["operation_type"] == null ? null : json["operation_type"],
        issuerId: json["issuer_id"] == null ? null : json["issuer_id"],
        paymentMethodId: json["payment_method_id"] == null
            ? null
            : json["payment_method_id"],
        paymentTypeId:
            json["payment_type_id"] == null ? null : json["payment_type_id"],
        status: json["status"] == null ? null : json["status"].toInt(),
        statusDetail:
            json["status_detail"] == null ? null : json["status_detail"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        description: json["description"] == null ? null : json["description"],
        liveMode: json["live_mode"] == null ? null : json["live_mode"],
        sponsorId: json["sponder_id"] == null ? null : json["sponder_id"],
        authorizationCode: json["authorization_code"] == null
            ? null
            : json["authorization_code"],
        moneyReleaseSchema: json["money_release_schema"] == null
            ? null
            : json["money_release_schema"],
        taxesAmount: json["taxes_amount"] == null
            ? null
            : json["taxes_amount"].toDouble(),
        counterCurrency:
            json["counter_currency"] == null ? null : json["counter_currency"],
        shippingAmount: json["shipping_amount"] == null
            ? null
            : json["shipping_amount"].toDouble(),
        posId: json["pos_id"] == null ? null : json["pos_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        integratorId:
            json["integrator_id"] == null ? null : json["integrator_id"],
        platformId: json["platform_id"] == null ? null : json["platform_id"],
        corporationId:
            json["corporation_id"] == null ? null : json["corporation_id"],
        collectorId: json["collector_id"] == null ? null : json["collector_id"],
        payer: json["payer"] == null
            ? null
            : MercadoPagoCustomer.fromJsonMap(json["payer"]),
        marketplaceOwner: json["marketplace_owner"] == null
            ? null
            : json["marketplace_owner"],
        metadata: json["metadata"] == null ? null : json["metadata"],
        availableBalance: json["available_balance"] == null
            ? null
            : json["available_balance"],
        nsuProcessadora:
            json["nsu_processadora"] == null ? null : json["nsu_processadora"],
        order: json["order"] == null ? null : json["order"],
        externalReference: json["external_reference"] == null
            ? null
            : json["external_reference"],
        transactionAmount: json["transaction_amount"] == null
            ? null
            : json["transaction_amount"].toDouble(),
        netAmount:
            json["net_amount"] == null ? null : json["net_amount"].toDouble(),
        taxes: json["taxes"] == null
            ? null
            : List<MercadoPagoTax>.from(
                json["taxes"].map((x) => MercadoPagoTax.fromJsonMap(x))),
        transactionAmountRefunded: json["transaction_amount_refunded"] == null
            ? null
            : json["transaction_amount_refunded"].toDouble(),
        couponAmount: json["coupon_amount"] == null
            ? null
            : json["coupon_amount"].toDouble(),
        differentialPricingId: json["differential_princing_id"] == null
            ? null
            : json["differential_princing_id"],
        deductionSchema:
            json["deduction_schema"] == null ? null : json["deduction_schema"],
        callbackUrl: json["callback_url"] == null ? null : json["callback_url"],
        transactionDetails: json["transaction_details"] == null
            ? null
            : MercadoPagoTransactionDetail.fromJsonMap(
                json["transaction_details"]),
        feeDetails: json["fee_details"] == null ? null : json["fee_details"],
        captured: json["captured"] == null ? null : json["captured"],
        binaryMode: json["binary_mode"] == null ? null : json["binary_mode"],
        callForAuthorizedId: json["call_for_authorized_id"] == null
            ? null
            : json["call_for_authorized_id"],
        statementDescriptor: json["statement_descriptor"] == null
            ? null
            : json["statement_descriptor"],
        installments:
            json["installments"] == null ? null : json["installments"],
        card: json["card"] == null
            ? null
            : MercadoPagoCreditCard.fromJsonMap(json["card"]),
        notificationUrl:
            json["notification_url"] == null ? null : json["notification_url"],
        refunds: json["refunds"] == null ? null : json["refunds"],
        processingMode:
            json["processing_mode"] == null ? null : json["processing_mode"],
        merchantAccountId: json["merchant_account_id"] == null
            ? null
            : json["merchant_account_id"],
        acquired: json["acquired"] == null ? null : json["acquired"],
        merchantNumber:
            json["merchant_number"] == null ? null : json["merchant_number"],
        acquirerReconciliation: json["acquirer_reconciliation"] == null
            ? null
            : json["acquirer_reconciliation"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "date_created":
            dateCreated == null ? null : dateCreated!.toIso8601String(),
        "date_approved":
            dateApproved == null ? null : dateApproved!.toIso8601String(),
        "date_last_updated":
            dateLastUpdated == null ? null : dateLastUpdated!.toIso8601String(),
        "date_of_expiration": dateOfExpiration == null
            ? null
            : dateOfExpiration!.toIso8601String(),
        "money_release_date": moneyReleaseDate == null
            ? null
            : moneyReleaseDate!.toIso8601String(),
        "operation_type": operationType == null ? null : operationType,
        "issuer_id": issuerId == null ? null : issuerId,
        "payment_method_id": paymentMethodId == null ? null : paymentMethodId,
        "payment_type_id": paymentTypeId == null ? null : paymentTypeId,
        "status": status == null ? null : status,
        "status_detail": statusDetail == null ? null : statusDetail,
        "currency_id": currencyId == null ? null : currencyId,
        "description": description == null ? null : description,
        "live_mode": liveMode == null ? null : liveMode,
        "sponder_id": sponsorId == null ? null : sponsorId,
        "authorization_code":
            authorizationCode == null ? null : authorizationCode,
        "money_release_schema":
            moneyReleaseSchema == null ? null : moneyReleaseSchema,
        "taxes_amount": taxesAmount == null ? null : taxesAmount,
        "counter_currency": counterCurrency == null ? null : counterCurrency,
        "shipping_amount": shippingAmount == null ? null : shippingAmount,
        "pos_id": posId == null ? null : posId,
        "store_id": storeId == null ? null : storeId,
        "integrator_id": integratorId == null ? null : integratorId,
        "platform_id": platformId == null ? null : platformId,
        "corporation_id": corporationId == null ? null : corporationId,
        "collector_id": collectorId == null ? null : collectorId,
        "payer": payer == null ? null : payer!.toJson(),
        "marketplace_owner": marketplaceOwner == null ? null : marketplaceOwner,
        "metadata": metadata == null ? null : metadata,
        "available_balance": availableBalance == null ? null : availableBalance,
        "nsu_processadora": nsuProcessadora == null ? null : nsuProcessadora,
        "order": order == null ? null : order,
        "external_reference":
            externalReference == null ? null : externalReference,
        "transaction_amount":
            transactionAmount == null ? null : transactionAmount,
        "net_amount": netAmount == null ? null : netAmount,
        "taxes": taxes == null
            ? null
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "transaction_amount_refunded": transactionAmountRefunded == null
            ? null
            : transactionAmountRefunded,
        "coupon_amount": couponAmount == null ? null : couponAmount,
        "differential_princing_id":
            differentialPricingId == null ? null : differentialPricingId,
        "deduction_schema": deductionSchema == null ? null : deductionSchema,
        "callback_url": callbackUrl == null ? null : callbackUrl,
        "transaction_details":
            transactionDetails == null ? null : transactionDetails!.toJson(),
        "fee_details": feeDetails == null
            ? null
            : List<dynamic>.from(feeDetails.map((x) => x)),
        "captured": captured == null ? null : captured,
        "binary_mode": binaryMode == null ? null : binaryMode,
        "call_for_authorized_id":
            callForAuthorizedId == null ? null : callForAuthorizedId,
        "statement_descriptor":
            statementDescriptor == null ? null : statementDescriptor,
        "installments": installments == null ? null : installments,
        "card": card == null ? null : card!.toJson(),
        "notification_url": notificationUrl == null ? null : notificationUrl,
        "refunds":
            refunds == null ? null : List<dynamic>.from(refunds!.map((x) => x)),
        "processing_mode": processingMode == null ? null : processingMode,
        "merchant_account_id":
            merchantAccountId == null ? null : merchantAccountId,
        "acquired": acquired == null ? null : acquired,
        "merchant_number": merchantNumber == null ? null : merchantNumber,
        "acquirer_reconciliation": acquirerReconciliation == null
            ? null
            : List<dynamic>.from(acquirerReconciliation!.map((x) => x)),
      };
}
