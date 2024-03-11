import 'package:dio/dio.dart';
import 'package:rollcallapp/common/props.dart';
import 'package:rollcallapp/common/request.body.dart';

class HttpService{

  Future<Response>? restService(RequestBody reqBody){
    if(reqBody.type == 'POST'){
      return this.postMethod(reqBody);
    }
    else if(reqBody.type == 'GET'){
      return this.getMethod(reqBody);
    }    
    else{
      return null;
    }    
  } 

  Future<Response> postMethod(RequestBody reqBody) async{
    Dio dio = new Dio();
    String? _url = reqBody.url;
    if(!reqBody.isEndPointIncluded){
      _url = Prop.apiUrl + reqBody.url!;
    }
    print(_url);
    Response response = await dio.post(_url!,data: reqBody.reqData);
    return response;
  }  

  Future<Response> getMethod(RequestBody reqBody) async{
    Dio dio = new Dio();
    String? _url = reqBody.url;
    if(!reqBody.isEndPointIncluded){
      _url = Prop.apiUrl + reqBody.url!;
    }     
    Response response = await dio.get(_url!);
    return response;
  }
  
}