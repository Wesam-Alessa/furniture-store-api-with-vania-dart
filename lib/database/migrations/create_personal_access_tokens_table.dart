import 'package:vania/vania.dart';

class CreatePersonalAccessTokensTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('personal_access_tokens', () {
      id();
      char("name", length: 255);
      char("token", length: 64);
      bigInt("tokenable_id");
      timeStamps();
      dateTime("deleted_at");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('personal_access_tokens');
  }
}
