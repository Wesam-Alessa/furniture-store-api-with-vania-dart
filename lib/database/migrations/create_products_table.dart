import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      id();
      char('title', length: 100);
      char('thumbnail', length: 100);
      longText('description');
      float('price',precision:8,scale:2);
      integer('category_id');
      integer('review');
      float('score',precision:8,scale:2);
      dateTime('created_at');
      dateTime('updated_at');
      dateTime('deleted_at');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
