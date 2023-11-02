import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';

import 'package:fly_io_client/rest_client/fly_machines_rest_client.dart';

void main() {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  test('test machines list', () async {
    var flyClient = FlyMachinesRestClientProvider.get(env['FLY_AUTH_TOKEN']!);
    var machines = await flyClient.listMachines('cof-health-test');

    for (var m in machines) {
      expect(m.config.cpus > 0, true);
      expect(m.config.memory_mb > 0, true);
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      print('machine = ${m.id}, '
          'state = ${m.state}, '
          'last updated = ${m.updated_at} (${(currentTime - m.updated_at) / 1000} seconds ago), '
          'image = ${m.config.image}');
    }
  });
}
