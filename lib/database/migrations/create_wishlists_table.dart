import 'package:vania/vania.dart';

class CreateWishlistsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('wishlists', () {
      id();
      char('user_id', length: 100);
      char('product_id', length: 100);
      dateTime('created_at');
      dateTime('updated_at');
      dateTime('deleted_at');    
      });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('wishlists');
  }
}
