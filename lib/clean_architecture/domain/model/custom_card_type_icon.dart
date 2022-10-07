import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';

class CustomCardTypeIcon {
  CustomCardTypeIcon({
    required this.cardType,
    required this.cardImage,
  });

  CardType? cardType;
  Widget cardImage;
}
