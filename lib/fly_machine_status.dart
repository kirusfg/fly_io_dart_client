import 'package:collection/collection.dart';

enum FlyMachineStatus {
  created,
  started,
  failed,
  unhealthy,
  starting,
  stopping,
  stopped,
  replacing,
  destroying,
  destroyed,
  unknown,
  ;

  static FlyMachineStatus? fromString(String status) {
    return FlyMachineStatus.values.firstWhereOrNull((e) => e.name == status);
  }

  static List<String> getNonDestroyedStatuses() {
    return [
      FlyMachineStatus.created.name,
      FlyMachineStatus.started.name,
      FlyMachineStatus.starting.name,
      FlyMachineStatus.stopping.name,
      FlyMachineStatus.stopped.name,
      FlyMachineStatus.replacing.name,
    ];
  }
}
