import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:citame/firebase_options.dart';
import 'package:citame/models/business_model.dart';
import 'package:citame/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String serverUrl = 'https://ubuntu.citame.store';
FirebaseAuth auth = FirebaseAuth.instance;

abstract class API {
  static Future<String> postUser(String googleId, String? userName,
      String? emailUser, String? avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('googleId') == null ||
        prefs.getString('googleId') != googleId) {
      prefs.setString('googleId', googleId);
    }
    if (prefs.getString('userName') == null ||
        prefs.getString('userName') != userName) {
      prefs.setString('userName', userName!);
    }
    if (prefs.getString('emailUser') == null ||
        prefs.getString('emailUser') != emailUser) {
      prefs.setString('emailUser', emailUser!);
    }
    if (prefs.getString('avatar') == null ||
        prefs.getString('avatar') != avatar) {
      prefs.setString('avatar', avatar!);
    }
    final response = await http.post(Uri.parse('$serverUrl/api/user/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'googleId': googleId,
          'userName': userName,
          'emailUser': emailUser,
          'avatar': avatar,
        }));
    if (response.statusCode == 201) return 'Todo ok';
    if (response.statusCode == 202) return 'Todo ok';
    throw Exception('Failed to add item');
  }

  static Future<List<Business>> getOwnerBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await verifyOwnerBusiness();
    var estado = prefs.getString('ownerBusinessStatus');
    var email = prefs.getString('emailUser');
    final response = await http.get(
        Uri.parse('$serverUrl/api/business/get/owner'),
        headers: {'email': email!, 'estado': estado!});
    if (response.statusCode == 200) {
      final List<dynamic> businessList = jsonDecode(response.body);
      final List<Business> businesses = businessList.map((business) {
        Business negocio = Business.fromJson(business);
        return negocio;
      }).toList();
      return businesses;
    }
    if (response.statusCode == 201) {
      List<Business> vacia = [];
      return vacia;
    }
    throw Exception('Failed to get items');
  }

  static Future<void> verifyOwnerBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('ownerBusiness') == null) {
      prefs.setStringList('ownerBusiness', []);
    }
    var nombres = prefs.getStringList('ownerBusiness');
    var email = prefs.getString('emailUser');
    final response = await http.post(
        Uri.parse('$serverUrl/api/business/verify/owner/business'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "businessName": nombres,
          "email": email,
        }));
    if (response.statusCode == 200) prefs.setString('ownerBusinessStatus', '1');
    if (response.statusCode == 201) prefs.setString('ownerBusinessStatus', '0');
    throw Exception('Failed to get items');
  }

  static Future<List<Business>> getAllBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('emailUser');

    final response = await http.get(
      Uri.parse('$serverUrl/api/business/get/all'),
      headers: {
        'email': email!,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> businessList = jsonDecode(response.body);
      final List<Business> businesses = businessList.map((business) {
        Business negocio = Business.fromJson(business);
        return negocio;
      }).toList();

      return businesses;
    }

    throw Exception('Failed to get items');
  }

  static Future<Usuario> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse('$serverUrl/api/user/get'),
        headers: {'googleId': prefs.getString('googleId')!});
    if (response.statusCode == 200) {
      final Usuario usuario = Usuario(
          googleId: prefs.getString('googleId')!,
          userName: prefs.getString('userName')!,
          userEmail: prefs.getString('emailUser')!,
          avatar: prefs.getString('avatar')!);
      return usuario;
    }
    throw Exception('Failed to get items');
  }

  static Future<String> postBusiness(
    String businessName,
    String? category,
    String? email,
    //String? createdBy,
    List<String> workers,
    String? contactNumber,
    String? direction,
    String? latitude,
    String? longitude,
    String? description,
    String imgPath,
  ) async {
    String imgConv = await API.convertTo64(imgPath);
    Uint8List casi = API.decode64(imgConv);
    List<int> imagen = casi.toList();
    final response =
        await http.post(Uri.parse('$serverUrl/api/business/create'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "businessName": businessName,
              "category": category,
              "email": email,
              //"createdBy": createdBy,
              "workers": workers,
              "contactNumber": contactNumber,
              "direction": direction,
              "latitude": latitude,
              "longitude": longitude,
              "description": description,
              "imgPath": imagen,
            }));
    if (response.statusCode == 201) return "Negocio creado";
    if (response.statusCode == 202) return "El negocio ya existe";
    throw Exception('Failed to add item');
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId: (DefaultFirebaseOptions.currentPlatform ==
                    DefaultFirebaseOptions.ios)
                ? DefaultFirebaseOptions.currentPlatform.iosClientId
                : DefaultFirebaseOptions.currentPlatform.androidClientId)
        .signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<String> convertTo64(String imagepath) async {
    File imagefile = File(imagepath); //convert Path to File
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string
    print(base64string);
    return base64string;
  }

  static Uint8List decode64(String base64string) {
    Uint8List decodedbytes = base64.decode(base64string);
    return decodedbytes;
  }

  static var estiloJ24negro = GoogleFonts.plusJakartaSans(
      color: Color(0xFF14181B), fontSize: 24, fontWeight: FontWeight.w500);
  static var estiloJ14negro = GoogleFonts.plusJakartaSans(
      color: Color(0xFF15161E), fontSize: 14, fontWeight: FontWeight.w500);
  static var estiloJ14gris = GoogleFonts.plusJakartaSans(
      color: Color.fromRGBO(96, 106, 133, 1),
      fontSize: 14,
      fontWeight: FontWeight.w500);
  static var estiloJ16negro = GoogleFonts.plusJakartaSans(
      color: Color(0xFF14181B), fontSize: 16, fontWeight: FontWeight.normal);
}