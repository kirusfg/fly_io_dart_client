import 'dart:convert';

class AppDetailsResponse {
  final String name;
  final String status;
  final OrgDetails organization;

  AppDetailsResponse({
    required this.name,
    required this.status,
    required this.organization,
  });

  static AppDetailsResponse fromJsonString(String jsonStr) {
    var map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return AppDetailsResponse(
      name: map['name'],
      status: map['status'],
      organization: OrgDetails.fromJsonMap(map['organization']),
    );
  }
}

class OrgDetails {
  final String name;
  final String slug;

  OrgDetails({
    required this.name,
    required this.slug,
  });

  static OrgDetails fromJsonMap(Map<String, dynamic> map) {
    return OrgDetails(
      name: map['name'],
      slug: map['slug'],
    );
  }
}
