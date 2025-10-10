class OrderDetailsModel {
  final String id;
  final String customerName;
  final double orderValue;
  final String date;
  final String location;
  final String status;
  final List<OrderProduct> products;
  final double subtotal;
  final double tax;
  final double delivery;
  final double total;
  final String paymentMethod;

  const OrderDetailsModel({
    required this.id,
    required this.customerName,
    required this.orderValue,
    required this.date,
    required this.location,
    required this.status,
    required this.products,
    required this.subtotal,
    required this.tax,
    required this.delivery,
    required this.total,
    required this.paymentMethod,
  });
}

class OrderProduct {
  final String name;
  final double price;
  final int quantity;
  final double total;
  final String imageUrl;

  const OrderProduct({
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.imageUrl,
  });
}
