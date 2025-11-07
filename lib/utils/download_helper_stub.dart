/// Stub download helper for non-web platforms.
/// The real implementation lives in `download_helper_web.dart` and is
/// conditionally imported by `download_helper.dart` when building for web.
Future<void> downloadFile(String fileName, List<int> bytes) async {
  // Not supported on non-web. The caller should fallback to sharing/saving.
  throw UnsupportedError('downloadFile is only supported on web');
}
