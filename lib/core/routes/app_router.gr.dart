// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddEditAddressScreen]
class AddEditAddressRoute extends PageRouteInfo<AddEditAddressRouteArgs> {
  AddEditAddressRoute({
    Key? key,
    String? addressId,
    Map<String, dynamic>? initialData,
    List<PageRouteInfo>? children,
  }) : super(
         AddEditAddressRoute.name,
         args: AddEditAddressRouteArgs(
           key: key,
           addressId: addressId,
           initialData: initialData,
         ),
         initialChildren: children,
       );

  static const String name = 'AddEditAddressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddEditAddressRouteArgs>(
        orElse: () => const AddEditAddressRouteArgs(),
      );
      return AddEditAddressScreen(
        key: args.key,
        addressId: args.addressId,
        initialData: args.initialData,
      );
    },
  );
}

class AddEditAddressRouteArgs {
  const AddEditAddressRouteArgs({this.key, this.addressId, this.initialData});

  final Key? key;

  final String? addressId;

  final Map<String, dynamic>? initialData;

  @override
  String toString() {
    return 'AddEditAddressRouteArgs{key: $key, addressId: $addressId, initialData: $initialData}';
  }
}

/// generated route for
/// [AddNewItemScreen]
class AddNewItemRoute extends PageRouteInfo<void> {
  const AddNewItemRoute({List<PageRouteInfo>? children})
    : super(AddNewItemRoute.name, initialChildren: children);

  static const String name = 'AddNewItemRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddNewItemScreen();
    },
  );
}

/// generated route for
/// [AddReviewScreen]
class AddReviewRoute extends PageRouteInfo<AddReviewRouteArgs> {
  AddReviewRoute({
    Key? key,
    required String entityType,
    required String entityId,
    required String entityName,
    String? orderId,
    List<PageRouteInfo>? children,
  }) : super(
         AddReviewRoute.name,
         args: AddReviewRouteArgs(
           key: key,
           entityType: entityType,
           entityId: entityId,
           entityName: entityName,
           orderId: orderId,
         ),
         initialChildren: children,
       );

  static const String name = 'AddReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddReviewRouteArgs>();
      return AddReviewScreen(
        key: args.key,
        entityType: args.entityType,
        entityId: args.entityId,
        entityName: args.entityName,
        orderId: args.orderId,
      );
    },
  );
}

class AddReviewRouteArgs {
  const AddReviewRouteArgs({
    this.key,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    this.orderId,
  });

  final Key? key;

  final String entityType;

  final String entityId;

  final String entityName;

  final String? orderId;

  @override
  String toString() {
    return 'AddReviewRouteArgs{key: $key, entityType: $entityType, entityId: $entityId, entityName: $entityName, orderId: $orderId}';
  }
}

/// generated route for
/// [AddressListScreen]
class AddressListRoute extends PageRouteInfo<AddressListRouteArgs> {
  AddressListRoute({
    Key? key,
    bool isSelectionMode = false,
    String? selectedAddressId,
    List<PageRouteInfo>? children,
  }) : super(
         AddressListRoute.name,
         args: AddressListRouteArgs(
           key: key,
           isSelectionMode: isSelectionMode,
           selectedAddressId: selectedAddressId,
         ),
         initialChildren: children,
       );

  static const String name = 'AddressListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddressListRouteArgs>(
        orElse: () => const AddressListRouteArgs(),
      );
      return AddressListScreen(
        key: args.key,
        isSelectionMode: args.isSelectionMode,
        selectedAddressId: args.selectedAddressId,
      );
    },
  );
}

class AddressListRouteArgs {
  const AddressListRouteArgs({
    this.key,
    this.isSelectionMode = false,
    this.selectedAddressId,
  });

  final Key? key;

  final bool isSelectionMode;

  final String? selectedAddressId;

  @override
  String toString() {
    return 'AddressListRouteArgs{key: $key, isSelectionMode: $isSelectionMode, selectedAddressId: $selectedAddressId}';
  }
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartScreen();
    },
  );
}

/// generated route for
/// [CheckoutScreen]
class CheckoutRoute extends PageRouteInfo<void> {
  const CheckoutRoute({List<PageRouteInfo>? children})
    : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckoutScreen();
    },
  );
}

