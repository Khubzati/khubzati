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
    "profile": {
      "title": "Profile",
      "edit_profile_label": "Edit Profile",
      "manage_addresses_label": "Manage Addresses",
      "order_history_label": "Order History",
      "notifications_label": "Notifications",
      "language_label": "Language",
      "help_support_label": "Help & Support",
      "logout_button": "Logout",
      "bakery_name": "Bakery Name",
      "bakery_name_hint": "Enter bakery name",
      "bakery_name_required": "Bakery name is required",
      "address": "Address",
      "address_hint": "Enter bakery address",
      "address_required": "Address is required",
      "phone_number": "Phone Number",
      "phone_number_hint": "Enter phone number",
      "phone_number_required": "Phone number is required",
      "phone_number_invalid": "Please enter a valid phone number",
      "edit_info": "Edit My Information",
      "save_success": "Profile updated successfully"
    },
    "vendor_listing": {
      "title": "Vendors",
      "vendor_name_placeholder": "Vendor Name",
      "vendor_details_placeholder": "Vendor Details"
    },
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
      "logout": "Logout",
      "next": "Next",
      "browse": "Browse"
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
      "forgot_password_title": "Forgot Password",
      "bakery_name_label": "Bakery Name",
      "bakery_name_hint": "Enter your bakery name",
      "location_label": "Location",
      "location_hint": "Enter bakery location",
      "bakery_license_label": "Bakery License/Registration",
      "bakery_license_placeholder": "No file selected"
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
      "category_restaurant": "Restaurant",
      "stats_total_revenue": "Total Revenue",
      "stats_completed_orders": "Completed Orders",
      "stats_incomplete_orders": "Incomplete Orders"
    },
    "order_confirmation": {
      "title": "Order Confirmation",
      "heading": "Order Placed Successfully!",
      "subheading": "Thank you for your order. You can track its status in your order history.",
      "track_order_button": "Track Your Order",
      "back_to_home_button": "Back to Home"
    },
    "product_detail": {
      "title": "Product Details",
      "add_to_cart_button": "Add to Cart"
    },
    "order_history": {
      "title": "Order History",
      "order_id_placeholder": "Order ID",
      "date_placeholder": "Date",
      "status_placeholder": "Status",
      "total_placeholder": "Total",
      "empty_message": "No orders found"
    },
    "vendor_detail": {
      "title": "Vendor Details",
      "product_categories_title": "Categories",
      "products_title": "Products",
      "reviews_title": "Reviews"
    },
    "restaurant_owner": {
      "dashboard": {
        "title": "Restaurant Dashboard",
        "sales_overview_title": "Sales Overview",
        "recent_orders_title": "Recent Orders",
        "quick_stats_title": "Quick Stats",
        "order_id_placeholder": "Order ID",
        "order_status_placeholder": "Order Status",
        "manage_menu": "Manage Menu",
        "manage_orders": "Manage Orders",
        "restaurant_settings": "Restaurant Settings"
      },
      "order_management": {
        "title": "Order Management",
        "order_id_placeholder": "Order ID",
        "customer_name_placeholder": "Customer Name",
        "order_status_placeholder": "Order Status"
      },
      "product_management": {
        "title": "Product Management",
        "add_item_button": "Add Item",
        "item_name_placeholder": "Item Name",
        "item_price_placeholder": "Price"
      }
    },
    "navigation": {
      "home": "Home",
      "orders": "Orders",
      "profile": "Profile",
      "settings": "Settings"
    },
    "search": {
      "hint": "Search for vendors or products...",
      "no_results": "No results found",
      "recent_searches": "Recent Searches"
    },
    "order_sheet": {
      "notes": "Notes",
      "view_order": "View Order",
      "order_hash": "#Order",
      "order_status": "Order Status",
      "incomplete": "Incomplete",
      "order_value": "Order Value",
      "currency_jod": "JOD",
      "date": "Date",
      "location": "Location",
      "default_restaurant_name": "Al Sarwat Restaurant",
      "sample_items": "Toast, Shrak, Arabic, Brown Toast,\nArabic, Shrak",
      "order_details": "Order Details",
      "sample_item_names": "Toast \nShrak\nArabic\nBrown Toast\nArabic\nShrak\nTax\nDelivery",
      "sample_quantities": "x2 \nx30\nx5\nx7\nx22\nx67",
      "sample_prices": "1.75 \n0.8\n1.50\n1.25\n0.4\n0.9\n0.50\n2.00",
      "total_value": "Total Value",
      "print_invoice": "Print Invoice",
      "order_in_preparation": "Order In Preparation",
      "start_preparing_order": "Start Preparing Order",
      "time": "Time"
    },
    "empty_state": {
      "no_orders_title": "No Orders Yet",
      "no_orders_subtitle": "No orders have been received yet",
      "no_orders_description": "Orders will appear here once customers start placing them"
    },
    "order_details": {
      "title": "Order Details",
      "order_id": "Order",
      "customer": "Customer",
      "order_value": "Order Value",
      "date": "Date",
      "location": "Location",
      "product_type": "Type",
      "product_price": "Price",
      "product_quantity": "Quantity",
      "product_total": "Total",
      "currency": "JOD",
      "tax": "Tax",
      "delivery": "Delivery",
      "payment_method": "Payment Method",
      "total_value": "Total Value",
      "print_invoice": "Print Invoice",
      "start_preparation": "Start Order Preparation"
    },
    "inventory": {
      "title": "Inventory",
      "description": "List of bread types and quantities available to you.",
      "product_details": "Product Details",
      "product_name": "White Toast Bread",
      "price_per_quantity": "Price/Quantity",
      "available": "Available",
      "unit": "Unit",
      "category": "Category",
      "nutritional_value": "Nutritional Value",
      "calories": "Calories",
      "details": "Details",
      "loading": "Loading inventory...",
      "error": "Error loading inventory",
      "retry": "Retry",
      "editCategory": "Edit Category",
      "saveChanges": "Save Changes"
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
      "logout": "تسجيل خروج",
      "next": "التالي",
      "browse": "تصفح"
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
      "forgot_password_title": "نسيت كلمة المرور",
      "bakery_name_label": "اسم المخبز",
      "bakery_name_hint": "أدخل اسم المخبز",
      "location_label": "الموقع",
      "location_hint": "أدخل موقع المخبز",
      "bakery_license_label": "رخصة المخبز/التسجيل",
      "bakery_license_placeholder": "لم يتم اختيار ملف"
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
      "category_restaurant": "مطعم",
      "stats_total_revenue": "إجمالي الإيرادات",
      "stats_completed_orders": "الطلبات المكتملة",
      "stats_incomplete_orders": "الطلبات غير المكتملة"
    },
    "order_confirmation": {
      "title": "تأكيد الطلب",
      "heading": "تم إرسال طلبك بنجاح!",
      "subheading": "شكراً لطلبك. يمكنك تتبع حالته من سجل الطلبات.",
      "track_order_button": "تتبع طلبك",
      "back_to_home_button": "العودة إلى الرئيسية"
    },
    "profile": {
      "title": "الملف الشخصي",
      "edit_profile_label": "تعديل الملف الشخصي",
      "manage_addresses_label": "إدارة العناوين",
      "order_history_label": "سجل الطلبات",
      "notifications_label": "الإشعارات",
      "language_label": "اللغة",
      "help_support_label": "المساعدة والدعم",
      "logout_button": "تسجيل الخروج",
      "bakery_name": "اسم المخبز",
      "bakery_name_hint": "أدخل اسم المخبز",
      "bakery_name_required": "اسم المخبز مطلوب",
      "address": "العنوان",
      "address_hint": "أدخل عنوان المخبز",
      "address_required": "العنوان مطلوب",
      "phone_number": "رقم الهاتف",
      "phone_number_hint": "أدخل رقم الهاتف",
      "phone_number_required": "رقم الهاتف مطلوب",
      "phone_number_invalid": "يرجى إدخال رقم هاتف صحيح",
      "edit_info": "تعديل معلوماتي",
      "save_success": "تم تحديث الملف الشخصي بنجاح"
    },
    "vendor_listing": {
      "title": "المتاجر",
      "vendor_name_placeholder": "اسم المتجر",
      "vendor_details_placeholder": "تفاصيل المتجر"
    },
    "product_detail": {
      "title": "تفاصيل المنتج",
      "add_to_cart_button": "أضف إلى السلة"
    },
    "order_history": {
      "title": "سجل الطلبات",
      "order_id_placeholder": "رقم الطلب",
      "date_placeholder": "التاريخ",
      "status_placeholder": "الحالة",
      "total_placeholder": "المجموع",
      "empty_message": "لا توجد طلبات"
    },
    "vendor_detail": {
      "title": "تفاصيل المتجر",
      "product_categories_title": "التصنيفات",
      "products_title": "المنتجات",
      "reviews_title": "التقييمات"
    },
    "restaurant_owner": {
      "dashboard": {
        "title": "لوحة تحكم المطعم",
        "sales_overview_title": "نظرة عامة على المبيعات",
        "recent_orders_title": "الطلبات الحديثة",
        "quick_stats_title": "الإحصائيات السريعة",
        "order_id_placeholder": "رقم الطلب",
        "order_status_placeholder": "حالة الطلب",
        "manage_menu": "إدارة القائمة",
        "manage_orders": "إدارة الطلبات",
        "restaurant_settings": "إعدادات المطعم"
      },
      "order_management": {
        "title": "إدارة الطلبات",
        "order_id_placeholder": "رقم الطلب",
        "customer_name_placeholder": "اسم العميل",
        "order_status_placeholder": "حالة الطلب"
      },
      "product_management": {
        "title": "إدارة المنتجات",
        "add_item_button": "إضافة عنصر",
        "item_name_placeholder": "اسم العنصر",
        "item_price_placeholder": "السعر"
      }
    },
    "navigation": {
      "home": "الرئيسية",
      "orders": "الطلبات",
      "profile": "الملف الشخصي",
      "settings": "الإعدادات"
    },
    "search": {
      "hint": "ابحث عن المتاجر أو المنتجات...",
      "no_results": "لا توجد نتائج",
      "recent_searches": "البحث الحديث"
    },
    "order_sheet": {
      "notes": "ملاحظات",
      "view_order": "عرض الطلب",
      "order_hash": "#طلب",
      "order_status": "حالة الطلب",
      "incomplete": "غير مكتمل",
      "order_value": "قيمة الطلب",
      "currency_jod": "د.أ",
      "date": "التاريخ",
      "location": "الموقع",
      "default_restaurant_name": "مطعم السروات",
      "sample_items": "توست، شراك، عربي، توست اسمر،\nعربي، شراك",
      "order_details": "تفاصيل الطلب",
      "sample_item_names": "توست \nشراك\nعربي\nتوست اسمر\nعربي\nشراك\nضريبة\nتوصيل",
      "sample_quantities": "x2 \nx30\nx5\nx7\nx22\nx67",
      "sample_prices": "1.75 \n0.8\n1.50\n1.25\n0.4\n0.9\n0.50\n2.00",
      "total_value": "القيمة الكلية",
      "print_invoice": "طباعة الفاتورة",
      "order_in_preparation": "الطلب قيد التحضير",
      "start_preparing_order": "بدء تحضير الطلب",
      "time": "الوقت"
    },
    "empty_state": {
      "no_orders_title": "لا توجد طلبات",
      "no_orders_subtitle": "لم يتم استلام أي طلبات بعد",
      "no_orders_description": "ستظهر الطلبات هنا بمجرد أن يبدأ العملاء في تقديم طلباتهم"
    },
    "order_details": {
      "title": "تفاصيل الطلب",
      "order_id": "طلب",
      "customer": "الزبون",
      "order_value": "قيمة الطلب",
      "date": "التاريخ",
      "location": "الموقع",
      "product_type": "النوع",
      "product_price": "القيمة",
      "product_quantity": "الكمية",
      "product_total": "القيمة الكلية",
      "currency": "د.أ",
      "tax": "الضريبة",
      "delivery": "التوصيل",
      "payment_method": "طريقة الدفع",
      "total_value": "القيمة الكلية",
      "print_invoice": "اصدار فاتورة",
      "start_preparation": "بدء تحضير الطلب"
    },
    "inventory": {
      "title": "المخزون",
      "description": "قائمة أنواع وكميات الخبز المتوفر لديك.",
      "product_details": "تفاصيل الصنف",
      "product_name": "خبز توست أبيض",
      "price_per_quantity": "السعر/كمية",
      "available": "المتوفر",
      "unit": "الوحدة",
      "category": "الصنف",
      "nutritional_value": "القيمة الغذائية",
      "calories": "السعرات الحرارية",
      "details": "التفاصيل",
      "loading": "جاري تحميل المخزون...",
      "error": "خطأ في تحميل المخزون",
      "retry": "إعادة المحاولة",
      "editCategory": "تعديل الصنف",
      "saveChanges": "حفظ التعديلات"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "ar": _ar};
}
