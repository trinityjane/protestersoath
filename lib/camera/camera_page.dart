import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

/// Simple in-app camera screen that supports video recording and photo capture.
/// Media is automatically saved to Camera Roll when captured.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isSaving = false;
  String? _lastSavedPath;

  @override
  void initState() {
    super.initState();
  }

  Future<CaptureRequest> _mediaPathBuilder(List<Sensor> sensors, {bool isVideo = true}) async {
    final Directory dir = await getTemporaryDirectory();
    final Directory outDir =
        await Directory('${dir.path}/protestersoath').create(recursive: true);
    final String baseName =
        'protesters_oath_${DateTime.now().millisecondsSinceEpoch}';
    final String extension = isVideo ? 'mp4' : 'jpg';

    if (sensors.length == 1) {
      return SingleCaptureRequest(
        '${outDir.path}/$baseName.$extension',
        sensors.first,
      );
    }

    return MultipleCaptureRequest({
      for (final sensor in sensors)
        sensor: '${outDir.path}/${baseName}_${sensor.deviceId ?? sensor.hashCode}.$extension',
    });
  }

  Future<CaptureRequest> _videoPathBuilder(List<Sensor> sensors) async {
    return _mediaPathBuilder(sensors, isVideo: true);
  }

  Future<CaptureRequest> _photoPathBuilder(List<Sensor> sensors) async {
    return _mediaPathBuilder(sensors, isVideo: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Camera'),
      ),
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photoAndVideo(
          photoPathBuilder: _photoPathBuilder,
          videoPathBuilder: _videoPathBuilder,
          initialCaptureMode: CaptureMode.video,
        ),
        previewFit: CameraPreviewFit.contain,
        onMediaCaptureEvent: (event) {
          if (event.status == MediaCaptureStatus.success) {
            final filePath = event.captureRequest.when(
              single: (single) => single.file?.path,
              multiple: (multiple) => multiple.fileBySensor.values.first?.path,
            );

            if (filePath != null && filePath != _lastSavedPath && !_isSaving) {
              _lastSavedPath = filePath;
              _autoSaveToGallery(filePath);
            }
          }
        },
        onMediaTap: (mediaCapture) {
          if (mediaCapture.status == MediaCaptureStatus.success) {
            final filePath = mediaCapture.captureRequest.when(
              single: (single) => single.file?.path,
              multiple: (multiple) => multiple.fileBySensor.values.first?.path,
            );

            if (filePath != null && filePath != _lastSavedPath && !_isSaving) {
              _lastSavedPath = filePath;
              _autoSaveToGallery(filePath);
            }
          }
        },
        bottomActionsBuilder: (state) {
          return AwesomeBottomActions(
            state: state,
            left: AwesomeCameraSwitchButton(state: state),
            right: const SizedBox(width: 48),
          );
        },
      ),
    );
  }

  Future<void> _autoSaveToGallery(String filePath) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final isPhoto = filePath.toLowerCase().endsWith('.jpg') ||
                    filePath.toLowerCase().endsWith('.jpeg') ||
                    filePath.toLowerCase().endsWith('.png');

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
                Text(success
                    ? (isPhoto ? 'Photo saved to Camera Roll!' : 'Video saved to Camera Roll!')
                    : (isPhoto ? 'Failed to save photo' : 'Failed to save video')),
              ],
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 260,
              left: 16,
              right: 16,
            ),
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
}
