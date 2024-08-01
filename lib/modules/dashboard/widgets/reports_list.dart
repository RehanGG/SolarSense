import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:solarsense/modules/dashboard/widgets/report_tile.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/widgets/loading_indicator.dart';

import '../../../shared/services/app_controller.dart';

class ReportsList extends StatelessWidget {
  const ReportsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreConstants.REPORT)
            .where('userId',
                isEqualTo: AppController.to.state.appUser.value!.userId)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data!.docs;
          if (data.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/found.json',
                    height: 200.h,
                    width: 200.w,
                  ),
                  const Text('No Reports Found!'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ReportTile(
                data: data[index],
              );
            },
          );
        });
  }
}
