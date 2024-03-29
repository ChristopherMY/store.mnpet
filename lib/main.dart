import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/auth_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/cart_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/hive_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/home_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/local_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/payment_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/product_service.dart';
import 'package:store_mundo_negocio/clean_architecture/data/datasource/user_service.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_screen.dart';
import 'package:store_mundo_negocio/firebase_options.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "39757960943-hrc1be085b6ts1u1s4el4a5tf4fcgb4p.apps.googleusercontent.com",

  // scopes: <String>[
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ],
);



void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   // _sub?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeRepositoryInterface>(
          create: (context) => HomeService(),
        ),
        Provider<CartRepositoryInterface>(
          create: (context) => CartService(),
        ),
        Provider<ProductRepositoryInterface>(
          create: (context) => ProductService(),
        ),
        Provider<LocalRepositoryInterface>(
          create: (context) => LocalService(),
        ),
        Provider<HiveRepositoryInterface>(
          create: (context) => HiveService(),
        ),
        Provider<UserRepositoryInterface>(
          create: (context) => UserService(),
        ),
        Provider<AuthRepositoryInterface>(
          create: (context) => AuthService(),
        ),
        Provider<PaymentRepositoryInterface>(
          create: (context) => PaymentService(),
        ),
      ],
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => MainBloc(
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
            hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
            productRepositoryInterface:
                context.read<ProductRepositoryInterface>(),
            userRepositoryInterface: context.read<UserRepositoryInterface>(),
            cartRepositoryInterface: context.read<CartRepositoryInterface>(),
          )
            ..handleLoadSession()
            ..verifyExistsCartTemporal()
            ..initRegion(context),
          builder: (context, child) {
            return Consumer<MainBloc>(
              builder: (context, provider, child) {
                return MaterialApp(
                  title: 'Mundo Negocio',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData().copyWith(
                    backgroundColor: Colors.white,
                    primaryColor: Colors.black,
                    textSelectionTheme: const TextSelectionThemeData(
                      cursorColor: Colors.black,
                      selectionHandleColor: Colors.black,
                    ),
                    primaryTextTheme: GoogleFonts.robotoTextTheme(),
                    accentTextTheme: GoogleFonts.robotoTextTheme(),
                    textTheme: GoogleFonts.robotoTextTheme()
                        .copyWith(
                          subtitle1: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                          subtitle2: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          bodyText1: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          caption: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                            fontSize: 14,
                          ),
                          bodyText2: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          headline1: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          headline2: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.blueAccent,
                          ),
                          headline3: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          headline4: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            height: 1,
                            color: Colors.blueAccent,
                          ),
                          headline5: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        )
                        .apply(
                          bodyColor: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                  ),
                  home: const MainScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}