/// generated route for
/// [CustomerHomeScreen]
class CustomerHomeRoute extends PageRouteInfo<void> {
  const CustomerHomeRoute({List<PageRouteInfo>? children})
    : super(CustomerHomeRoute.name, initialChildren: children);

  static const String name = 'CustomerHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomerHomeScreen();
    },
  );
}

/// generated route for
/// [DriverDashboardScreen]
class DriverDashboardRoute extends PageRouteInfo<void> {
  const DriverDashboardRoute({List<PageRouteInfo>? children})
    : super(DriverDashboardRoute.name, initialChildren: children);

  static const String name = 'DriverDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverDashboardScreen();
    },
  );
}

/// generated route for
/// [EditProductScreen]
class EditProductRoute extends PageRouteInfo<EditProductRouteArgs> {
  EditProductRoute({
    Key? key,
    required String productId,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required String unit,
    required String imageUrl,
    List<PageRouteInfo>? children,
  }) : super(
         EditProductRoute.name,
         args: EditProductRouteArgs(
           key: key,
           productId: productId,
           name: name,
           description: description,
           price: price,
           quantity: quantity,
           unit: unit,
           imageUrl: imageUrl,
         ),
         initialChildren: children,
       );

  static const String name = 'EditProductRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProductRouteArgs>();
      return EditProductScreen(
        key: args.key,
        productId: args.productId,
        name: args.name,
        description: args.description,
        price: args.price,
        quantity: args.quantity,
        unit: args.unit,
        imageUrl: args.imageUrl,
      );
    },
  );
}

class EditProductRouteArgs {
  const EditProductRouteArgs({
    this.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  final Key? key;

  final String productId;

  final String name;

  final String description;

  final String price;

  final String quantity;

  final String unit;

  final String imageUrl;

  @override
  String toString() {
    return 'EditProductRouteArgs{key: $key, productId: $productId, name: $name, description: $description, price: $price, quantity: $quantity, unit: $unit, imageUrl: $imageUrl}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [InventoryPage]
class InventoryRoute extends PageRouteInfo<void> {
  const InventoryRoute({List<PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InventoryPage();
    },
  );
}

/// generated route for
/// [InventoryProductDetailScreen]
class InventoryProductDetailRoute
    extends PageRouteInfo<InventoryProductDetailRouteArgs> {
  InventoryProductDetailRoute({
    Key? key,
    required String productId,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required String unit,
    required String imageUrl,
    List<PageRouteInfo>? children,
  }) : super(
         InventoryProductDetailRoute.name,
         args: InventoryProductDetailRouteArgs(
           key: key,
           productId: productId,
           name: name,
           description: description,
           price: price,
           quantity: quantity,
           unit: unit,
           imageUrl: imageUrl,
         ),
         initialChildren: children,
       );

  static const String name = 'InventoryProductDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InventoryProductDetailRouteArgs>();
      return InventoryProductDetailScreen(
        key: args.key,
        productId: args.productId,
        name: args.name,
        description: args.description,
        price: args.price,
        quantity: args.quantity,
        unit: args.unit,
        imageUrl: args.imageUrl,
      );
    },
  );
}

class InventoryProductDetailRouteArgs {
  const InventoryProductDetailRouteArgs({
    this.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  final Key? key;

  final String productId;

  final String name;

  final String description;

  final String price;

  final String quantity;

  final String unit;

  final String imageUrl;

  @override
  String toString() {
    return 'InventoryProductDetailRouteArgs{key: $key, productId: $productId, name: $name, description: $description, price: $price, quantity: $quantity, unit: $unit, imageUrl: $imageUrl}';
  }
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MainNavigationScreen]
class MainNavigationRoute extends PageRouteInfo<MainNavigationRouteArgs> {
  MainNavigationRoute({
    Key? key,
    int initialIndex = 0,
    List<PageRouteInfo>? children,
  }) : super(
         MainNavigationRoute.name,
         args: MainNavigationRouteArgs(key: key, initialIndex: initialIndex),
         initialChildren: children,
       );

  static const String name = 'MainNavigationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MainNavigationRouteArgs>(
        orElse: () => const MainNavigationRouteArgs(),
      );
      return MainNavigationScreen(
        key: args.key,
        initialIndex: args.initialIndex,
      );
    },
  );
}

class MainNavigationRouteArgs {
  const MainNavigationRouteArgs({this.key, this.initialIndex = 0});

