// Minimal stub for esc_pos_bluetooth so project can build when plugin is removed.
// This provides only the API surface used in the app and does not perform real Bluetooth.

import 'dart:async';

class PrinterBluetooth {
  final String? name;
  final String? address;
  PrinterBluetooth({this.name, this.address});
}

class PrinterBluetoothManager {
  final StreamController<List<PrinterBluetooth>> _ctrl = StreamController.broadcast();
  Stream<List<PrinterBluetooth>> get scanResults => _ctrl.stream;

  void startScan(Duration duration) {
    // Emit empty result after scan duration to simulate no devices
    Future.delayed(duration, () => _ctrl.add([]));
  }

  void stopScan() {
    // no-op
  }

  void selectPrinter(PrinterBluetooth? p) {
    // no-op
  }

  Future<bool> printTicket(List<int> bytes) async {
    // stub: pretend print succeeded
    return true;
  }
}
