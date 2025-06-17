// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "app": {
    "otp_verification": {
      "title": "Verify the phone number",
      "instruction": "Please enter the 6-digit verification code sent to",
      "resend_code": "Resend Code",
      "change_phone": "Change Phone Number",
      "verify": "Verify"
    },
    "general": {
      "app_back": "back",
      "admin_succes_message": "Your request has been successfully sent!",
      "logout": "Logout"
    },
    "userTypeSelection": {
      "addNewType": "Add another category",
      "title": "Khubzati",
      "driver": "Driver",
      "bakery": "Bakery",
      "WelcomeText": "Welcome to khubzati",
      "resturant": "Resturant",
      "createAccountHint": "Create account as...",
      "thankYouMessage": "Thank you for applying to join KHUBZATI.\nYour application has been received, and we will respond within 3 working days!\nLooking forward to working with you."
    },
    "login": {},
    "button": {
      "search": "Search"
    },
    "signup": {
      "appBarTitle": "Welcome to khubzati",
      "app_signup_createNewAccount": "Create a New Account",
      "app_signup_bakeryName": "Bakery Name",
      "app_signup_enterBakeryName": "Enter the Bakery Name",
      "app_signup_phoneNumber": "Phone Number",
      "app_signup_location": "Location",
      "app_signup_bakeryLocation": "Bakery Location",
      "app_signup_bakeryLogo": "Bakery Logo",
      "app_signup_chooseFile": "Choose File",
      "app_signup_commercialRegistry": "Commercial Registry",
      "app_signup_next": "Next",
      "app_signup_phoneNumber_hint": "Enter phone number",
      "app_signup_location_hint": "Enter location",
      "already_have_account": "Already have an account?",
      "login": "Login",
      "attach_files_again": "Please attach the files again.",
      "attach_logo": "Attach Logo",
      "attach_commercial_registry": "Attach Commercial Registry"
    },
    "error": {
      "requiredField": "This field is required",
      "firstName": {
        "lettersOnly": "First name must contain letters only",
        "length": "First name must be at least 2 characters long"
      },
      "middleName": {
        "lettersOnly": "Middle name must contain letters only",
        "length": "Middle name must be at least 2 characters long"
      },
      "lastName": {
        "lettersOnly": "Last name must contain letters only",
        "length": "Last name must be at least 2 characters long"
      },
      "email": {
        "invalid": "Please enter a valid email address"
      },
      "password": {
        "length": "Password must be at least 8 characters long",
        "missing": "Password must include at least one uppercase letter, one lowercase letter, one number, and one special character"
      },
      "confirmPassword": {
        "mismatch": "Passwords don't match! Try again"
      },
      "dateOfBirthAge": {
        "invalidAge": "Invalid birth date. You must be at least {} years old to register"
      },
      "phoneNumber": {
        "invalidNumber": "Please enter a valid phone number."
      }
    },
    "apiError": {
      "connection": "Please check your internet connection",
      "server": "Unexpected error, Please try later",
      "sessionExpired": "Session expired. Please log in again"
    },
    "errorPage": {
      "title": "No Internet",
      "subTitle": "You must connect to the internet to complete this action!"
    },
    "bread_type": {
      "panel_title": "Category",
      "title": "Enter Bread Types and Daily Quantities",
      "instruction": "Please fill in the details below.",
      "name": "Name",
      "name_placeholder": "Enter name",
      "type": "Type",
      "type_placeholder": "Select type",
      "quantity": "Quantity",
      "quantity_placeholder": "Enter quantity",
      "unit": "Unit",
      "unit_placeholder": "Kilograms",
      "price": "Price",
      "price_placeholder": "Enter price",
      "calories": "Calories",
      "calories_placeholder": "Enter calories",
      "submit": "Submit",
      "add_another": "Add Another Item"
    }
  }
};
static const Map<String,dynamic> _ar = {
  "app": {
    "otp_verification": {
      "title": "تحقق من رقم الهاتف",
      "instruction": "يرجى إدخال رمز التحقق المؤلف من 6 أرقام المرسل إلى",
      "resend_code": "اعادة ارسال الرمز",
      "change_phone": "تغيير رقم الهاتف",
      "verify": "تحقق"
    },
    "general": {
      "app_back": "رجوع",
      "admin_succes_message": "تم إرسال طلبك بنجاح!",
      "logout": "تسجيل خروج"
    },
    "userTypeSelection": {
      "addNewType": "إضافة صنف آخر",
      "title": "خُبزاتي",
      "driver": "سائق",
      "resturant": "مطعم",
      "bakery": "مخبز",
      "WelcomeText": "اهلاً بك في خُبزاتي",
      "createAccountHint": "إنشاء حساب كـ...",
      "thankYouMessage": "شكرًا لك على تقديم طلب انضمام لخُبزاتي\nلقد تم استلام طلبك، وسيتم الرد خلال 3 أيام عمل!\nمتطلعين للعمل معكم."
    },
    "login": {},
    "button": {
      "search": "بحث"
    },
    "signup": {
      "appBarTitle": " مرحبًا بك في خُبزاتي",
      "app_signup_createNewAccount": "أنشئ حساب جديد",
      "app_signup_bakeryName": "اسم المخبز",
      "app_signup_enterBakeryName": "ادخل اسم المخبز",
      "app_signup_phoneNumber": "رقم الهاتف",
      "app_signup_phoneNumber_hint": "ادخل رقم الهاتف",
      "app_signup_location": "الموقع",
      "app_signup_location_hint": "ادخل الموقع",
      "app_signup_bakeryLocation": "موقع المخبز",
      "app_signup_bakeryLogo": "لوجو المخبز",
      "app_signup_chooseFile": "اختيار ملف",
      "app_signup_commercialRegistry": "السجل التجاري",
      "app_signup_next": "التالي",
      "already_have_account": "هل لديك حساب بالفعل؟",
      "login": "تسجيل دخول",
      "commercialRegistry": "السجل التجاري",
      "attach_files_again": "الرجاء ارفاق الملفات مرة اخرى",
      "attach_logo": "إرفاق لوجو",
      "attach_commercial_registry": "إرفاق السجل التجاري"
    },
    "error": {
      "requiredField": "هذا الحقل مطلوب",
      "firstName": {
        "lettersOnly": "يجب أن يتكون الاسم الاول من أحرف فقط",
        "length": "يجب أن يكون الاسم الاول على الأقل ٢ أحرف"
      },
      "middleName": {
        "lettersOnly": "يجب أن يتكون الاسم الاوسط من أحرف فقط",
        "length": "يجب أن يكون الاسم الاوسط على الأقل ٢ أحرف"
      },
      "lastName": {
        "lettersOnly": "يجب أن يتكون الاسم الاخير من أحرف فقط",
        "length": "يجب أن يكون الاسم الاخير على الأقل ٢ أحرف"
      },
      "email": {
        "invalid": "يرجى إدخال عنوان بريد إلكتروني صحيح"
      },
      "password": {
        "length": "يجب أن تكون كلمة المرور على الأقل ٨ أحرف",
        "missing": "يرجى تضمين حرف كبير وحرف صغير ورقم وحرف خاص على الأقل"
      },
      "confirmPassword": {
        "mismatch": "كلمة المرور غير متطابقة! تأكد مرة أخرى"
      },
      "dateOfBirthAge": {
        "invalidAge": "تاريخ الميلاد غير صالح. يجب أن يكون عمرك {} عامًا على الأقل للتسجيل"
      },
      "phoneNumber": "يرجى إدخال رقم هاتف صحيح."
    },
    "apiError": {
      "connection": "الرجاء التحقق من اتصال الانترنت الخاص بك",
      "server": "حدث خطأ ما، يرجى المحاولة لاحقا",
      "sessionExpired": "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى"
    },
    "errorPage": {
      "title": "لا يوجد اتصال بالإنترنت",
      "subTitle": "يجب عليك الاتصال بالإنترنت لإتمام هذا الإجراء!"
    },
    "bread_type": {
      "panel_title": "الصنف",
      "title": "ادخل أنواع الخبز وكميتها اليومية",
      "instruction": "يرجى ملء التفاصيل أدناه.",
      "name": "اسم الصنف",
      "name_placeholder": "ادخل الاسم",
      "type": "النوع",
      "type_placeholder": "اختر النوع",
      "quantity": "الكمية",
      "quantity_placeholder": "أدخل الكمية",
      "unit": "الوحدة",
      "unit_placeholder": "بالكيلو",
      "price": "السعر",
      "price_placeholder": "ادخل السعر",
      "calories": "السعرات الحرارية",
      "calories_placeholder": "ادخل السعرات الحرارية",
      "submit": "إرسال",
      "add_another": "اضافة صنف آخر"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "ar": _ar};
}
