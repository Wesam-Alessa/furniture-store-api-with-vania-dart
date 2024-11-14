import 'package:vania/vania.dart';

class CreateOrderDetailsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('order_details', () {
      id();
      char('user_id', length: 100);
      float('amount', precision: 8, scale: 2);
      integer('product_id');
      char('title', length: 100);
      char('price', length: 100);
      integer('num');
      bigInt('order_num');
      char('pic', length: 100);
      dateTime('created_at');
      dateTime('updated_at');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('order_details');
  }
}
