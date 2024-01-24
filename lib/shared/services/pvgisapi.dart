import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class PVGsAPI {
  String urlToRead;
  bool pv;
  late List<FlSpot> data;
  late double peak;
  late double mediaTot;
  late List<int> value;

  PVGsAPI({
    required this.urlToRead,
    required this.pv,
  });

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(urlToRead));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        processData(json);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void processData(Map<String, dynamic> jsonData) {
    value = [
      jsonData['inputs']['mounting_system']['fixed']['slope']['value'] as int,
      jsonData['inputs']['mounting_system']['fixed']['azimuth']['value'] as int,
    ];

    final listaIrradianza = jsonData['outputs']['hourly'] as List<dynamic>;

    final dati = <double>[];
    var numeroDays = 1;
    var media = 0.0;
    var mediaTot = 0.0;
    var max = 0.0;

    for (var i = 0; i < listaIrradianza.length && numeroDays <= 365; i++) {
      if ((i + 1) % 24 == 0) {
        media = media / 24;
        mediaTot += media;
        if (media > max) max = media;
        dati.add(media);
        numeroDays++;
        media = 0;
      } else {
        final n = listaIrradianza[i] as Map<String, dynamic>;
        final irradianza = n[(!pv) ? 'G(i)' : 'P'] as double;
        if (irradianza > 0) {
          media = media + irradianza;
        }
      }
    }

    mediaTot = mediaTot / 365;

    if (pv) {
      peak = max;
      mediaTot = mediaTot;
    }

    data = dati
        .asMap()
        .map(
          (index, value) => MapEntry(
            index,
            FlSpot((index + 1).toDouble(), value),
          ),
        )
        .values
        .toList();
  }
}
