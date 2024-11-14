// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

//import "package:vania/src/cryptographic/hash.dart" as hash;
import 'package:afshak_api/app/models/user.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {
  Future<Response> register(Request request) async {
    try {
      request.validate({
        'name': 'required|string|alpha',
        'email': 'required|email',
        'password': 'required|string',
      }, {
        'name.required': 'Name is required',
        'name.string': 'Name must be a string',
        'name.alpha': 'Name must contain only alphabetic characters',
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password.required': 'password is required',
        'password.string': 'Password must be a string',
      });
    } catch (e) {
      if (e is ValidationException) {
        var erm = e.message.values.toList();

        return Response.json({
          'msg': erm.isNotEmpty ? erm[0] : 'Validation Error',
          'code': 401,
          "data": ""
        }, 401);
      } else {
        return Response.json(
            {'msg': "unexpected server side error", 'code': 500, "data": ""},
            500);
      }
    }
    try {
      final name = request.input('name');
      final email = request.input('email');
      var password = request.input('password');
      var user = await User().query().where('email', '=', email).first();
      if (user != null) {
        return Response.json(
            {'msg': "Email already exist", 'code': 409, "data": ""}, 409);
      }
      password = Hash().make(password.toString());
      await User().query().insert({
        "name": name,
        "email": email,
        "password": password,
        "avatar": "images/01.png",
        "description": "no user content found",
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });

      return Response.json(
          {'code': 200, 'msg': 'Register success', 'data': ''}, 200);
    } catch (e) {
      return Response.json({
        'msg': "An unexpected server side error during data insert",
        'code': 500,
        "data": ""
      }, 500);
    }
  }

  Future<Response> login(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|string',
      }, {
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password.required': 'password is required',
        'password.string': 'Password must be a string',
      });
    } catch (e) {
      if (e is ValidationException) {
        var erm = e.message.values.toList();
        return Response.json({
          'msg': erm.isNotEmpty ? erm[0] : 'Validation Error',
          'code': 401,
          "data": ""
        }, 401);
      } else {
        return Response.json(
            {'msg': "unexpected server side error", 'code': 500, "data": ""},
            500);
      }
    }
    try {
      final email = request.input('email');
      var password = request.input('password');
      var user = await User().query().where('email', '=', email).first();
      if (user == null) {
        return Response.json(
            {'msg': "User not found", 'code': 404, "data": ""}, 404);
      }
      if (!Hash().verify(password.toString(), user["password"])) {
        return Response.json(
            {'msg': "Your email or password is wrong", 'code': 401, "data": ""},
            401);
      }
      
      final auth = Auth().login(user);
      final token = await auth.createToken(expiresIn: Duration(days: 30));
      String accesstoken = token['access_token'];
      // print(auth.user());
      return Response.json(
          {'code': 200, 'msg': 'Login success', 'data': accesstoken}, 200);
    } catch (e) {
      return Response.json({
        'msg': "An unexpected server side error during data insert",
        'code': 500,
        "data": ""
      }, 500);
    }
  }

  Future<Response> updatePassword(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|string',
      }, {
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password.required': 'password is required',
        'password.string': 'Password must be a string',
      });
    } catch (e) {
      if (e is ValidationException) {
        var erm = e.message.values.toList();
        return Response.json({
          'msg': erm.isNotEmpty ? erm[0] : 'Validation Error',
          'code': 401,
          "data": ""
        }, 401);
      } else {
        return Response.json(
            {'msg': "unexpected server side error", 'code': 500, "data": ""},
            500);
      }
    }
    try {
      final email = request.input('email');
      var password = request.input('password');
      var user = await User().query().where('email', '=', email).first();
      if (user == null) {
        return Response.json(
            {'msg': "User not found", 'code': 404, "data": ""}, 404);
      }
      // if (!Hash().verify(password.toString(), user["password"])) {
      //   return Response.json(
      //       {'msg': "Your email or password is wrong", 'code': 401, "data": ""},
      //       401);
      // }
      // final auth = Auth().login(user);
      // final token = await auth.createToken(expiresIn: Duration(days: 30));
      // String accesstoken = token['access_token'];
      await User().query().where('email', '=', email).update({
        'password': Hash().make(password.toString()),
      });
      return Response.json(
          {'code': 200, 'msg': 'Update success', 'data': ''}, 200);
    } catch (e) {
      return Response.json({
        'msg': "An unexpected server side error during data insert",
        'code': 500,
        "data": ""
      }, 500);
    }
  }
}

final AuthController authController = AuthController();
