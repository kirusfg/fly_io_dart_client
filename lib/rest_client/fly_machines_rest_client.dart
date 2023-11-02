// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../fly_machine_status.dart';
import '../request/create_machine_request.dart';
import '../response/app_details_response.dart';
import '../response/machine_info_response.dart';

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
}

class FlyMachinesRestClientProvider {
  static FlyMachinesRestClient? _flyRestClient;

  static FlyMachinesRestClient get(String token) {
    _flyRestClient ??= FlyMachinesRestClient(token);
    return _flyRestClient!;
  }

  /// for testing
  static void setFlyClient(FlyMachinesRestClient flyClient) {
    _flyRestClient = flyClient;
  }
}

class FlyMachinesRestClient {
  static final _log = Logger('FlyMachinesRestClient');

  final String _baseApiUrl;
  final String _token;

  FlyMachinesRestClient(this._token, {String baseApiUri = 'https://api.machines.dev'}) : _baseApiUrl = baseApiUri;

  Future<bool> createApplication(String name, {String orgSlug = 'personal'}) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps');
    var response = await http.post(
      url,
      body: jsonEncode({
        'app_name': name,
        'org_slug': orgSlug,
      }),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    return true;
  }

  Future<AppDetailsResponse> getApplication(String name) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$name');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    return AppDetailsResponse.fromJsonString(body);
  }

  Future<MachineInfoResponse> createMachine(String appName, CreateMachineRequest machineRequest) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines');
    var response = await http.post(
      url,
      body: jsonEncode(machineRequest.toJson()),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    return MachineInfoResponse.fromJson(jsonDecode(body));
  }

  Future<MachineInfoResponse> updateMachine(String appName, String machineId, UpdateMachineRequest machineRequest) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId');
    var response = await http.post(
      url,
      body: jsonEncode(machineRequest.toJson()),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    return MachineInfoResponse.fromJson(jsonDecode(body));
  }

  Future<List<MachineInfoResponse>> listMachines(String appName) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    var machines = <MachineInfoResponse>[];
    var machineListJson = jsonDecode(body) as List;
    for (var machineInfoJson in machineListJson) {
      // temporary fix for the problem with the list API
      // see https://community.fly.io/t/fly-machines-list-api-acting-odd-returning-started-instances-with-no-image-or-region-information/13330
      if (machineInfoJson['config']['image'] == null) {
        _log.warning('Skipping machine ${machineInfoJson['id']}');
        continue;
      }
      machines.add(MachineInfoResponse.fromJson(machineInfoJson));
    }
    _log.fine('listMachines for app $appName: ${machines.map((e) => e.id).join(', ')}');
    return machines;
  }

  Future<MachineInfoResponse> getMachineInfo(String appName, String machineId) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, body);
    }
    return MachineInfoResponse.fromJson(jsonDecode(body));
  }

  /// Waits for the machine to be in the given status, or throws an exception if the timeout is reached.
  /// Returns the machine id
  Future<String> waitForMachineStatus(String appName, String machineId, FlyMachineStatus status, {int timeoutSeconds = 60}) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId/wait?'
        'timeout=$timeoutSeconds&'
        'state=${status.name}');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    ).timeout(Duration(seconds: timeoutSeconds), onTimeout: () {
      return http.Response('Timeout waiting for machine $machineId to be in state ${status.name}', 408);
    });
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, '$body');
    }
    return machineId;
  }

  /// Stops a machine.
  /// This method is idempotent, calling it multiple times will return status 200 OK (indicating the machine was stopped)
  /// Returns true if the machine was stopped, false if it could not be stopped
  Future<bool> stopMachine(String appName, String machineId) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId/stop');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      return false;
    }
    return true;
  }

  /// Starts a machine.
  /// when a machine is in stopped state, calling the start API will return 200 OK
  /// JSON response:
  ///   {
  ///     "previous_state": "stopped"
  ///   }
  ///
  /// when a machine is in started state, calling the start API again will return 200 OK
  /// JSON response:
  ///   {
  ///     "previous_state": "started"
  ///   }
  ///
  /// if a machine is "stopping" and we call the start API, it returns 412 Precondition Failed
  /// JSON response:
  ///   {
  ///     "error": "unable to start machine from current state: 'stopping'"
  ///   }
  Future<String> startMachine(String appName, String machineId) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId/start');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    var json = jsonDecode(body);

    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      var errMessage = json['error'];
      throw FlyRestClientException(response.statusCode, '$errMessage');
    } else {
      var prevState = json['previous_state'];
      return prevState;
    }
  }

  Future<bool> destroyMachine(String appName, String machineId) async {
    var url = Uri.parse('$_baseApiUrl/v1/apps/$appName/machines/$machineId');
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    var body = response.body;
    _log.fine('Request to $url completed with status ${response.statusCode}. Response body = ${body.truncateTo(80)}');
    if (response.statusCode >= 400) {
      _log.severe('Fly request failed: $body');
      throw FlyRestClientException(response.statusCode, '$body');
    }
    return true;
  }

}

class FlyRestClientException implements Exception {
  final int statusCode;
  final String message;

  FlyRestClientException(this.statusCode, this.message);

  @override
  String toString() {
    return 'FlyRestClientException{statusCode: $statusCode, API response: $message}';
  }
}
