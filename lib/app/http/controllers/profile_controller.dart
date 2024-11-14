import 'package:afshak_api/app/models/user.dart';
import 'package:afshak_api/app/models/addresses.dart';
import 'package:afshak_api/app/models/wishlist.dart';
import 'package:vania/vania.dart';

class ProfileController extends Controller {
  Future<Response> wishlist(Request request) async {
    try {
      final id = request.input("id");
      if (id == null) {
        return Response.json(
            {"code": 401, "data": "", "message": "Not Authorized"}, 401);
      }
      final userId = Auth().id();
      final wishlist = await Wishlist()
          .query()
          .where("user_id", "=", userId)
          .where("product_id", "=", id)
          .first();

      if (wishlist != null) {
        // cancel wishlist
        await Wishlist()
            .query()
            .where("product_id", "=", id)
            .where("user_id", "=", userId)
            .delete();
        return Response.json({
          "code": 200,
          "data": "",
          "message": "Wishlist canceled for this product"
        }, 200);
      }
      await Wishlist().query().insert({
        "user_id": userId,
        "product_id": id,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });

      return Response.json({
        "code": 200,
        "data": "",
        "message": "Wishlist added for this product"
      }, 200);
    } catch (e) {
      return Response.json({
        "code": 500,
        "data": "",
        "message": "Somthing wrong went with the wishlist"
      }, 500);
    }
  }

  Future<Response> mywishlist(Request request) async {
    try {
      final userId = Auth().id();
      //final userId = Auth().get("id");
      final wishlist = await Wishlist()
          .query()
          .join("products", "products.id", "=", "wishlists.product_id")
          .select(["products.*"])
          .where("wishlists.user_id", "=", userId)
          .get();
      return Response.json(
          {"code": 200, "data": wishlist, "message": "returned a wishlist"},
          200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "could not return a wishlist"},
          500);
    }
  }

  Future<Response> getProfile(Request request) async {
    try {
      final userId = Auth().id();
      final user = await User().query().where("id", "=", userId).first();
      return Response.json(
          {"code": 200, "data": user, "message": "Returned user"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "Server error"}, 500);
    }
  }

  Future<Response> editProfile(Request request) async {
    try {
      final userId = Auth().id();
      final name = request.input("name");
      final birthday = request.input("birthday");
      final gender = request.input("gender");
      final phone = request.input("phone");
      final description = request.input("description");
      await User().query().where("id", "=", userId).update({
        "name": name,
        "birthday": birthday,
        "gender": gender,
        "phone": phone,
        "description": description,
      });
      return Response.json(
          {"code": 200, "data": "", "message": "Update Success"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "Server error"}, 500);
    }
  }

  Future<Response> editPassword(Request request) async {
    try {
      final userId = Auth().id();
      var password = request.input("password");
      final repassword = request.input("repassword");
      if (password != repassword) {
        return Response.json(
            {"code": 400, "data": "", "message": "Invalid Password"}, 400);
      }
      password = Hash().make(password.toString());
      await User().query().where("id", "=", userId).update({
        "password": password,
      });
      return Response.json(
          {"code": 200, "data": "", "message": "Update Success"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "Server error"}, 500);
    }
  }

  Future<Response> getAddresses(Request request) async {
    try {
      final userId = Auth().id();
      final userAddresses = await Addresses().query().where("id", "=", userId).get();
      return Response.json(
          {"code": 200, "data": userAddresses, "message": "Returned user addresses"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "Server error"}, 500);
    }
  }

Future<Response> addAddress(Request request) async {
    try {
      final userId = Auth().id();
      final name = request.input("name");
      final phone = request.input("phone");
      final country = request.input("country");
      final city = request.input("city");
      final state = request.input("state");
      final zipcode = request.input("zipcode");
      final detail = request.input("detail");
      await Addresses().query().insert({
        "user_id": userId,
        "name": name,
        "phone": phone,
        "country": country,
        "city": city,
        "state": state,
        "zipcode": zipcode,
        "detail": detail,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });
      return Response.json(
          {"code": 200, "data": "", "message": "Add Success"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "message": "Server error"}, 500);
    }
  }


}

final ProfileController profileController = ProfileController();
