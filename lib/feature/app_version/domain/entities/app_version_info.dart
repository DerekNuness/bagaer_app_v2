class AppVersionInfo {
  final String version;
  final bool mandatoryUpdate;
  final String? url;
  final String releaseNotes;

  AppVersionInfo({
    required this.version,
    required this.mandatoryUpdate,
    required this.url,
    required this.releaseNotes,
  });
}