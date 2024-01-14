class VNPayRequest {
  String? orderId;
  double? price;
  int? method;
  String? lang;
  String? returnUrl;
  String? paymentUrl;

  VNPayRequest({
    this.orderId,
    this.price,
    this.method,
    this.lang,
    this.returnUrl,
    this.paymentUrl,
  });

  VNPayRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['OrderId'];
    price = double.tryParse(json['Price'].toString());
    method = json['Method'];
    lang = json['Lang'];
    returnUrl = json['ReturnUrl'];
    paymentUrl = json['PaymentUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'Price': price,
      'Method': method,
      'Lang': lang,
      'ReturnUrl': returnUrl,
      'PaymentUrl': paymentUrl,
    };
  }
}
