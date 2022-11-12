
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_credentials.dart';

class Environment {
  // static const String API_DAO = "http://192.168.1.17:5000";
  static const String API_DAO = "https://pro.mundo-negocio.com";
  static const String CLOUD_FRONT = "https://pro.mundo-negocio.com";
  // https://d6ypdlu64lib9.cloudfront.net
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: "TEST-41aadc86-4a6e-460a-a597-6c8ac388e9ba",
    accessToken: "TEST-7101164779877143-110918-288f61ee49c497bdf0fcb9f5b7f9c95e-1235670269",
    // publicKey: "APP_USR-f20b3f46-4eb2-40b3-8907-ac66dda1ffa3",
    // accessToken: "APP_USR-1468359711536620-011115-3902a808b48d4a0f894ebd98c1a701e0-1054944760",
  );
}
