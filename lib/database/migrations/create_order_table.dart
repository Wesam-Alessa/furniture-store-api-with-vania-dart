import 'package:vania/vania.dart';

class CreateOrderTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('order', () {
      id();
      char('user_id', length: 100);
      char('amount_total', length: 100);
      bigInt('order_num');
      dateTime('created_at');
      dateTime('updated_at');
      
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('order');
  }
}
