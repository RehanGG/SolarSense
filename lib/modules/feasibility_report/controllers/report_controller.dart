import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/modules/feasibility_report/state/report_state.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:solarsense/shared/services/app_controller.dart';
import 'dart:io';

import '../../../shared/constants/utilities.dart';

class ReportController extends GetxController {
  final ReportState state = ReportState();

  final int daysToAdd = 365;

  void validateData() {
    if (state.installationPrice.text.isEmpty) {
      throw const FieldException(
          'Enter Installation cost', 'Installation Cost');
    }
    if (state.electricityCost.text.isEmpty) {
      throw const FieldException('Enter Electricity cost', 'Electricity Cost');
    }
    if (state.panelCapacity.text.isEmpty) {
      throw const FieldException('Enter Panel capacity', 'Panel Capacity');
    }

    if (state.installationDate.value == null) {
      throw const FieldException(
          'Select Solar Panel Installation Date', 'Installation Date');
    }

    //1
    try {
      int.parse(state.installationPrice.text);
    } catch (e) {
      throw const FieldException(
          'Invalid Installation cost', 'Installation Cost');
    }

    //2
    try {
      int.parse(state.electricityCost.text);
    } catch (e) {
      throw const FieldException(
          'Invalid Electricity cost', 'Electricity Cost');
    }

    //3
    try {
      int.parse(state.panelCapacity.text);
    } catch (e) {
      throw const FieldException('Invalid Panel Capacity', 'Panel Capacity');
    }
  }

  void handleSolarInputData() {
    try {
      validateData();
    } on FieldException catch (e) {
      showGetSnackBar(e.title, e.message);
      rethrow;
    }
  }

  String generateApiUrl() {
    DateTime currentDate = state.installationDate.value!;
    DateTime newDate =
        state.installationDate.value!.add(Duration(days: daysToAdd));
    return 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${state.selectedLocation.value!.latitude},${state.selectedLocation.value!.longitude}/${currentDate.year}-${currentDate.month}-${currentDate.day}/${newDate.year}-${newDate.month}-${newDate.day}?unitGroup=metric&include=days&key=VDCDUVC5DVUM7T9R5V6J846FT&contentType=json';
  }

  void getWeatherData() async {
    String apiUrl = generateApiUrl();
    final res = await http.get(Uri.parse(apiUrl));
    state.weatherData = jsonDecode(res.body);
    state.currentStep.value = 3;
    getPrediction();
  }

