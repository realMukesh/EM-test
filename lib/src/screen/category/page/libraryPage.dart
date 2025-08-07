import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/category/controller/libraryController.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/practice/page/praticeCategoryPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';

import 'package:english_madhyam/resrc/widgets/regularTextView.dart';

import '../../../../resrc/utils/routes/my_constant.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/gridViewSkeleton.dart';
import '../../../utils/colors/colors.dart';
import '../../material/controller/materialController.dart';
import '../../material/page/material_category_list_page.dart';
import '../../practice/controller/praticeController.dart';

class MaterialParentCategoriesPage extends StatefulWidget {
  MaterialParentCategoriesPage({Key? key}) : super(key: key);

  @override
  _MaterialParentCategoriesPageState createState() => _MaterialParentCategoriesPageState();
}

class _MaterialParentCategoriesPageState extends State<MaterialParentCategoriesPage> {
  late final MaterialController _materialController;
  late final LibraryController _libraryController;
  late final FavoriteController _favoriteController;
  late final PraticeController _praticeController;

  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  void initState() {
    super.initState();
    _materialController = Get.put(MaterialController());
    _libraryController = Get.put(LibraryController());
    _praticeController = Get.put(PraticeController());
    _favoriteController = Get.find<FavoriteController>();

  }

  void _onRefresh() async {
    // monitor network fetch
    _libraryController.getParentCategory(
      isRefresh: false,
      isSavedQuestions: _favoriteController.isSavedQuestionNavigation.value,
    );
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed, use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _libraryController.getParentCategory(isRefresh: false,isSavedQuestions: _favoriteController.isSavedQuestionNavigation.value);

      // Perform state updates here
      // Example: controller.someReactiveProperty.value = newValue;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ToolbarTitle(
          title: "Library",
          color: Colors.white,
        ),
      ),
      body: Container(
        width: context.width,
        height: context.height,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                      () {
                    _onRefresh();
                  },
                );
              },
              child:
              Obx(()=>
              Skeleton(
                themeMode: ThemeMode.light,
                isLoading: _libraryController.loading.value,
                skeleton: const GridViewSkeleton(),
                child: buildMenuList(context),
              ),
            ),
            // Obx(() => _libraryController.loading.value ? const Loading() : const SizedBox()),
            )],
        ),
      ),
    );
  }

  Widget buildMenuList(BuildContext context) {
    return GetX<LibraryController>(builder: (controller) {
      if(controller.parentCategories.isEmpty){
        return ShowLoadingPage(refreshIndicatorKey: _refreshKey,);
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.parentCategories.length,
        itemBuilder: (context, index) => buildChildMenuBody(index, context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          childAspectRatio: 0.7,
          crossAxisSpacing: 4,
        ),
      );
    });
  }

  Widget buildChildMenuBody(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        if (!_favoriteController.isSavedQuestionNavigation.value) {
          if (_libraryController.parentCategories[index].id == 1) {
            _materialController.getMaterialCategory(_libraryController.parentCategories[index].id.toString(),_favoriteController.isSavedQuestionNavigation.value);
            Get.to(MaterialCategoryListPage(parentcateId: _libraryController.parentCategories[index].id.toString()));
          } else {
            _praticeController.getSubCategories(_libraryController.parentCategories[index].id.toString(),_favoriteController.isSavedQuestionNavigation.value);
            Get.to(MaterialSubCategoriesPage(parentcateId: _libraryController.parentCategories[index].id.toString()));
          }
        } else {
          _praticeController.getSubCategories(_libraryController.parentCategories[index].id.toString(),_favoriteController.isSavedQuestionNavigation.value);
          Get.to(MaterialSubCategoriesPage(parentcateId: _libraryController.parentCategories[index].id.toString(),isSavedQuestions:_favoriteController.isSavedQuestionNavigation.value ,));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.8),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(-4, 4),
            ),
          ],
          color: Color(hexStringToHexInt(color[index % 4])),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: greyColor.withOpacity(0.7),
                    spreadRadius: 0.0,
                    blurRadius: 5,
                    offset: const Offset(-3, 3),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(_libraryController.parentCategories[index].image ?? MyConstant.banner_image),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            const SizedBox(height: 5),
            Text(
              _libraryController.parentCategories[index].name ?? "",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 12, color: blackColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
