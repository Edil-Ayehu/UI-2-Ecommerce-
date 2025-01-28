import '../model/order.dart';

class OrderRepository {
  List<Order> getOrders() {
    return [
      Order(
        orderNumber: '12345',
        itemCount: 2,
        totalAmount: 299.99,
        status: OrderStatus.active,
        imageUrl: 'assets/images/shoe.jpg',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Order(
        orderNumber: '12346',
        itemCount: 1,
        totalAmount: 199.99,
        status: OrderStatus.active,
        imageUrl: 'assets/images/laptop.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        orderNumber: '12347',
        itemCount: 3,
        totalAmount: 499.99,
        status: OrderStatus.completed,
        imageUrl: 'assets/images/shoe2.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Order(
        orderNumber: '12348',
        itemCount: 1,
        totalAmount: 149.99,
        status: OrderStatus.cancelled,
        imageUrl: 'assets/images/shoes2.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return getOrders().where((order) => order.status == status).toList();
  }
}
