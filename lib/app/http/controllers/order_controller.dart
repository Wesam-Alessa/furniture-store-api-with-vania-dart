import 'package:afshak_api/app/models/order.dart';
import 'package:afshak_api/app/models/order_details.dart';
import 'package:afshak_api/app/models/product_model.dart';
import 'package:decimal/decimal.dart';
import 'package:stripe/stripe.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  placeOrder(Request request) async {
    try {
      final userId = Auth().id();
      final data = request.input("order");

      if (data == null) {
        return Response.json(
            {"code": 401, "data": "", "message": "you are not authurized"},
            401);
      }
      final cartList = data;
      var dataList = <ProductModel>[];

      for (var e in cartList) {
        dataList.add(ProductModel.fromMap(e));
      }

      final orderNum = DateTime.now().millisecondsSinceEpoch;
      double amountTotal = 0;

      List<LineItem> lineItems = [];
      for (var element in dataList) {
        // final e = dataList.elementAt(i);
        final price = Decimal.parse(element.price!);
        //25.33
        var priceD = price.floor(scale: 2).toDouble();
        //2533
        final priceI = (priceD * 100).toInt();
        //keep for ourself in the database
        final amountSum = priceD * element.cartNumber!;
        // total amount for all the items in the cart
        amountTotal = amountTotal + amountSum;
        lineItems.add(LineItem(
            priceData: PriceData(
                currency: "usd",
                productData: ProductData(name: "${element.title}"),
                unitAmount: priceI),
            quantity: element.cartNumber));
        await OrderDetails().query().insert({
          "user_id": userId,
          "amount": amountSum,
          "product_id": element.id,
          "order_num": orderNum,
          "title": element.title,
          "price": element.price,
          "num": element.cartNumber,
          "pic": element.thumbnail,
          "created_at": DateTime.now(),
          "updated_at": DateTime.now(),
        });
      }
      await Order().query().insert({
        "user_id": userId,
        "amount_total": amountTotal.toString(),
        "order_num": orderNum,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });
      final String apikey =
          "sk_test_51M7HNIBpV0PP6LwmOdGDGOepOXyHLdHoUOPm3X6R8AgUS2MzxY6wAue8as3EVu5ysMZg5rFcusacpxOFaxTXgEY900CwTw8xMB";
      final stripe = Stripe(apikey);
      final checkoutData = CreateCheckoutSessionRequest(
          successUrl: env('APP_URL') + '/success.html',
          cancelUrl: env('APP_URL') + '/cancel.html',
          paymentMethodTypes: [PaymentMethodType.card],
          clientReferenceId: "$orderNum",
          mode: SessionMode.payment,
          lineItems: lineItems);
      final checkoutSession = await stripe.checkoutSession.create(checkoutData);
      return Response.json({
        "code": 200,
        "data": checkoutSession.id,
        "message": "payment success"
      });
    } catch (e) {
      return Response.json({
        "code": 500,
        "data": e.toString(),
        "message": "server side error during placing order"
      }, 500);
    }
  }

  Future<Response> webhook(Request request) async {
    final event = request.all();
    if (event['type'] == 'checkout.session.completed') {
      final session = event['data']['object'];
      final orderId = session['metedata']['order_id'];
      Order().query().where("order_num", orderId).update({"status": 1});
      //return Response.json("Payment success");
    }
    //return Response.json("Unknown events");
    return Response.json("Event received");
  }

  Future<Response> getOrderList(Request request) async {
    final userId = Auth().id();
    final status = request.input('status');
    if (status == "canceled") {
      final orderList = await Order()
          .query()
          .where('user_id', "=", userId)
          .where('status', "=", 3)
          .get();
      return Response.json({
        "code": 200,
        "data": orderList,
        "msg": "Success returning the cancel order list"
      }, 200);
    } else if (status == "delivered") {
      final orderList = await Order()
          .query()
          .where('user_id', "=", userId)
          .where('status', "=", 2)
          .get();
      return Response.json({
        "code": 200,
        "data": orderList,
        "msg": "Success returning the delivered order list"
      }, 200);
    } else if (status == "paid") {
      final orderList = await Order()
          .query()
          .where('user_id', "=", userId)
          .where('status', "=", 1)
          .get();
      return Response.json({
        "code": 200,
        "data": orderList,
        "msg": "Success returning the paid order list"
      }, 200);
    } else if (status == "all") {
      final orderList =
          await Order().query().where('user_id', "=", userId).get();
      return Response.json({
        "code": 200,
        "data": orderList,
        "msg": "Success returning the order list"
      }, 200);
    } else {
      return Response.json(
          {"code": 403, "data": [], "msg": "No matching found"}, 403);
    }
  }

  Future<Response> getOrderDetail(Request request) async {
    final userId = Auth().id();
    final orderNum = request.input('orderNum');
    try {
      final detail = await OrderDetails()
          .query()
          .where('user_id', "=", userId)
          .where('order_num', "=", orderNum)
          .get();
      return Response.json(
          {"code": 200, "data": detail, "msg": "Got the order detail"}, 200);
    } catch (e) {
      return Response.json(
          {"code": 500, "data": "", "msg": "Could not fetch the order detail"},
          500);
    }
  }
}

final OrderController orderController = OrderController();
