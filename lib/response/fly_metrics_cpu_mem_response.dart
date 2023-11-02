import 'prometheus_metrics_response.dart';

class FlyMetricsCpuMemResponse {
  final String status;
  final String app;
  final List<MachineCpuMemUsage> results;

  FlyMetricsCpuMemResponse({
    required this.status,
    required this.app,
    required this.results,
  });

  static FlyMetricsCpuMemResponse fromPrometheusMetricsResponse(PrometheusMetricsResponse prometheusMetricsResponse) {
    var status = prometheusMetricsResponse.status;
    var results = <MachineCpuMemUsage>[];

    var machineIdLoadAvgMap = <String, double>{};
    var machineIdMemAvailableMap = <String, double>{};
    var machineIdMemTotalMap = <String, double>{};
    var machineIdRegionMap = <String, String>{};

    for (var result in prometheusMetricsResponse.data.result) {
      machineIdRegionMap[result.metric.instance] = result.metric.region;
      if (result.metric.name == 'fly_instance_load_avg') {
        machineIdLoadAvgMap[result.metric.instance] = result.value[1];
      } else if (result.metric.name == 'fly_instance_memory_mem_available') {
        machineIdMemAvailableMap[result.metric.instance] = double.parse(result.value[1]);
      } else if (result.metric.name == 'fly_instance_memory_mem_total') {
        machineIdMemTotalMap[result.metric.instance] = double.parse(result.value[1]);
      }
    }

    for (var machineId in machineIdMemTotalMap.keys) {
      results.add(MachineCpuMemUsage(
        instance: machineId,
        region: machineIdRegionMap[machineId] ?? '',
        loadAvg: machineIdLoadAvgMap[machineId] ?? 0,
        memAvailable: machineIdMemAvailableMap[machineId] ?? double.infinity,
        memTotal: machineIdMemTotalMap[machineId] ?? double.infinity,
      ));
    }

    return FlyMetricsCpuMemResponse(
      status: status,
      app: results.isNotEmpty ? prometheusMetricsResponse.data.result[0].metric.app : '',
      results: results,
    );
  }

  @override
  String toString() {
    return 'FlyMetricsCpuMemResponse{status: $status, app: $app, results: $results}';
  }
}

class MachineCpuMemUsage {
  final String instance;
  final String region;
  final double loadAvg;
  final double memAvailable;
  final double memTotal;

  MachineCpuMemUsage({
    required this.instance,
    required this.region,
    required this.loadAvg,
    required this.memAvailable,
    required this.memTotal,
  });

  @override
  String toString() {
    return 'MachineCpuMemUsage{instance: $instance, region: $region, loadAvg: $loadAvg, memAvailable: $memAvailable, memTotal: $memTotal}';
  }
}
