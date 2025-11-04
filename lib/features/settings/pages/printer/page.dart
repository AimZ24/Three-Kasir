import 'dart:async';
import 'package:kasirsuper/compat/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:kasirsuper/features/settings/services/printer_service.dart';

class PrinterSetupPage extends StatefulWidget {
  const PrinterSetupPage({super.key});

  static const String routeName = '/settings/printer';

  @override
  State<PrinterSetupPage> createState() => _PrinterSetupPageState();
}

class _PrinterSetupPageState extends State<PrinterSetupPage> {
  List<PrinterBluetooth> devices = [];
  String? selectedDevice;
  bool isLoading = false;
  String? error;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _startScanDevices();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    PrinterService.stopScan();
    super.dispose();
  }

  void _startScanDevices() {
    setState(() {
      isLoading = true;
      error = null;
    });

    _subscription = PrinterService.scanResults.listen(
      (newDevices) {
        setState(() {
          devices = newDevices;
          isLoading = false;
        });
      },
      onError: (e) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      },
    );

    PrinterService.startScan();
  }

  Future<void> _connectPrinter(PrinterBluetooth printer) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final connected = await PrinterService.connect(printer);
      if (connected) {
        setState(() {
          selectedDevice = printer.address;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printer connected successfully')),
          );
        }
      } else {
        throw Exception('Failed to connect to printer');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _disconnectPrinter() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final disconnected = await PrinterService.disconnect();
      if (disconnected) {
        setState(() {
          selectedDevice = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printer disconnected')),
          );
        }
      } else {
        throw Exception('Failed to disconnect printer');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Setup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _startScanDevices,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _startScanDevices,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : devices.isEmpty
                  ? const Center(
                      child: Text('No Bluetooth devices found'),
                    )
                  : ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        final bool isSelected = device.address == selectedDevice;

                        return ListTile(
                          title: Text(device.name ?? 'Unknown Device'),
                          subtitle: Text(device.address ?? 'Unknown Address'),
                          trailing: isSelected
                              ? TextButton(
                                  onPressed: _disconnectPrinter,
                                  child: const Text('Disconnect'),
                                )
                              : TextButton(
                                  onPressed: () => _connectPrinter(device),
                                  child: const Text('Connect'),
                                ),
                        );
                      },
                    ),
    );
  }
}