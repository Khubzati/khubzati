// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../gen/assets.gen.dart';
import '../../gen/translations/locale_keys.g.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final List<Map<String, String>> userTypeImageTitleMap = [
  {
    "image": Assets.images.baker,
    "title": LocaleKeys.app_userTypeSelection_bakery.tr()
  },
  {
    "image": Assets.images.resturant,
    "title": LocaleKeys.app_userTypeSelection_resturant.tr()
  },
  {
    "image": Assets.images.driver,
    "title": LocaleKeys.app_userTypeSelection_driver.tr()
  },
];

abstract class AppRegex {
  static final name = RegExp(r'(?:\s*\p{L}){2,}$',
      unicode: true); // letters and spaces from any lang

  static final password = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,}$'); // (at least [8 chrs, 1 uppercase, 1 lowercase, 1 number, 1 special chr])
  static final email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
}

abstract class AppFormFields {
  static const firstName = 'firstName';
  static const middleName = 'middleName';
  static const lastName = 'lastName';
  static const dateOfBirth = 'dateOfBirth';
  static const email = 'email';
  static const gender = "gender";
  static const phoneNumber = "phoneNumber";
  static const placeOfResidence = "placeOfResidence";
}

final List<IsoCode> customCountries =
    IsoCode.values.where((country) => country != IsoCode.IL).toList();
