
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_credentials.dart';

class Environment {
  static const String API_DAO = "http://192.168.1.18:5002";
  // static const String API_DAO = "https://pro.mundo-negocio.com";
  static const String CLOUD_FRONT = "http://192.168.1.18:5002";
  // https://d6ypdlu64lib9.cloudfront.net
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
    publicKey: "TEST-12a624ed-8ede-40f1-ba2d-e5be297358b0",
    accessToken: "TEST-8056583532651627-022422-c51fdf6d5d62f82afba6ec6ede6e2cfb-1080132218",
    // publicKey: "APP_USR-f20b3f46-4eb2-40b3-8907-ac66dda1ffa3",
    // accessToken: "APP_USR-1468359711536620-011115-3902a808b48d4a0f894ebd98c1a701e0-1054944760",
  );
}
