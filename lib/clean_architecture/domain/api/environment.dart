import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_credentials.dart';

class Environment {
  static const String API_DAO = "https://pro.mundo-negocio.com";
  static const String CLOUD_FRONT = "https://pro.mundo-negocio.com";

  // https://d6ypdlu64lib9.cloudfront.net
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: "APP_USR-f08670bc-042e-4015-bfd3-abf7abff1279",
    accessToken:
        "APP_USR-8138917307221352-092416-5bc3b7313393fa9644e8e9ce1c5b5694-306823887",
  );
}
