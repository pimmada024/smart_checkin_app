import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/checkin_model.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../services/location_service.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final TextEditingController _learnedTodayController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  final LocationService _locationService = LocationService();
  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorageService _localStorageService = LocalStorageService();

  String _qrStatus = 'Not scanned';
  String _gpsStatus = 'Not checked';
  String? _qrCode;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _captureGpsLocation() async {
    setState(() {
      _gpsStatus = 'Checking location...';
    });

    try {
      final position = await _locationService.getCurrentPosition();
      final timestamp = DateTime.now();

      if (!mounted) {
        return;
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _gpsStatus =
            'Lat ${position.latitude.toStringAsFixed(5)}, '
            'Lng ${position.longitude.toStringAsFixed(5)} '
            'at ${timestamp.hour.toString().padLeft(2, '0')}:'
            '${timestamp.minute.toString().padLeft(2, '0')}';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _gpsStatus = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _scanQrCode() async {
    final qrValue = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const _QrScannerPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    if (qrValue == null || qrValue.isEmpty) {
      setState(() {
        _qrStatus = 'Scan cancelled';
      });
      return;
    }

    setState(() {
      _qrCode = qrValue;
      _qrStatus = 'Verified: $qrValue';
    });
  }

  Future<void> _confirmFinish() async {
    final model = FinishClassModel(
      timestamp: DateTime.now(),
      learnedToday: _learnedTodayController.text.trim(),
      feedback: _feedbackController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      qrCode: _qrCode,
    );

    if (model.learnedToday.isEmpty || model.feedback.isEmpty) {
      await _showDialog('Missing Data', 'Please complete all reflection fields.');
      return;
    }

    await _localStorageService.saveFinishClass(model);

    try {
      await _firebaseService.submitFinishClass(model);
      if (!mounted) {
        return;
      }
      await _showDialog('Success', 'Class completion saved (local + cloud sync).');
    } catch (_) {
      if (!mounted) {
        return;
      }
      await _showDialog('Success', 'Class completion saved locally (cloud sync pending).');
    }
  }

  Future<void> _showDialog(String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Class'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Class End Verification',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _scanQrCode,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan QR'),
                    ),
                    const SizedBox(height: 8),
                    Text('QR Scan Status: $_qrStatus'),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _captureGpsLocation,
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text('Get GPS Location'),
                    ),
                    const SizedBox(height: 8),
                    Text('GPS Status: $_gpsStatus'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _learnedTodayController,
                      decoration: const InputDecoration(
                        labelText: 'What did you learn today?',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Feedback for Instructor',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmFinish,
              child: const Text('Confirm Finish'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrScannerPage extends StatefulWidget {
  const _QrScannerPage();

  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  bool _isHandled = false;

  void _handleDetection(BarcodeCapture capture) {
    if (_isHandled) {
      return;
    }

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        _isHandled = true;
        Navigator.of(context).pop(value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Class QR')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(onDetect: _handleDetection),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
