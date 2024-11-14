import 'dart:io';
import 'package:vania/vania.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_products_table.dart';
import 'create_wishlists_table.dart';
import 'create_order_table.dart';
import 'create_order_details_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUserTable().up();
		 await CreatePersonalAccessTokensTable().up();
		 await CreateProductsTable().up();
		 await CreateWishlistsTable().up();
		 await CreateOrderTable().up();
		 await CreateOrderDetailsTable().up();
	}

    dropTables() async {
		 await CreateOrderDetailsTable().down();
		 await CreateOrderTable().down();
		 await CreateWishlistsTable().down();
		 await CreateProductsTable().down();
		 await CreatePersonalAccessTokensTable().down();
		 await CreateUserTable().down();
	 }
}
