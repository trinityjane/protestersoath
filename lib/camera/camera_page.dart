import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protestersoath/settings/SettingsContainer.dart';

/// Simple in-app camera screen that supports video recording.
///
/// Auto-save mode: When enabled, videos are automatically saved to Camera Roll
/// when you stop recording. No need to tap any buttons after recording.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _autoSaveEnabled = false;
  bool _isSaving = false;
  String? _lastSavedPath;

  @override
  void initState() {
    super.initState();
    _loadAutoSaveSetting();
  }

  Future<void> _loadAutoSaveSetting() async {
    final autoSave = await SettingsContainer.getAutoSaveVideo();
    if (mounted) {
      setState(() {
        _autoSaveEnabled = autoSave;
      });
    }
  }

  Future<CaptureRequest> _videoPathBuilder(List<Sensor> sensors) async {
    final Directory dir = await getTemporaryDirectory();
    final Directory outDir =
        await Directory('${dir.path}/protestersoath').create(recursive: true);
    final String baseName =
        'protesters_oath_${DateTime.now().millisecondsSinceEpoch}';

    if (sensors.length == 1) {
      return SingleCaptureRequest(
        '${outDir.path}/$baseName.mp4',
        sensors.first,
      );
    }

    return MultipleCaptureRequest({
      for (final sensor in sensors)
        sensor: '${outDir.path}/${baseName}_${sensor.deviceId ?? sensor.hashCode}.mp4',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Record Video'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  _autoSaveEnabled ? Icons.save : Icons.save_outlined,
                  color: _autoSaveEnabled ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _autoSaveEnabled ? 'Auto' : 'Manual',
                  style: TextStyle(
                    color: _autoSaveEnabled ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.video(
          pathBuilder: _videoPathBuilder,
        ),
        previewFit: CameraPreviewFit.contain,
        // Listen for capture events - this fires when video is done
        onMediaCaptureEvent: (event) {
          // Only auto-save when capture is successful and auto-save is enabled
          if (event.status == MediaCaptureStatus.success && _autoSaveEnabled) {
            final filePath = event.captureRequest.when(
              single: (single) => single.file?.path,
              multiple: (multiple) => multiple.fileBySensor.values.first?.path,
            );

            // Prevent duplicate saves and add small delay to let camera settle
            if (filePath != null && filePath != _lastSavedPath && !_isSaving) {
              _lastSavedPath = filePath;
              // Use post-frame callback to avoid interfering with camera state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _autoSaveToGallery(filePath);
              });
            }
          }
        },
        // Manual save when tapping thumbnail (when auto-save is off)
        onMediaTap: (mediaCapture) {
          if (!_autoSaveEnabled) {
            _manualSaveToGallery(mediaCapture);
          }
        },
        // Show instructions at top
        topActionsBuilder: (state) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: state.when(
              onVideoMode: (_) => _buildInstruction(
                _autoSaveEnabled
                    ? 'Tap red button to record - Auto-saves when stopped'
                    : 'Tap red button to record',
              ),
              onVideoRecordingMode: (_) => _buildRecordingIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isSaving ? 'SAVING...' : 'RECORDING',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _autoSaveToGallery(String filePath) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final result = await ImageGallerySaver.saveFile(
        filePath,
        name: 'ProtestersOath_${DateTime.now().millisecondsSinceEpoch}',
      );

      final bool success = result['isSuccess'] == true;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(success ? 'Video saved to Camera Roll!' : 'Failed to save video'),
              ],
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _manualSaveToGallery(MediaCapture mediaCapture) async {
    final filePath = mediaCapture.captureRequest.when(
      single: (single) => single.file?.path,
      multiple: (multiple) => multiple.fileBySensor.values.first?.path,
    );

    if (filePath == null) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final result = await ImageGallerySaver.saveFile(
        filePath,
        name: 'ProtestersOath_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      final bool success = result['isSuccess'] == true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(success ? 'Video saved to Camera Roll!' : 'Failed to save video'),
              ],
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
