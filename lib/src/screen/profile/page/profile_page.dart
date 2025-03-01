import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import '../../../widgets/rounded_button.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool edit = false;
  final ProfileControllers _profileControllers = Get.find();
  final AuthenticationManager _authenticationController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = false;
  bool loader = false;
  final ImagePicker _picker = ImagePicker();
  XFile pickedFileProfile = XFile("");
  String imageUrl = "";
  String profilePath = "";

  FetchUserData() {
    setState(() {
      userName.text =
          _profileControllers.profileGet.value.user!.name.toString();
      phone.text = _profileControllers.profileGet.value.user!.phone.toString();
      email.text = _profileControllers.profileGet.value.user!.email.toString();
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    _profileControllers.refreshList();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  DateTime? dateTime;
  TextEditingController userName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    FetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: const ToolbarTitle(
          title: "Edit Profile",
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                edit = !edit;
              });
            },
            child: Container(
              width: 100.adaptSize,
              margin: const EdgeInsets.all(10),
              padding:
                  const EdgeInsets.only(left: 14, right: 12, top: 0, bottom: 0),
              decoration: BoxDecoration(
                color: edit == true ? greyColor : greenColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CommonTextViewWidget(
                  text: edit == true ? "Cancel" : "Edit",
                  color: whiteColor,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Obx(() {
            if (_profileControllers.loading.value) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/loader.json",
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          edit == true ? bottomSheetSelector() : null;
                        },
                        child: SizedBox(
                            width: Get.width * 0.28,
                            height: Get.height * 0.14,
                            child: Stack(
                              fit: StackFit.expand,
                              // overflow: Overflow.visible,
                              children: [
                                loader == true
                                    ? const CircularProgressIndicator()
                                    : profilePath == ""
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _profileControllers.profileGet
                                                    .value.user!.image
                                                    .toString()),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: FileImage(
                                                File(pickedFileProfile.path)),
                                          ),
                                edit == true
                                    ? Positioned(
                                        bottom: 18,
                                        right: 0,
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              bottomSheetSelector();
                                            },
                                            child: const Icon(Icons.camera_alt,
                                                size: 15, color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : const Text("")
                              ],
                            )),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            children: [
                              CommonTextViewWidget(
                                text: _profileControllers
                                    .profileGet.value.user!.name
                                    .toString(),
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              _profileControllers
                                          .profileGet.value.user!.email !=
                                      null
                                  ? CommonTextViewWidget(
                                      text: (_profileControllers
                                              .profileGet.value.user!.email)
                                          .toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: colorGray,
                                    )
                                  : const Text(""),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          // color: redColor,
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/img/profile_shape.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      enabled: edit,
                      readOnly: !edit,
                      controller: userName,
                      decoration: InputDecoration(
                          labelText: "Username",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: colorGray, fontSize: 12.fSize)),
                    ),
                    TextFormField(
                      enabled: false,
                      readOnly: true,
                      controller: phone,
                      decoration: InputDecoration(
                          prefixText: "+91  ",
                          labelText: "Phone Number",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: colorGray, fontSize: 12.fSize)),
                    ),
                    TextFormField(
                      enabled: edit,
                      readOnly: !edit,
                      controller: email,
                      decoration: InputDecoration(
                          labelText: "Enter Email Address ",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: colorGray, fontSize: 12.fSize)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _profileControllers.isSubscriptionActive
                        ? subsDetails()
                        : const Text(""),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: edit,
                      child: Center(
                        child: RoundedButton(
                          text: "Update",
                          press: () {
                            {
                              try {
                                _profileControllers.updateProfile(
                                  name: userName.text.trim(),
                                  image: profilePath == "" ? null : profilePath,
                                  email: email.text == ""
                                      ? _profileControllers
                                          .profileGet.value.user!.email
                                      : email.text,
                                  userName: userName.text.trim(),
                                );
                              } catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void getImage1(source, String key) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        loader = true;
      });
    }

    final dir = await path_provider.getTemporaryDirectory();

    final targetPath = dir.absolute.path + "/temp.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile!.path,
      targetPath,
      quality: 88,
      rotate: 0,
    );

    setState(() {
      pickedFileProfile = pickedFile;
      profilePath = result!.path;
      loader = false;
    });
  }

  bottomSheetSelector() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100.0,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                CommonTextViewWidget(
                  text: "Choose photo",
                  fontSize: 20.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.camera, color: purplegrColor),
                      onPressed: () {
                        getImage1(ImageSource.camera, "photo");
                        Navigator.pop(context);
                      },
                      label: CommonTextViewWidget(
                        text: "Camera",
                        color: Colors.black,
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.image, color: purplegrColor),
                      onPressed: () {
                        getImage1(ImageSource.gallery, "photo");
                        Navigator.pop(context);
                      },
                      label: CommonTextViewWidget(
                        text: "Gallery",
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget subsDetails() {
    return Container(
      padding: EdgeInsets.only(left: 14.h, right: 14.h, top: 12, bottom: 12),
      decoration: BoxDecoration(
          color: AdaptiveTheme.of(context).mode.isDark
              ? Colors.transparent
              : colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          CommonTextViewWidget(
            text: "Material Purchase Detail",
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: CommonTextViewWidget(
              text:
                  "Start From : ${_profileControllers.profileGet.value.user?.subscriptionDetails?.startDate ?? ""} ",
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: CommonTextViewWidget(
              text:
                  "End On : ${_profileControllers.profileGet.value.user?.subscriptionDetails?.endDate ?? ""} ",
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextViewWidget(
                  text:
                      "Validity ${_profileControllers.profileGet.value.user?.subscriptionDetails?.planDuration ?? ""} Months",
                  fontWeight: FontWeight.w500,
                ),
                CommonTextViewWidget(
                  text:
                      "₹ ${_profileControllers.profileGet.value.user?.subscriptionDetails?.fee ?? ""}",
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          CommonTextViewWidget(
            text:
                "${_profileControllers.profileGet.value.user?.subscriptionDetails?.daysLeft ?? ""}Days left",
            color: greenColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Future _pickImage() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _imageFile = pickedimage != null ? File(pickedimage.path) : null;
    if (_imageFile != null) {
      setState(() {
        _imageFile = File(pickedimage!.path);
      });
    }
  }
}
