// ignore_for_file: non_constant_identifier_names

import '../fly_machine_status.dart';

class MachineInfoResponse {
  final String id;
  final String name;
  final String state;
  final String region;
  final String image;
  final String instance_id;
  final String private_ip;
  final MachineInfoConfig config;
  final int created_at;
  final int updated_at;

  MachineInfoResponse({
    required this.id,
    required this.name,
    required this.state,
    required this.region,
    required this.image,
    required this.instance_id,
    required this.private_ip,
    required this.config,
    required this.created_at,
    required this.updated_at,
  });

  static MachineInfoResponse fromJson(Map<String, dynamic> json) {
    return MachineInfoResponse(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      region: json['region'],
      image: json['config']?['image'] ?? '',
      instance_id: json['instance_id'],
      private_ip: json['private_ip'],
      config: MachineInfoConfig.fromJson(json['config']),
      created_at: DateTime.parse(json['created_at']).millisecondsSinceEpoch,
      updated_at: DateTime.parse(json['updated_at']).millisecondsSinceEpoch,
    );
  }

  // machine image is of the form: "registry.fly.io/cof-game-server-testing:v0.0.1"
  // this getter extracts the version number from the image name
  String get serverVersion {
    var imageParts = image.split(':');
    if (imageParts.length == 2) {
      var versionPart = imageParts[1];
      if (versionPart.startsWith('v')) {
        versionPart = versionPart.substring(1);
      }
      return versionPart;
    } else {
      return '';
    }
  }

  bool isDestroyed() {
    return state == FlyMachineStatus.destroying.name || state == FlyMachineStatus.destroyed.name;
  }

  @override
  String toString() {
    return 'MachineInfoResponse{id: $id, name: $name, state: $state, region: $region}';
  }
}


class MachineInfoConfig {
  final String image;
  final String cpu_kind;
  final int cpus;
  final int memory_mb;

  MachineInfoConfig({
    required this.image,
    required this.cpu_kind,
    required this.cpus,
    required this.memory_mb,
  });

  static MachineInfoConfig fromJson(Map<String, dynamic> json) {
    return MachineInfoConfig(
      image: json['image'],
      cpu_kind: json['guest']?['cpu_kind'] ?? '',
      cpus: json['guest']?['cpus'] ?? 0,
      memory_mb: json['guest']?['memory_mb'] ?? 0,
    );
  }
}
