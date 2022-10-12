class MercadoPagoDocumentType {
  //IDENTIFICADOR DEL TIPO DE IDENTIFICACION
  String? id;

  //NOMBRE DEL TIPO DE IDENTIFICACION
  String? name;

  //TIPO DE DATO DEL NUMERO DE IDENTIFICACION
  String? type;

  //MINIMA LONGITUD DEL NUMERO DE IDENTIFICACION
  int? minLength;

  //MAXIMA LONGITUD DEL NUMERO DE IDENTIFICACION
  int? maxLength;

  bool? checked;
  List<MercadoPagoDocumentType> documentTypeList = [];

  MercadoPagoDocumentType();

  MercadoPagoDocumentType.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      return;
    }
    for (var item in jsonList) {
      final chat = MercadoPagoDocumentType.fromJsonMap(item);
      documentTypeList.add(chat);
    }
  }

  MercadoPagoDocumentType.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    minLength = (json['min_length'] != null)
        ? int.parse(json['min_length'].toString())
        : 0;
    maxLength = (json['max_length'] != null)
        ? int.parse(json['max_length'].toString())
        : 0;
    checked = json['checked'] == null ? false : json['checked'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'min_length': minLength,
        'max_length': maxLength,
        'checked': checked
      };
}

/*
{
      "token": "ssswdwd",
      "issuerId": "",
      "paymentMethodId": "s",
      "transactionAmount": 15.7,
      "installments": 4877,
      "description": "Descripción del producto",
      "payer": {
        "email": "",
        "identification": {
          "type": "",
          "number": ""
        },
        "first_name": "",
        "last_name": ""
      },
      "orderbody": {
        "additional_info": "",
        "company_name": "",
        "items": [{
         "category_id": "Deporte",
        "brand_id": "Biflex",
        "currency_id": "PEN",
        "description": "asdasdasdasd",
        "picture_url": "https://api.lorem.space/image/furniture?w=150&h=150",
        "quantity": 1,
        "unit_price": 121.2,
        "title": "Lorem Ipsum is simply dummy text of the printing and typesetting 1",
        "slug": "lorem-ipsum-is-simply-dummy-text-of-the-printing-and-typesetting-1",
        "sku": "asdajusdbaiusdbaisd",
        "meta": {
            "brand": "613fa6e12bc2c3113ede8ee6",
            "category": "6142b650d74336a7d3768284",
            "product_type": "613679c66400921fed178d95",
            "model": "61d4cc606715807722039781"
        },
        "shipping_price": 1.5
        }],
        "payer": {
          "name": "",
          "surname": "",
          "email": "",
          "phone": {
            "area_code": "+51",
            "number": ""
          },
          "identification": {
            "type": "",
            "number": ""
          },
          "address": {
            "zip_code": "",
            "department_name": "",
            "residence": "",
            "street_name": "",
            "street_detail": ""
          }
        },
        "sub_total": 8.25,
        "ship_price": 48.25
      }

}



 */
