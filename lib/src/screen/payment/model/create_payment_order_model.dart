class CreatePaymentOrderModel {
  String? status;
  String? orderId;
  String? currency;

  CreatePaymentOrderModel({this.status, this.orderId, this.currency});

  CreatePaymentOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['order_id'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['currency'] = this.currency;
    return data;
  }
}
