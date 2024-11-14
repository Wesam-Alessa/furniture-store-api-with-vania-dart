import 'package:afshak_api/app/models/products.dart';
import 'package:vania/vania.dart';

class HomeController extends Controller {
  Future<Response>productList(Request request) async {
    try{
      final categoryId = request.input('id');
      if (categoryId == -1) {
        final productList = await Products().query().get();
        return Response.json({
          'code': 200,
          'data': productList,
          'message': 'success getting all products'
        },200);
      }

      final specificProductList =
          await Products().query().where("category_id", "=", categoryId).get();
      if(specificProductList.isNotEmpty){
        return Response.json({
        'code': 200,
        'data': specificProductList,
        'message': 'success getting a specific products'
        },200);
      }else{
        return Response.json({
        'code': 204,
        'data': "",
        'message': 'Nothing found in the database'
      },204);
      }
    }
    catch(e){
        return Response.json({
          'code': 500,
          'data': [],
          'message': 'error getting data'
        },500);
    }
  }

  Future<Response>detail(Request request) async {
    try{
      final id = request.input('id');
      if (id == null) {
        return Response.json({
          'code': 401,
          'data': "",
          'message': 'Not Authorized'
        },401);
      }

      final productDetail =
          await Products().query().where("id", "=", id).first();

      if(productDetail!=null){
        return Response.json({
        'code': 200,
        'data': productDetail,
        'message': 'success getting a product detail'
        },200);
      }else{
        return Response.json({
        'code': 204,
        'data': "",
        'message': 'Nothing found in the database'
      },204);
      }
    }
    catch(e){
        return Response.json({
          'code': 500,
          'data': [],
          'message': 'error getting data'
        },500);
    }
  }
  Future<Response>search(Request request) async {
      try{
        final title = request.input('title');
        if (title == null) {
          return Response.json({
            'code': 401,
            'data': "",
            'message': 'Not Authorized'
          },401);
        }
        if(title=="init"){
          final searchDefault =
              await Products().query().limit(5).get();
            return Response.json({
            'code': 200,
            'data': searchDefault,
            'message': 'Default search'
            },200);
        }
        final searchProducts =
              await Products().query().where("title","like","%$title").get();
         return Response.json({
            'code': 200,
            'data': searchProducts,
            'message': 'Custom search'
          },200);
        //   return Response.json({
        //   'code': 204,
        //   'data': "",
        //   'message': 'Nothing found in the database'
        // },204);
        
      }
      catch(e){
          return Response.json({
            'code': 500,
            'data': [],
            'message': 'error getting data'
          },500);
      }
    }

}

final HomeController homeController = HomeController();
