class PrometheusMetricsResponse {
  final String status;
  final bool isPartial;
  final PrometheusMetricsResponseData data;

  PrometheusMetricsResponse({
    required this.status,
    required this.isPartial,
    required this.data,
  });

  static PrometheusMetricsResponse fromJson(Map<String, dynamic> json) {
    return PrometheusMetricsResponse(
      status: json['status'],
      isPartial: json['isPartial'],
      data: PrometheusMetricsResponseData.fromJson(json['data']),
    );
  }
}

class PrometheusMetricsResponseData {
  final String resultType;
  final List<PrometheusMetricsResponseDataResult> result;

  PrometheusMetricsResponseData({
    required this.resultType,
    required this.result,
  });

  static PrometheusMetricsResponseData fromJson(Map<String, dynamic> json) {
    return PrometheusMetricsResponseData(
      resultType: json['resultType'],
      result: List<PrometheusMetricsResponseDataResult>.from(json['result'].map((x) => PrometheusMetricsResponseDataResult.fromJson(x))),
    );
  }
}

class PrometheusMetricsResponseDataResult {
  final PrometheusMetricsResponseDataResultMetric metric;
  final List<dynamic> value;

  PrometheusMetricsResponseDataResult({
    required this.metric,
    required this.value,
  });

  static PrometheusMetricsResponseDataResult fromJson(Map<String, dynamic> json) {
    return PrometheusMetricsResponseDataResult(
      metric: PrometheusMetricsResponseDataResultMetric.fromJson(json['metric']),
      value: List<dynamic>.from(json['value'].map((x) => x)),
    );
  }
}

class PrometheusMetricsResponseDataResultMetric {
  final String name;
  final String app;
  final String host;
  final String instance;
  final String region;

  PrometheusMetricsResponseDataResultMetric({
    required this.name,
    required this.app,
    required this.host,
    required this.instance,
    required this.region,
  });

  static PrometheusMetricsResponseDataResultMetric fromJson(Map<String, dynamic> json) {
    return PrometheusMetricsResponseDataResultMetric(
      name: json['__name__'],
      app: json['app'],
      host: json['host'],
      instance: json['instance'],
      region: json['region'],
    );
  }
}
