import 'package:afshak_api/app/http/controllers/auth_controller.dart';
import 'package:afshak_api/app/http/controllers/home_controller.dart';
import 'package:afshak_api/app/http/controllers/profile_controller.dart';
import 'package:afshak_api/app/http/controllers/order_controller.dart';

import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');
    Router.post("/register", authController.register);
    Router.post("/login", authController.login);
    Router.put("/update_password", authController.updatePassword);
    Router.post("/webhook", orderController.webhook);
    //Router.post("/getproducts", homeController.productList);
    Router.group(() {
      // PRODUCTS
      Router.post("/get_products", homeController.productList);
      Router.post("/get_product_detail", homeController.detail);
      Router.post("/search", homeController.search);
      // WISHLIST
      Router.post("/add_wishlist", profileController.wishlist);
      Router.post("/my_wishlist", profileController.mywishlist);
      //PROFILE
      Router.post("/get_profile", profileController.getProfile);
      Router.post("/edit_profile", profileController.editProfile);
      Router.post("/edit_password", profileController.editPassword);
      //ADDRESS
      Router.post("/get_addresses", profileController.getAddresses);
      Router.post("/add_address", profileController.addAddress);
      //PAYMENT
      Router.post("/place_order", orderController.placeOrder);
      Router.post("/get_order-list", orderController.getOrderList);
      Router.post("/get_order_detail", orderController.getOrderDetail);

    }, middleware: []);
  }
}
//AuthenticateMiddleware()