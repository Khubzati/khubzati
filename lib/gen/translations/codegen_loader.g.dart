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
    "login": {
      "title": "Login",
      "email": "Email",
      "password": "Password",
      "forgot_password": "Forgot Password?",
      "login_button": "Login",
      "no_account": "Don't have an account?",
      "signup": "Sign Up"
    },
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
    },
    "onboarding": {
      "select_role": {
        "title": "Select Account Type",
        "heading": "Welcome to Khubzati",
        "subheading": "Choose the account type that suits you"
      }
    },
    "roles": {
      "customer": "Customer",
      "bakery_owner": "Bakery Owner",
      "restaurant_owner": "Restaurant Owner"
    },
    "auth": {
      "signup_title": "Create New Account",
      "signup_heading": "Welcome to Khubzati",
      "signup_subheading": "Create your new account to get started",
      "signup_button": "Create Account",
      "terms_and_conditions_prompt": "I agree to the Terms and Conditions",
      "already_have_account_prompt": "Already have an account?",
      "login_link": "Login",
      "forgot_password_heading": "Forgot Password?",
      "forgot_password_subheading": "Enter your email and we'll send you a password reset link",
      "forgot_password_send_button": "Send Reset Link",
      "login_title": "Login",
      "login_subheading": "Welcome back",
      "login_button": "Login",
      "forgot_password_link": "Forgot Password?",
      "no_account_prompt": "Don't have an account?",
      "signup_link": "Sign Up",
      "otp_verification_title": "Verify Code",
      "otp_verification_heading": "Enter Verification Code",
      "otp_verification_subheading": "We've sent a verification code to your phone",
      "otp_verify_button": "Verify",
      "otp_did_not_receive_prompt": "Didn't receive the code?",
      "otp_resend_link": "Resend"
    },
    "form": {
      "username_label": "Username",
      "username_hint": "Enter your username",
      "email_label": "Email",
      "email_hint": "Enter your email",
      "phone_label": "Phone Number",
      "phone_hint": "Enter your phone number",
      "password_label": "Password",
      "password_hint": "Enter your password",
      "confirm_password_label": "Confirm Password",
      "confirm_password_hint": "Re-enter your password",
      "forgot_password_title": "Forgot Password"
    },
    "form_validation": {
      "required": "This field is required",
      "invalid_email": "Please enter a valid email address",
      "password_short": "Password must be at least 6 characters",
      "password_mismatch": "Passwords do not match",
      "agree_terms": "You must agree to the Terms and Conditions"
    },
    "common": {
      "back_button": "Back"
    },
    "bakery_owner": {
      "dashboard": {
        "title": "Bakery Dashboard",
        "sales_overview_title": "Sales Overview",
        "recent_orders_title": "Recent Orders",
        "quick_stats_title": "Quick Stats",
        "order_id_placeholder": "Order ID",
        "order_status_placeholder": "Order Status",
        "manage_products": "Manage Products",
        "manage_orders": "Manage Orders",
        "bakery_settings": "Bakery Settings"
      },
      "order_management": {
        "title": "Order Management",
        "order_id_placeholder": "Order ID",
        "customer_name_placeholder": "Customer Name",
        "order_status_placeholder": "Order Status"
      },
      "product_management": {
        "title": "Product Management",
        "add_product_button": "Add Product",
        "product_name_placeholder": "Product Name",
        "product_price_placeholder": "Price"
      }
    },
    "cart": {
      "title": "Shopping Cart",
      "item_name_placeholder": "Product Name",
      "subtotal_label": "Subtotal",
      "total_label": "Total",
      "proceed_to_checkout_button": "Proceed to Checkout",
      "empty_message": "Your cart is empty"
    },
    "checkout": {
      "title": "Checkout",
      "delivery_address_title": "Delivery Address",
      "select_address_prompt": "Select delivery address",
      "payment_method_title": "Payment Method",
      "select_payment_method_prompt": "Select payment method",
      "order_summary_title": "Order Summary",
      "delivery_fee_label": "Delivery Fee",
      "place_order_button": "Place Order"
    },
    "home": {
      "title": "Home",
      "categories_title": "Categories",
      "nearby_vendors_title": "Nearby Vendors",
      "popular_vendors_title": "Popular Vendors",
      "category_bakery": "Bakery",
      "category_restaurant": "Restaurant"
    },
    "order_confirmation": {
      "title": "Order Confirmation",
      "heading": "Order Placed Successfully!",
      "subheading": "Thank you for your order. You can track its status in your order history.",
      "track_order_button": "Track Your Order",
      "back_to_home_button": "Back to Home"
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
    "login": {
      "title": "تسجيل الدخول",
      "email": "البريد الإلكتروني",
      "password": "كلمة المرور",
      "forgot_password": "نسيت كلمة المرور؟",
      "login_button": "تسجيل الدخول",
      "no_account": "ليس لديك حساب؟",
      "signup": "إنشاء حساب"
    },
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
    },
    "onboarding": {
      "select_role": {
        "title": "اختر نوع الحساب",
        "heading": "مرحباً بك في خُبزاتي",
        "subheading": "اختر نوع الحساب المناسب لك"
      }
    },
    "roles": {
      "customer": "عميل",
      "bakery_owner": "صاحب مخبز",
      "restaurant_owner": "صاحب مطعم"
    },
    "auth": {
      "signup_title": "إنشاء حساب جديد",
      "signup_heading": "مرحباً بك في خُبزاتي",
      "signup_subheading": "أنشئ حسابك الجديد للبدء",
      "signup_button": "إنشاء حساب",
      "terms_and_conditions_prompt": "أوافق على الشروط والأحكام",
      "already_have_account_prompt": "لديك حساب بالفعل؟",
      "login_link": "تسجيل الدخول",
      "forgot_password_heading": "نسيت كلمة المرور؟",
      "forgot_password_subheading": "أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور",
      "forgot_password_send_button": "إرسال رابط إعادة التعيين",
      "login_title": "تسجيل الدخول",
      "login_subheading": "مرحباً بك مرة أخرى",
      "login_button": "تسجيل الدخول",
      "forgot_password_link": "نسيت كلمة المرور؟",
      "no_account_prompt": "ليس لديك حساب؟",
      "signup_link": "إنشاء حساب",
      "otp_verification_title": "تحقق من الرمز",
      "otp_verification_heading": "أدخل رمز التحقق",
      "otp_verification_subheading": "تم إرسال رمز التحقق إلى رقم هاتفك",
      "otp_verify_button": "تحقق",
      "otp_did_not_receive_prompt": "لم تستلم الرمز؟",
      "otp_resend_link": "إعادة إرسال"
    },
    "form": {
      "username_label": "اسم المستخدم",
      "username_hint": "أدخل اسم المستخدم",
      "email_label": "البريد الإلكتروني",
      "email_hint": "أدخل بريدك الإلكتروني",
      "phone_label": "رقم الهاتف",
      "phone_hint": "أدخل رقم هاتفك",
      "password_label": "كلمة المرور",
      "password_hint": "أدخل كلمة المرور",
      "confirm_password_label": "تأكيد كلمة المرور",
      "confirm_password_hint": "أعد إدخال كلمة المرور",
      "forgot_password_title": "نسيت كلمة المرور"
    },
    "form_validation": {
      "required": "هذا الحقل مطلوب",
      "invalid_email": "يرجى إدخال بريد إلكتروني صحيح",
      "password_short": "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
      "password_mismatch": "كلمة المرور غير متطابقة",
      "agree_terms": "يجب الموافقة على الشروط والأحكام"
    },
    "common": {
      "back_button": "رجوع"
    },
    "bakery_owner": {
      "dashboard": {
        "title": "لوحة تحكم المخبز",
        "sales_overview_title": "نظرة عامة على المبيعات",
        "recent_orders_title": "الطلبات الحديثة",
        "quick_stats_title": "الإحصائيات السريعة",
        "order_id_placeholder": "رقم الطلب",
        "order_status_placeholder": "حالة الطلب",
        "manage_products": "إدارة المنتجات",
        "manage_orders": "إدارة الطلبات",
        "bakery_settings": "إعدادات المخبز"
      },
      "order_management": {
        "title": "إدارة الطلبات",
        "order_id_placeholder": "رقم الطلب",
        "customer_name_placeholder": "اسم العميل",
        "order_status_placeholder": "حالة الطلب"
      },
      "product_management": {
        "title": "إدارة المنتجات",
        "add_product_button": "إضافة منتج",
        "product_name_placeholder": "اسم المنتج",
        "product_price_placeholder": "السعر"
      }
    },
    "cart": {
      "title": "سلة التسوق",
      "item_name_placeholder": "اسم المنتج",
      "subtotal_label": "المجموع الفرعي",
      "total_label": "المجموع الكلي",
      "proceed_to_checkout_button": "المتابعة للدفع",
      "empty_message": "سلة التسوق فارغة"
    },
    "checkout": {
      "title": "إتمام الطلب",
      "delivery_address_title": "عنوان التوصيل",
      "select_address_prompt": "اختر عنوان التوصيل",
      "payment_method_title": "طريقة الدفع",
      "select_payment_method_prompt": "اختر طريقة الدفع",
      "order_summary_title": "ملخص الطلب",
      "delivery_fee_label": "رسوم التوصيل"
    },
    "home": {
      "title": "الرئيسية",
      "categories_title": "التصنيفات",
      "nearby_vendors_title": "المتاجر القريبة",
      "popular_vendors_title": "المتاجر الشائعة",
      "category_bakery": "مخبز",
      "category_restaurant": "مطعم"
    },
    "order_confirmation": {
      "title": "تأكيد الطلب",
      "heading": "تم إرسال طلبك بنجاح!",
      "subheading": "شكراً لطلبك. يمكنك تتبع حالته من سجل الطلبات.",
      "track_order_button": "تتبع طلبك",
      "back_to_home_button": "العودة إلى الرئيسية"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "ar": _ar};
}
