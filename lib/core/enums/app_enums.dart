enum LookUpsData {
  language,
  nationality,
  country,
  gender,
  recitation,
  recitationType,
  userIdentityType,
  ageRange,
  requestStatus,
  requestType,
  requesterSide,
  day;

  int get intValue => index + 1;
}

enum UserIdTypes {
  identityCard,
  passport,
  drivingLicense,
  birthCertificate;

  int get intValue => index + 1;
}

enum UserTypes {
  driver,
  resturant,
  bakery;

  int get intValue => index + 1;
}
