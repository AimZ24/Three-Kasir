// Conditional import: use web implementation when building for web, otherwise
// the stub which throws UnsupportedError.
import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart' as impl;

// Forwarding wrapper that calls the platform-specific implementation `downloadFile`
// provided by the conditional import above.
Future<void> downloadFile(String fileName, List<int> bytes) => impl.downloadFile(fileName, bytes);
