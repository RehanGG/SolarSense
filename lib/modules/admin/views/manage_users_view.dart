import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/models/user_profile_model.dart';
import 'package:solarsense/shared/constants/utilities.dart';
import 'package:solarsense/shared/services/app_controller.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/app_drawer.dart';

class ManageUsersView extends StatelessWidget {
  const ManageUsersView({Key? key}) : super(key: key);

  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      title: const Text('Manage Users'),
      centerTitle: true,
    );
  }

  Widget usersList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreConstants.USERS)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primaryColor,
              ),
            );
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final UserProfileModel user =
                  UserProfileModel.fromJson(docs[index].data(), docs[index].id);
              if (AppController.to.state.appUser.value!.userId == user.userId) {
                return const SizedBox(
                  height: 0.0,
                  width: 0.0,
                );
              } else {
                return userTile(user);
              }
            },
          );
        });
  }

  Widget userTile(UserProfileModel user) {
    return ListTile(
      title: Text(user.fullName),
      subtitle: Text(user.email),
      trailing: IconButton(
        onPressed: () async {
          try {
            showLoadingScreen();
            await FirebaseFirestore.instance
                .collection(FirestoreConstants.USERS)
                .doc(user.userId)
                .update({'admin': !user.admin});
          } catch (_) {
          } finally {
            hideLoadingScreen();
          }
        },
        icon: Icon(
          user.admin ? Icons.remove_moderator : Icons.add_moderator,
          color: user.admin ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        index: 20,
      ),
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: usersList(),
      ),
    );
  }
}
