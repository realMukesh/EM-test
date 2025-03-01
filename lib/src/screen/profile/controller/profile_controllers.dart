import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/profile/model/profile_model.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:english_madhyam/restApi/api_service.dart';

import '../../../widgets/dialog/animated_dialog.dart';

class ProfileControllers extends GetxController {
  var loading = true.obs;
  var updateLoading = true.obs;
  Rx<ProfileModel> profileGet = ProfileModel().obs;

  var _globalSubscription = false.obs;
  get isSubscriptionActive => _globalSubscription
      .value; // It is mandatory initialize with one value from listType

  @override
  void onInit() async {
    super.onInit();
    getProfileData();
  }

  // Profile data fetch editorial_controller
  Future<void> getProfileData() async {
    try {
      loading(true);
      ProfileModel? response = await apiService.profileGetApi();
      loading(false);
      if (response != null) {
        profileGet.value.user = response.user;
        if (response.user!.isSubscription.toString() == "Y") {
          _globalSubscription(true);
        } else {
          _globalSubscription(false);
        }
      }
    } catch (e) {
      loading(false);
    }
  }

// Refresh Profile
  void refreshList() async {
    try {
      getProfileData();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      cancel();
    }
  }

  void updateProfile(
      {String? name, String? image, String? email, String? userName}) async {
    try {
      updateLoading(true);
      var updateProfile = await apiService.updateProfile(
          name: name, image: image, emailId: email, username: userName);
      if (updateProfile?.result == "success") {
        await Get.dialog(
            barrierDismissible: false,
            CustomAnimatedDialogWidget(
              title: "",
              logo: "",
              description: updateProfile?.message ?? "",
              buttonAction: "okay".tr,
              buttonCancel: "cancel".tr,
              isHideCancelBtn: true,
              onCancelTap: () {},
              onActionTap: () async {
                refreshList();
              },
            ));
      } else {
        Fluttertoast.showToast(msg: updateProfile!.message.toString());
        cancel();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      cancel();
    } finally {
      updateLoading(false);
    }
  }
}
