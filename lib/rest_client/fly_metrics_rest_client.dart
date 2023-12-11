import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../response/fly_metrics_cpu_mem_response.dart';
import '../response/prometheus_metrics_response.dart';
import 'fly_machines_rest_client.dart';

class FlyMetricsRestClient {
  static final _log = Logger('FlyMetricsRestClient');

  final String _baseApiUrl;
  final String _token;

  FlyMetricsRestClient(this._token, {String baseApiUri = 'https://api.fly.io'}) : _baseApiUrl = baseApiUri;

  Future<FlyMetricsCpuMemResponse> getCpuMemUsage(String appName, {String orgSlug = 'personal'}) async {
    var url = Uri.parse('$_baseApiUrl/prometheus/$orgSlug/api/v1/query');

    var promQLQuery = 'query=${Uri.encodeComponent('('
        'avg_over_time(fly_instance_memory_mem_available{app="$appName"}[2m]), '
        'avg_over_time(fly_instance_memory_mem_total{app="$appName"}[2m]), '
        'fly_instance_load_average{app="$appName",minutes="5"}'
        ')')}';
    var response = await http.post(
      url,
      body: promQLQuery,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    var body = response.body;
    _log.fine('Metrics request to $url completed with status ${response.statusCode}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    var prometheusMetricsResponse = PrometheusMetricsResponse.fromJson(jsonDecode(body));
    return FlyMetricsCpuMemResponse.fromPrometheusMetricsResponse(prometheusMetricsResponse);
  }

}
