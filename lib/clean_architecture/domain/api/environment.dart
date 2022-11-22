import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_credentials.dart';

class Environment {
  static const String API_DAO = "https://pro.mundo-negocio.com";
  static const String CLOUD_FRONT = "https://pro.mundo-negocio.com";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: "APP_USR-e87ff41c-f3e4-4d36-95d8-d634b31cd375",
    accessToken: "APP_USR-8826922938075265-032222-68c915590248554504c99a2efb553f8a-613164057",

    // publicKey: "TEST-916a4052-e114-42b7-9be7-394e5482e36f",
    // accessToken: "TEST-3105569650952228-111810-75ff471cb5f31d4ce3fe03894317b1d8-1242041842",
  );

}
