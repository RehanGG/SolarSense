import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/modules/feasibility_report/state/report_state.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:solarsense/shared/services/app_controller.dart';
import 'dart:io';

import '../../../shared/constants/constants.dart';
import '../../../shared/constants/utilities.dart';

extension MonthNameExtension on int {
  String get getMonth {
    if (this == 1) return 'January';
    if (this == 2) return 'February';
    if (this == 3) return 'March';
    if (this == 4) return 'April';
    if (this == 5) return 'May';
    if (this == 6) return 'June';
    if (this == 7) return 'July';
    if (this == 8) return 'August';
    if (this == 9) return 'September';
    if (this == 10) return 'October';
    if (this == 11) return 'November';
    if (this == 12) return 'December';
    return 'Invalid';
  }
}

class ReportController extends GetxController {
  final ReportState state = ReportState();

  static const int daysToAdd = 365;

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
        state.installationDate.value!.add(const Duration(days: daysToAdd));
    return 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${state.selectedLocation.value!.latitude},${state.selectedLocation.value!.longitude}/${currentDate.year}-${currentDate.month}-${currentDate.day}/${newDate.year}-${newDate.month}-${newDate.day}?unitGroup=metric&include=days&key=VDCDUVC5DVUM7T9R5V6J846FT&contentType=json';
  }

  void getWeatherData() async {
    String apiUrl = generateApiUrl();
    if (state.isChanged) {
      final res = await http.get(Uri.parse(apiUrl));
      state.weatherData = jsonDecode(res.body);
    }
    state.currentStep.value = 3;
    getPrediction();
  }

  void getPrediction() async {
    if (state.isChanged) {
      final res = await http.post(
          Uri.parse("http://23.88.118.205:5000/predict"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"data": state.weatherData['days']}));
      state.modelData = jsonDecode(res.body);
    }
    state.currentStep.value = 4;
    saveInFirebase();
    generatePdf();
  }

  void saveInFirebase() {
    if (state.isChanged) {
      state.isChanged = false;

      final DateTime nowDate = DateTime.now().toLocal();
      DateTime currentDate = state.installationDate.value!;
      DateTime newDate =
          state.installationDate.value!.add(const Duration(days: daysToAdd));

      FirebaseFirestore.instance.collection(FirestoreConstants.REPORT).add({
        'weatherData': state.weatherData,
        'predictions': state.modelData['predictions'],
        'userId': AppController.to.state.appUser.value!.userId,
        'installationCost': state.installationPrice.value.text,
        'installationDate':
            "${state.installationDate.value!.year}-${state.installationDate.value!.month}-${state.installationDate.value!.day}",
        'electricityCost': state.electricityCost.value.text,
        'panelCapacity': state.panelCapacity.value.text,
        'date': '${nowDate.year}-${nowDate.month}-${nowDate.day}',
        'timeframe':
            '${currentDate.year}-${currentDate.month} to ${newDate.year}-${newDate.month}',
        'locationName': state.locationName.value!,
      });
    }
  }

  static List<List<String>> filterData(List weatherData, List energyProduced) {
    List<List<String>> filteredData = [];

    Map<int, Map<String, dynamic>> monthlySums = {};

    for (int i = 0; i < weatherData.length; i++) {
      String datetime = weatherData[i]['datetime'];
      double prediction = energyProduced[i];
      int month = DateFormat('yyyy-MM-dd').parse(datetime).month;
      int year = DateFormat('yyyy-MM-dd').parse(datetime).year;

      if (monthlySums.containsKey(month)) {
        monthlySums[month]!['data'] = monthlySums[month]!['data'] + prediction;
      } else {
        monthlySums[month] = {'year': year, 'data': prediction};
      }
    }

    for (int month in monthlySums.keys) {
      filteredData.add([
        monthlySums[month]!['year'].toString(),
        month.getMonth,
        '${monthlySums[month]!['data'].toStringAsFixed(2)} kWh'
      ]);
    }

    return filteredData;
  }

  static pw.Column createTable(List header, List<List> data, String heading) {
    final pw.Container headingContainer = pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8.0),
        color: PdfColors.amber,
        child: pw.Text(heading,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            )));

    final table = pw.TableHelper.fromTextArray(
      cellHeight: 30,
      headerHeight: 40,
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.grey100,
      ),
      border: null,
      headers: header,
      data: data,
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey,
            width: .5,
          ),
        ),
      ),
    );
    return pw.Column(children: [
      headingContainer,
      pw.SizedBox(height: 30.0),
      table,
    ]);
  }

  void generatePdf() async {
    final pdf = pw.Document();

    final theme = pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      italic: await PdfGoogleFonts.openSansItalic(),
    );

    final ByteData bytes = await rootBundle.load('assets/icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    final image = pw.MemoryImage(imageData);

    final List weatherData = state.weatherData['days'];
    final List predictionData = state.modelData['predictions'];
    final filteredWeatherData = filterData(weatherData, predictionData);

    final double annualSavings = predictionData.reduce((a, b) => a + b) *
        double.parse(state.electricityCost.text);
    final double roi =
        annualSavings / double.parse(state.installationPrice.text);
    final double paybackPeriod =
        double.parse(state.installationPrice.text) / annualSavings;

    final pw.Container header = pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(10.0),
        color: PdfColor.fromHex('0b004d'),
        child: pw.Text('Feasibility Report',
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 20,
              color: PdfColors.white,
            )));

    final DateTime nowDate = DateTime.now().toLocal();
    DateTime currentDate = state.installationDate.value!;
    DateTime newDate =
        state.installationDate.value!.add(const Duration(days: daysToAdd));

    final pw.Column userInfo =
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('Report Generated by',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Text(AppController.to.state.appUser.value!.fullName,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
      pw.Text(AppController.to.state.appUser.value!.email,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
      pw.Text(state.locationName.value!,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
      pw.SizedBox(height: 7),
      pw.Text('Date: ${nowDate.year}-${nowDate.month}-${nowDate.day}',
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.normal,
              fontStyle: pw.FontStyle.italic)),
      pw.Text(
          'Timeframe: ${currentDate.year}-${currentDate.month} to ${newDate.year}-${newDate.month}',
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.normal,
              fontStyle: pw.FontStyle.italic)),
    ]);

    final pw.Row userInfoRow =
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      userInfo,
      pw.Image(image, width: 85, height: 85),
    ]);

    final pw.Column solarInfoTable = createTable([
      'Description',
      'Info'
    ], [
      ['Installation Cost', "Rs ${state.installationPrice.value.text}"],
      [
        'Installation Date',
        "${state.installationDate.value!.year}-${state.installationDate.value!.month}-${state.installationDate.value!.day}"
      ],
      ['Electricity Price (kWh)', "Rs ${state.electricityCost.value.text} kWh"],
      ['Panel Capacity', "${state.panelCapacity.value.text} kWh"]
    ], 'Solar Panel Information');

    final pw.Column energyTable = createTable(
        ['Year', 'Month', 'Energy Produced'],
        filteredWeatherData,
        'Energy Production (Prediction)');

    final pw.Column analysisTable = createTable([
      'Description',
      'Info'
    ], [
      ['Annual Savings', "Rs ${annualSavings.toStringAsFixed(2)}"],
      ['ROI', roi.toStringAsFixed(2)],
      ['Payback Period', "${paybackPeriod.toStringAsFixed(2)} years"]
    ], 'Analysis');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (context) => [
          header,
          pw.SizedBox(height: 50),
          userInfoRow,
          pw.SizedBox(height: 80),
          solarInfoTable,
          pw.SizedBox(height: 60),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (context) =>
            [energyTable, pw.SizedBox(height: 60), analysisTable],
      ),
    );

    final directory = await getTemporaryDirectory();

    final file = File(
        "${directory.path}/${currentDate.year}${currentDate.month}-${newDate.year}${newDate.month}-FeasibilityReport.pdf");
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

  @override
  void onInit() {
    ever(state.installationDate, (value) => state.isChanged = true);
    ever(state.selectedLocation, (value) => state.isChanged = true);
    super.onInit();
  }
}
