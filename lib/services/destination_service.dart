import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/destination.dart';

class DestinationService {
  static Future<List<Destination>> charger() async {
    final contenu =
        await rootBundle.loadString('assets/data/destinations.json');
    final List<dynamic> liste = jsonDecode(contenu);
    return liste
        .map((e) => Destination.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}