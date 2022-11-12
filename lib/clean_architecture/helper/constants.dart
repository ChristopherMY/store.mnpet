import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';

// const kPrimaryColor = Color(0xFF17C3B2);
const kPrimaryColor = Color(0xFFF68302);
const kPrimaryColorRed = Color(0xFFFF777F);

const kDividerColor = Color(0xFFF0F0F0);

const kPrimaryBackgroundColor = Color(0xFFF2F2F2);
const kBackGroundColor = Color(0xFFF5F5F5);
const kSecondaryBackgroundColor = Color(0xFFF9F9F9);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

const kTextColor = Color(0xFF757575);
const kBlackColor = Color(0xFF000000);
const kRappiGreenColor = Color(0xFF29D884);
const kAnimationDuration = Duration(milliseconds: 200);

const kFontSizeTitleAppBar = 16.0;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(22),
  fontWeight: FontWeight.bold,
);

String splitNumberJoin(String number) {
  const int splitSize = 3;
  RegExp exp = RegExp(r"\d{" + splitSize.toString() + "}");
  Iterable<Match> matches = exp.allMatches(number);
  return matches.map((m) => int.tryParse(m.group(0)!)).join(" ");
}

final addressDefault = Address(
  ubigeo: Ubigeo(),
  lotNumber: 1,
  dptoInt: 1,
  addressDefault: false,
);

String parseDouble(String value) {
  final calc = double.parse(value).toStringAsFixed(2);
  return calc.toString();
}

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
// RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp numberValidatorReg = RegExp(r'^[0-9]+$');
const String kAddressNameNullError =
    "Por favor ingrese un alias para su dirección";
const String kNumberLotNullError = "Por favor ingrese su número de lote";
const String kDirectionNullError = "Por favor ingrese su dirección";
const String kEmailNullError = "Por favor ingrese su correo";
const String kInvalidEmailError = "Por favor ingrese un correo valido";
const String kPassNullError = "Por favor ingrese su contraseña";
const String kShortPassError = "La contraseña es demasiado corta";
const String kShortNumberPhoneError =
    "El numero de teléfono es demasiado corto";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kMatchEmailError = "Los correos no coinciden";
const String kNamelNullError = "Por favor escriba su nombre";
const String kLastNameNullError = "Por favor escriba sus apellidos";
const String kPhoneNumberNullError =
    "Por favor introduzca su número de teléfono";
const String kPhoneNumberLostNullError = "Ingrese un número correcto";
const String kAddressNullError = "Por favor ingrese su direccion";
const String kNumDocNullError = "Por favor ingrese su número de documento";
const String kNumDocLengthNullError = "Ingrese un numero de documento valido";
const String kTermsNullError =
    "Debes aceptar los términos y condiciones \npara poder registrarte";
const String kAddressTypeNullError =
    "Por favor seleccione un tipo de dirección";

const String kDeparmentNullError = "Departamento no seleccionado";
const String kProvinceNullError = "Provincia no seleccionado";
const String kDistrictNullError = "Distrito no seleccionado";
const String kEmptyField = "Verifique la información ingresada";

const Map<String, String> headers = {
  "Content-type": "application/json",
  "Custom-Origin": "app",
};

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

String? orderDetailStatus({required String status}) {
  return {
    "pending": "Pendiente",
    "approved": "Aprobado",
    "authorized": "Autorizado",
    "in_process": "Comprabando",
    "in_mediation": "Disputando",
    "rejected": "Rechazado",
    "cancelled": "Cancelado",
    "refunded": "Reembolsado ",
    "charged_back": "Contracargo",
  }[status];
}

MaterialColor? getStatusColor({required String status}) {
  return {
    "pending": Colors.orange,
    "approved": Colors.green,
    "authorized": Colors.orange,
    "in_process": Colors.orange,
    "in_mediation": Colors.orange,
    "rejected": Colors.red,
    "cancelled": Colors.orange,
    "refunded": Colors.orange,
    "charged_back": Colors.orange,
  }[status];
}
