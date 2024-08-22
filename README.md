# High-level API for interacting with the Fly.io API

## Initialization

Construct a new Fly.io client by calling `FlyMachinesRestClient` with your Fly.io API token:

```dart
var flyClient = FlyMachinesRestClient(FLY_AUTH_TOKEN);
```

## Usage

Here is a simple usage example:

```dart
var flyClient = FlyMachinesRestClient(env['FLY_AUTH_TOKEN']!);
var machines = await flyClient.listMachines('cof-health-test');

for (final machine in machines) {
    print('machine = ${m.id}, '
          'state = ${m.state}, '
          'image = ${m.config.image}');
}
```

You can create, list, update, and delete Fly.io resources, namely - applications and machines:

```dart
var appName = 'test-app';
var serverPort = '8080';
var created = await flyClient.createApplication();

if (created) {
    var createMachineRequest = CreateMachineRequest(
        machineName,
        MachineConfig(
            image: gameServerImage.image,
            size: MachineSize.shared_cpu_2x,
            env: {
                'SERVER_PORT': serverPort,
                'JWT_SECRET': 'some-secret',
            },
            services: [
                MachineService(
                    ServiceProtocol.tcp,
                    serverPort,
                    [
                      MachineServicePort(
                        443,
                        [MachineServiceConnectionHandler.tls, MachineServiceConnectionHandler.http],
                      ),
                    ],
                    concurrency: MachineServiceConcurrency(MachineServiceConcurrencyType.connections, 50, 100),
                    checks: [
                      MachineCheck(
                        grace_period: '3s',
                        interval: '10s',
                        timeout: '2s',
                        method: 'get',
                        path: '/internal/health',
                        protocol: 'http',
                        type: MachineCheckType.http,
                        port: serverPort,
                      ),
                    ],
                ),
            ],
        ),
        region: FlyRegion.ewr,
    );

    try {
        var machineInfo = await flyMachinesRestClient.createMachine(
          'test-app',
          createMachineRequest,
        );
        return machineInfo;
    } catch (e) {
        print('error here: $e');
        rethrow;
    }
}
```

You can wait for the machine to enter a specific state, as well:

```dart
var machineId = await flyMachinesRestClient.waitForMachineStatus(
    'app-name',
    'machine-id',
    FlyMachineStatus.started,
    timeoutSeconds: 20,
);
```

## Prometheus Metrics

You can also retrieve metrics from your Fly.io application using the `FlyMetricsRestClient`:

```dart
var flyMetricsClient = FlyMetricsRestClientProvider.get(env['FLY_AUTH_TOKEN']!);
var metrics = await flyMetricsClient.getCpuMemUsage('app-name');

print(metrics);
```
