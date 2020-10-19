import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dropd/util/debug.dart';
import 'package:flutter/services.dart';
 
class ConnectivityService {
  Connectivity connectivity = Connectivity();
  
  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();
  // Stream is like a pipe, you add the changes to the pipe, it will come
  // out on the other side.
  // Create the Constructor
 
  ConnectivityService({mounted}) {
    
    initConnectivity(mounted);

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(result);
    });
  }

  // Subscribe to the connectivity changed stream
    // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity(mounted) async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Logger.debug(() => e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return connectionStatusController.add(result);
  }
}