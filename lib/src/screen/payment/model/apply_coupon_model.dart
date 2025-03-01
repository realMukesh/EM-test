class ApplyCouponModel {
  bool? result;
  String? message;
  CouponDetails? couponDetails;

  ApplyCouponModel({this.result, this.message, this.couponDetails});

  ApplyCouponModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    couponDetails = json['coupon_details'] != null
        ?  CouponDetails.fromJson(json['coupon_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.couponDetails != null) {
      data['coupon_details'] = this.couponDetails!.toJson();
    }
    return data;
  }
}

class CouponDetails {
  double? finalAmount;
  double? discount;

  CouponDetails({this.finalAmount, this.discount});

  CouponDetails.fromJson(Map<String, dynamic> json) {
    finalAmount = double.parse(json['final_amount'].toString());
    discount = double.parse(json['discount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['final_amount'] = finalAmount;
    data['discount'] = discount;
    return data;
  }
}


