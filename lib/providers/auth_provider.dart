import 'package:admin_dashboard/models/http/auth_response.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/api/CafeApi.dart';
import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated
}

class AuthProvider extends ChangeNotifier {

  String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  Usuario? user;


  AuthProvider() {
    this.isAuthenticated();
  }


  login( String email, String password ) {

    final data = {
      'correo'   : email,
      'password' : password,
    };

    CafeApi.post('/auth/login', data).then(
      (json) {
        
        print(json);
        final authResponse = AuthResponse.fromMap(json);
        this.user = authResponse.usuario;

        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token',authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);
        notifyListeners();

      }
    ).catchError((e){
      
      print('error en: $e');
      NotificationsServices.showSnackbarError('Usiario/Password incorrectos');

    });

    //
  }

  register( String email, String password, String name ) {

    final data = {
      'nombre'   : name,
      'correo'   : email,
      'password' : password,
    }; 


    CafeApi.post('/usuarios', data).then(
      (json) {
        print(json);
        
        final authResponse = AuthResponse.fromMap(json);
        this.user = authResponse.usuario;

        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);
        notifyListeners();

      }

    ).catchError((e){
      print('error en: $e');
      NotificationsServices.showSnackbarError('Usiario/Password no validos');
    });
    
    
  }


  Future<bool> isAuthenticated() async {

    final token = LocalStorage.prefs.getString('token');

    if( token == null ) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    // TODO: ir al backend y comprobar si el JWT es válido
    
    await Future.delayed(Duration(milliseconds: 1000 ));
    authStatus = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }


}
