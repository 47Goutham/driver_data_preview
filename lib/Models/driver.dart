import 'package:driver_data_preview/Models/order.dart';
import 'package:flutter/services.dart';

class Driver {
  final String name;
  final String id;
  final String phone;
  String? photoPath;

  double? handCash;
  double? distance;
  double? workingHours;
  List<Order>? orders;

     Driver({required this.name,required this.id,required this.phone}) ;

  Future<void> assignPhotoPath() async {
    photoPath = await _doesImageAssetExist('assets/images/$id.jpeg') ? 'assets/images/$id.jpeg' : (await _doesImageAssetExist('assets/images/$id.jpg') ? 'assets/images/$id.jpg': null) ;

  }

  Future<bool> _doesImageAssetExist(String assetPath) async {
    try {
      // Attempt to load the asset using rootBundle
      final ByteData data = await rootBundle.load(assetPath);

      // If the asset exists and was loaded successfully, return true
      return data != null && data.lengthInBytes != 0;
    } catch (e) {
      // Handle any errors that occur during asset loading
      return false;
    }
  }

}