  final Key? key;

  final int initialIndex;

  @override
  String toString() {
    return 'MainNavigationRouteArgs{key: $key, initialIndex: $initialIndex}';
  }
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationScreen();
    },
  );
}

/// generated route for
/// [OrderConfirmationScreen]
class OrderConfirmationRoute extends PageRouteInfo<OrderConfirmationRouteArgs> {
  OrderConfirmationRoute({
    Key? key,
    required String orderId,
    required String transactionId,
    List<PageRouteInfo>? children,
  }) : super(
         OrderConfirmationRoute.name,
         args: OrderConfirmationRouteArgs(
           key: key,
           orderId: orderId,
           transactionId: transactionId,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderConfirmationRouteArgs>();
      return OrderConfirmationScreen(
        key: args.key,
        orderId: args.orderId,
        transactionId: args.transactionId,
      );
    },
  );
}

class OrderConfirmationRouteArgs {
  const OrderConfirmationRouteArgs({
    this.key,
    required this.orderId,
    required this.transactionId,
  });

  final Key? key;

  final String orderId;

  final String transactionId;

  @override
  String toString() {
    return 'OrderConfirmationRouteArgs{key: $key, orderId: $orderId, transactionId: $transactionId}';
  }
}

/// generated route for
/// [OrderDetailsScreen]
class OrderDetailsRoute extends PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    Key? key,
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailsRoute.name,
         args: OrderDetailsRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'OrderDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>();
      return OrderDetailsScreen(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [OtpVerificationScreen]
class OtpVerificationRoute extends PageRouteInfo<OtpVerificationRouteArgs> {
  OtpVerificationRoute({
    Key? key,
    required String phoneNumber,
    required String verificationId,
    List<PageRouteInfo>? children,
  }) : super(
         OtpVerificationRoute.name,
         args: OtpVerificationRouteArgs(
           key: key,
           phoneNumber: phoneNumber,
           verificationId: verificationId,
         ),
         initialChildren: children,
       );

  static const String name = 'OtpVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpVerificationRouteArgs>();
      return OtpVerificationScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        verificationId: args.verificationId,
      );
    },
  );
}

class OtpVerificationRouteArgs {
  const OtpVerificationRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  final Key? key;

  final String phoneNumber;

  final String verificationId;

  @override
  String toString() {
    return 'OtpVerificationRouteArgs{key: $key, phoneNumber: $phoneNumber, verificationId: $verificationId}';
  }
}

/// generated route for
/// [PaymentScreen]
class PaymentRoute extends PageRouteInfo<PaymentRouteArgs> {
  PaymentRoute({
    Key? key,
    required String orderId,
    required double amount,
    String? selectedAddressId,
    List<PageRouteInfo>? children,
  }) : super(
         PaymentRoute.name,
         args: PaymentRouteArgs(
           key: key,
           orderId: orderId,
           amount: amount,
           selectedAddressId: selectedAddressId,
         ),
         initialChildren: children,
       );

  static const String name = 'PaymentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentRouteArgs>();
      return PaymentScreen(
        key: args.key,
        orderId: args.orderId,
        amount: args.amount,
        selectedAddressId: args.selectedAddressId,
      );
    },
  );
}

class PaymentRouteArgs {
  const PaymentRouteArgs({
    this.key,
    required this.orderId,
    required this.amount,
    this.selectedAddressId,
  });

  final Key? key;

  final String orderId;

  final double amount;

  final String? selectedAddressId;

  @override
  String toString() {
    return 'PaymentRouteArgs{key: $key, orderId: $orderId, amount: $amount, selectedAddressId: $selectedAddressId}';
  }
}

/// generated route for
/// [ProductDetailScreen]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    Key? key,
    required String productId,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, productId: productId),
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return ProductDetailScreen(key: args.key, productId: args.productId);
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.productId});

  final Key? key;

  final String productId;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productId: $productId}';
  }
}

