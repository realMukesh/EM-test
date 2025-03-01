import 'package:english_madhyam/src/screen/material/model/pdf_list_model.dart';
import 'package:get/get.dart';

import 'package:english_madhyam/restApi/api_service.dart';

class PdfController extends GetxController {
  RxBool loading = false.obs;
  Rx<PdfList> pdfList = PdfList().obs;


  void pdfListController({required String type, required String id}) async {
    try {
      loading(true);
      var response = await apiService.pdfListProv(type:type, id: id);
      if (response != null) {
        pdfList.value = response;      loading(false);

      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
  }
}
