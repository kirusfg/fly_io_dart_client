// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import '../fly_constants.dart';

class CreateMachineRequest {
  final String name;
  final FlyRegion? region;
  final MachineConfig config;

  CreateMachineRequest(
    this.name,
    this.config, {
    this.region,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['name'] = name;
    if (region != null) {
      jsonMap['region'] = region!.code;
    }
    jsonMap['config'] = config.toJson();
    return jsonMap;
  }
}

class UpdateMachineRequest {
  final MachineConfig config;

  UpdateMachineRequest(this.config);

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['config'] = config.toJson();
    return jsonMap;
  }
}

class MachineConfig {
  final String image;
  final MachineGuest? guest;
  final MachineSize? size;
  final Map<String, String> env;
  final List<MachineService> services;
  final List<MachineVolumeMount>? mounts;
  final Map<String, MachineCheck>? checks;

  MachineConfig({
    required this.image,
    required this.env,
    required this.services,
    this.guest,
    this.size,
    this.mounts,
    this.checks,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['image'] = image;
    jsonMap['env'] = env;
    jsonMap['services'] = services;
    if (guest != null) {
      jsonMap['guest'] = guest;
    }
    if (size != null) {
      jsonMap['size'] = size!.name;
    }
    if (mounts != null) {
      jsonMap['mounts'] = mounts;
    }
    if (checks != null) {
      jsonMap['checks'] = checks;
    }
    return jsonMap;
  }
}

class MachineGuest {
  final int memory_mb;
  final int cpus;
  final String? kernel_args;
  final MachineCpuKind cpu_kind;

  MachineGuest({
    required this.memory_mb,
    required this.cpus,
    required this.cpu_kind,
    this.kernel_args,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['memory_mb'] = memory_mb;
    jsonMap['cpus'] = cpus;
    jsonMap['cpu_kind'] = cpu_kind.name;
    if (kernel_args != null) {
      jsonMap['kernel_args'] = kernel_args;
    }
    return jsonMap;
  }
}

enum MachineSize {
  shared_cpu_1x('shared-cpu-1x'),
  shared_cpu_2x('shared-cpu-2x'),
  shared_cpu_4x('shared-cpu-4x'),
  shared_cpu_8x('shared-cpu-8x'),
  performance_1x('performance-1x'),
  performance_2x('performance-2x'),
  performance_4x('performance-4x'),
  performance_8x('performance-8x'),
  performance_16x('performance-16x'),
  ;

  final String name;

  const MachineSize(this.name);
}

enum MachineCpuKind {
  shared;
}

class MachineService {
  final ServiceProtocol protocol;
  final MachineServiceConcurrency? concurrency;
  final int internal_port;
  final List<MachineServicePort> ports;
  final List<MachineCheck>? checks;

  MachineService(
    this.protocol,
    this.internal_port,
    this.ports, {
    this.concurrency,
    this.checks,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['protocol'] = protocol.name;
    jsonMap['internal_port'] = internal_port;
    jsonMap['ports'] = ports;
    if (concurrency != null) {
      jsonMap['concurrency'] = concurrency;
    }
    if (checks != null) {
      jsonMap['checks'] = checks;
    }
    return jsonMap;
  }
}

enum ServiceProtocol {
  tcp,
  udp;
}

class MachineServiceConcurrency {
  final MachineServiceConcurrencyType type;
  final int soft_limit;
  final int hard_limit;

  MachineServiceConcurrency(this.type, this.soft_limit, this.hard_limit);

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['type'] = type.name;
    jsonMap['soft_limit'] = soft_limit;
    jsonMap['hard_limit'] = hard_limit;
    return jsonMap;
  }
}

enum MachineServiceConcurrencyType {
  connections,
  requests;
}

class MachineServicePort {
  final int port;
  final List<MachineServiceConnectionHandler> handlers;

  MachineServicePort(this.port, this.handlers);

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['port'] = port;
    jsonMap['handlers'] = handlers.map((e) => e.name).toList();
    return jsonMap;
  }
}

enum MachineServiceConnectionHandler {
  tls,
  pg_tls,
  http,
  edge_http,
  proxy_proto;
}

class MachineVolumeMount {
  final String volume;
  final String path;

  MachineVolumeMount({
    required this.volume,
    required this.path,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    jsonMap['volume'] = volume;
    jsonMap['path'] = path;
    return jsonMap;
  }
}

class MachineCheck {
  final MachineCheckType type;
  final int port;

  /// minimum time to wait before doing the first check
  /// specified as a string duration like "10s"
  final String? grace_period;

  /// specified as a string duration like "10s"
  final String interval;

  /// specified as a string duration like "10s"
  final String timeout;

  /// For http checks, the HTTP method to use to when making the request (GET / POST etc)
  final String method;

  /// For http checks, the path to request
  final String path;

  /// For http checks, the protocol to use (http / https)
  final String protocol;

  /// For http checks, the headers
  final Map<String, String>? headers;

  MachineCheck({
    this.grace_period,
    required this.type,
    required this.port,
    required this.interval,
    required this.timeout,
    required this.method,
    required this.path,
    required this.protocol,
    this.headers,
  });

  Map<String, dynamic> toJson() {
    var jsonMap = <String, dynamic>{};
    if (grace_period != null) {
      jsonMap['grace_period'] = grace_period;
    }
    jsonMap['type'] = type.name;
    jsonMap['port'] = port;
    jsonMap['interval'] = interval;
    jsonMap['timeout'] = timeout;
    jsonMap['method'] = method;
    jsonMap['path'] = path;
    jsonMap['protocol'] = protocol;
    if (headers != null) {
      jsonMap['headers'] = headers;
    }
    return jsonMap;
  }
}

enum MachineCheckType {
  tcp,
  http;
}