/// generated route for
/// [ProfileSettingsScreen]
class ProfileSettingsRoute extends PageRouteInfo<void> {
  const ProfileSettingsRoute({List<PageRouteInfo>? children})
    : super(ProfileSettingsRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileSettingsScreen();
    },
  );
}

/// generated route for
/// [RestaurantOwnerDashboardScreen]
class RestaurantOwnerDashboardRoute extends PageRouteInfo<void> {
  const RestaurantOwnerDashboardRoute({List<PageRouteInfo>? children})
    : super(RestaurantOwnerDashboardRoute.name, initialChildren: children);

  static const String name = 'RestaurantOwnerDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RestaurantOwnerDashboardScreen();
    },
  );
}

/// generated route for
/// [ReviewScreen]
class ReviewRoute extends PageRouteInfo<ReviewRouteArgs> {
  ReviewRoute({
    Key? key,
    required String entityType,
    required String entityId,
    required String entityName,
    List<PageRouteInfo>? children,
  }) : super(
         ReviewRoute.name,
         args: ReviewRouteArgs(
           key: key,
           entityType: entityType,
           entityId: entityId,
           entityName: entityName,
         ),
         initialChildren: children,
       );

  static const String name = 'ReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReviewRouteArgs>();
      return ReviewScreen(
        key: args.key,
        entityType: args.entityType,
        entityId: args.entityId,
        entityName: args.entityName,
      );
    },
  );
}

class ReviewRouteArgs {
  const ReviewRouteArgs({
    this.key,
    required this.entityType,
    required this.entityId,
    required this.entityName,
  });

  final Key? key;

  final String entityType;

  final String entityId;

  final String entityName;

  @override
  String toString() {
    return 'ReviewRouteArgs{key: $key, entityType: $entityType, entityId: $entityId, entityName: $entityName}';
  }
}

/// generated route for
/// [RoleSelectionScreen]
class RoleSelectionRoute extends PageRouteInfo<void> {
  const RoleSelectionRoute({List<PageRouteInfo>? children})
    : super(RoleSelectionRoute.name, initialChildren: children);

  static const String name = 'RoleSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RoleSelectionScreen();
    },
  );
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [VendorDetailScreen]
class VendorDetailRoute extends PageRouteInfo<VendorDetailRouteArgs> {
  VendorDetailRoute({
    Key? key,
    required String vendorId,
    List<PageRouteInfo>? children,
  }) : super(
         VendorDetailRoute.name,
         args: VendorDetailRouteArgs(key: key, vendorId: vendorId),
         initialChildren: children,
       );

  static const String name = 'VendorDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VendorDetailRouteArgs>();
      return VendorDetailScreen(key: args.key, vendorId: args.vendorId);
    },
  );
}

class VendorDetailRouteArgs {
  const VendorDetailRouteArgs({this.key, required this.vendorId});

  final Key? key;

  final String vendorId;

  @override
  String toString() {
    return 'VendorDetailRouteArgs{key: $key, vendorId: $vendorId}';
  }
}

/// generated route for
/// [VendorListingScreen]
class VendorListingRoute extends PageRouteInfo<VendorListingRouteArgs> {
  VendorListingRoute({
    Key? key,
    String? categoryId,
    List<PageRouteInfo>? children,
  }) : super(
         VendorListingRoute.name,
         args: VendorListingRouteArgs(key: key, categoryId: categoryId),
         initialChildren: children,
       );

  static const String name = 'VendorListingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VendorListingRouteArgs>(
        orElse: () => const VendorListingRouteArgs(),
      );
      return VendorListingScreen(key: args.key, categoryId: args.categoryId);
    },
  );
}

class VendorListingRouteArgs {
  const VendorListingRouteArgs({this.key, this.categoryId});

  final Key? key;

  final String? categoryId;

  @override
  String toString() {
    return 'VendorListingRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [VerifyPage]
class VerifyRoute extends PageRouteInfo<void> {
  const VerifyRoute({List<PageRouteInfo>? children})
    : super(VerifyRoute.name, initialChildren: children);

  static const String name = 'VerifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VerifyPage();
    },
  );
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeScreen();
    },
  );
}
