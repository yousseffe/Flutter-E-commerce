import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  updateOrder() async{
    try{
      if(orderForUpdate != null){
        Map<String , dynamic> order = {'trackingUrl': trackingUrlCtrl, 'orderStatus': selectedOrderStatus};
        final response = await service.updateItem(endpointUrl: 'orders', itemId: orderForUpdate?.sId ?? '', itemData: order);
        if(response.isOk){
          ApiResponse apiresponse = ApiResponse.fromJson(response.body, null);
          if(apiresponse.success){
            SnackBarHelper.showSuccessSnackBar(apiresponse.message);
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar(apiresponse.message);
          }
        } else{
          SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch(e){
      print(e);
      SnackBarHelper.showErrorSnackBar('$e');
      rethrow;
    }
  }


  deleteOrder(Order order) async{
    try{
      Response response = await service.deleteItem(endpointUrl: 'orders', itemId: order.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success){
          SnackBarHelper.showSuccessSnackBar('order deleted successfully ');
        }
      } else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch(e){
      print(e);
      rethrow;
    }
  }


  updateUI() {
    notifyListeners();
  }
}
