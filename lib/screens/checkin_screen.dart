import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/checkin_model.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../services/location_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _previousTopicController =
      TextEditingController();
  final TextEditingController _expectedTopicController =
      TextEditingController();

  final LocationService _locationService = LocationService();
  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorageService _localStorageService = LocalStorageService();

  double _mood = 3;
  String _gpsStatus = 'Not checked';
  String _qrStatus = 'Not scanned';
  double? _latitude;
  double? _longitude;
  String? _qrCode;

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentIdController.dispose();
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
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
      _qrStatus = 'Scanned: $qrValue';
    });
  }

  Future<void> _submitCheckIn() async {
    final model = CheckInModel(
      studentName: _studentNameController.text.trim(),
      studentId: _studentIdController.text.trim(),
      timestamp: DateTime.now(),
      previousTopic: _previousTopicController.text.trim(),
      expectedTopic: _expectedTopicController.text.trim(),
      mood: _mood.round(),
      latitude: _latitude,
      longitude: _longitude,
      qrCode: _qrCode,
    );

    if (model.studentName.isEmpty ||
        model.studentId.isEmpty ||
        model.previousTopic.isEmpty ||
        model.expectedTopic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    await _localStorageService.saveCheckIn(model);

    try {
      await _firebaseService.submitCheckIn(model);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved (local + cloud sync).')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in saved locally (cloud sync pending).'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Check-in'),
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
                      'Class Verification Status',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text('GPS Status'),
                      subtitle: Text(_gpsStatus),
                      trailing: TextButton(
                        onPressed: _captureGpsLocation,
                        child: const Text('Get GPS'),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.qr_code_scanner),
                      title: const Text('QR Scan Status'),
                      subtitle: Text(_qrStatus),
                      trailing: TextButton(
                        onPressed: _scanQrCode,
                        child: const Text('Scan'),
                      ),
                    ),
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
                    const Text(
                      'Check-in Form',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _studentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _studentIdController,
                      decoration: const InputDecoration(
                        labelText: 'Student ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _previousTopicController,
                      decoration: const InputDecoration(
                        labelText: 'Previous Class Topic',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _expectedTopicController,
                      decoration: const InputDecoration(
                        labelText: 'Expected Topic Today',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mood Before Class',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _mood,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _mood.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _mood = value;
                        });
                      },
                    ),
                    Text('Selected score: ${_mood.round()} / 5'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCheckIn,
              child: const Text('Submit Check-in'),
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
