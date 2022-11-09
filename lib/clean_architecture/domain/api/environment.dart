
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_credentials.dart';

class Environment {
  // static const String API_DAO = "http://192.168.1.17:5000";
  static const String API_DAO = "https://pro.mundo-negocio.com";
  static const String CLOUD_FRONT = "https://pro.mundo-negocio.com";
  // https://d6ypdlu64lib9.cloudfront.net
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: "TEST-f4badb23-8829-4783-8d29-87710ac358d8",
    accessToken: "TEST-8138917307221352-092416-b1a010d8c2d36e8871a3d1ba054d9f09-306823887",
    // publicKey: "APP_USR-f20b3f46-4eb2-40b3-8907-ac66dda1ffa3",
    // accessToken: "APP_USR-1468359711536620-011115-3902a808b48d4a0f894ebd98c1a701e0-1054944760",
  );
}
