class GHNRequest {
  String? endpoint;
  String? postJsonString;

  GHNRequest({
    this.endpoint,
    this.postJsonString,
  });

  GHNRequest.fromJson(Map<String, dynamic> json) {
    postJsonString = json['PostJsonString'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Endpoint': endpoint,
      'PostJsonString': postJsonString,
    };
  }
}