  void getPrediction() async {
    final res = await http.post(Uri.parse("http://23.88.118.205:5000/predict"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"data": state.weatherData['days']}));
    state.modelData = jsonDecode(res.body);
    state.currentStep.value = 4;
    generatePdf();
  }

  List<List<String>> filterData(List weatherData, List energyProduced) {
    List<List<String>> filteredData = [];

    for (int i = 0; i < 5; i++) {
      filteredData.add([
        weatherData[i]['datetime'],
        energyProduced[i].toStringAsFixed(2),
      ]);
    }

    for (int i = weatherData.length - 3; i < weatherData.length; i++) {
      filteredData.add([
        weatherData[i]['datetime'],
        energyProduced[i].toStringAsFixed(2),
      ]);
    }

    return filteredData;
  }

  void generatePdf() async {
    final pdf = pw.Document();

    final font = await rootBundle.load("assets/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    final List weatherData = state.weatherData['days'];
    final List predictionData = state.modelData['predictions'];

    final filteredWeatherData = filterData(weatherData, predictionData);

    final double annualSavings = predictionData.reduce((a, b) => a + b) *
        double.parse(state.electricityCost.text);
    final double roi =
        annualSavings / double.parse(state.installationPrice.text);
    final double paybackPeriod =
        double.parse(state.installationPrice.text) / annualSavings;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Solar Panel\nFeasibility Report',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 80),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: pw.Text(
                    'User Information',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Table.fromTextArray(
                  context: context,
                  headers: ['Type', 'Data'],
                  data: [
                    [
                      'User Name',
                      AppController.to.state.appUser.value!.fullName
                    ],
                    ['User Email', AppController.to.state.appUser.value!.email],
                    ['User Location', state.locationName.value!],
                  ],
                  border: pw.TableBorder.all(width: 1.0),
                  headerAlignment: pw.Alignment.centerLeft,
                  cellAlignment: pw.Alignment.centerLeft,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey200),
                  cellPadding: const pw.EdgeInsets.all(5),
                ),
                pw.SizedBox(height: 50),
                //Next table
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: pw.Text(
                    'Solar Information',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Table.fromTextArray(
                  context: context,
                  headers: ['Type', 'Data'],
                  data: [
                    [
                      'Installation Cost',
                      "Rs ${state.installationPrice.value.text}"
                    ],
                    [
                      'Installation Date',
                      "${state.installationDate.value!.year}-${state.installationDate.value!.month}-${state.installationDate.value!.day}"
                    ],
                    [
                      'Electricity Price (kWh)',
                      "Rs ${state.electricityCost.value.text} kWh"
                    ],
                    ['Panel Capacity', "${state.panelCapacity.value.text} kWh"],
                  ],
                  border: pw.TableBorder.all(width: 1.0),
                  headerAlignment: pw.Alignment.centerLeft,
                  cellAlignment: pw.Alignment.centerLeft,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey200),
                  cellPadding: const pw.EdgeInsets.all(5),
                ),
              ]); // Center
        }));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(height: 50),
                  //Next table
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 0.0),
                    child: pw.Text(
                      'Energy Production (Prediction)',
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Table.fromTextArray(
                    context: context,
                    headers: ['Date', 'Energy Produced'],
                    data: filteredWeatherData,
                    border: pw.TableBorder.all(width: 1.0),
                    headerAlignment: pw.Alignment.centerLeft,
                    cellAlignment: pw.Alignment.centerLeft,
                    headerStyle:
                        pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
                    cellStyle: pw.TextStyle(font: ttf),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    cellPadding: const pw.EdgeInsets.all(5),
                  ),
                  pw.SizedBox(height: 50),
                  //Next table
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 0.0),
                    child: pw.Text(
                      'Analysis',
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Table.fromTextArray(
                    context: context,
                    headers: ['Type', 'Data'],
                    data: [
                      [
                        'Annual Savings',
                        "${annualSavings.toStringAsFixed(2)} kWh"
                      ],
                      ['ROI', roi.toStringAsFixed(2)],
                      [
                        'Payback Period',
                        "${paybackPeriod.toStringAsFixed(2)} years"
                      ]
                    ],
                    border: pw.TableBorder.all(width: 1.0),
                    headerAlignment: pw.Alignment.centerLeft,
                    cellAlignment: pw.Alignment.centerLeft,
                    headerStyle:
                        pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
                    cellStyle: const pw.TextStyle(),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    cellPadding: const pw.EdgeInsets.all(5),
                  ),
                ])
          ];
        })); // Page

    DateTime currentDate = state.installationDate.value!;
    DateTime newDate =
        state.installationDate.value!.add(Duration(days: daysToAdd));

    final directory = await getTemporaryDirectory();

    final file = File(
        "${directory.path}/${currentDate.year}-${newDate.year}-FeasibilityReport.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
    state.generatePdf.value = false;
  }

  void onStepContinue() {
    switch (state.currentStep.value) {
      case 0:
        state.currentStep.value = 1;
        break;
      case 1:
        handleSolarInputData();
        state.currentStep.value = 2;
        getWeatherData();
        break;
    }
  }

  void onStepTapped(int step) {
    if (state.currentStep.value == 2 ||
        state.currentStep.value == 3 ||
        step == 2 ||
        step == 3) {
      return;
    }
    if (step < state.currentStep.value) {
      state.currentStep.value = step;
    }
  }

  void getLocation(LatLng selectedLocation) async {
    showLoadingScreen();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.latitude, selectedLocation.longitude);
      final String? country = placemarks[0].country;
      final String? city = placemarks[0].locality;

      if (country == null || city == null) {
        throw Exception();
      }
      state.selectedLocation.value = selectedLocation;
      state.locationName.value = '$city, $country';
      hideLoadingScreen();
    } catch (e) {
      hideLoadingScreen();
      state.selectedLocation.value = null;
      state.locationName.value = null;
      showGetSnackBar('Invalid Location', 'Please select correct location');
    }
  }
}
