import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

enum CaptureMode { photo, video }

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIdx = 0;
  CaptureMode _mode = CaptureMode.video;
  bool _isRecording = false;
  bool _isSaving = false;
  Orientation? _lockedOrientation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _onNewCameraSelected(_cameras[_selectedCameraIdx]);
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    final oldController = _controller;
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await oldController?.dispose();
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isSaving) return;
    try {
      setState(() => _isSaving = true);
      final Directory extDir = await getTemporaryDirectory();
      final String filePath = p.join(extDir.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final XFile file = await _controller!.takePicture();
      await file.saveTo(filePath);
      await GallerySaver.saveImage(filePath);
      if (_isRecording) {
        _showSaveSnackbar('Photo saved! Still recording video...', true, stillRecording: true);
      } else {
        _showSaveSnackbar('Photo saved to Camera Roll!', true);
      }
    } catch (e) {
      _showSaveSnackbar('Failed to save photo', false);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || _isRecording) return;
    try {
      // Lock orientation to current orientation while recording
      final orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } else {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      // Small delay to ensure orientation lock takes effect
      await Future.delayed(const Duration(milliseconds: 100));
      // Lock the orientation at the start of recording
      _lockedOrientation = MediaQuery.of(context).orientation;
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      _showSaveSnackbar('Failed to start recording', false);
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || !_isRecording) return;
    try {
      final XFile file = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _lockedOrientation = null;
      });
      // Restore all orientations after recording stops
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await GallerySaver.saveVideo(file.path);
      _showSaveSnackbar('Video saved to Camera Roll!', true);
    } catch (e) {
      _showSaveSnackbar('Failed to save video', false);
    }
  }

  void _showSaveSnackbar(String message, bool success, {bool stillRecording = false}) {
    final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final double marginBottom = MediaQuery.of(context).size.height - appBarHeight - (stillRecording ? 240 : 215);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(message)),
              ],
            ),
            if (stillRecording) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Still Recording',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: marginBottom,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  void _switchCamera() async {
    if (_cameras.length < 2) return;
    _selectedCameraIdx = (_selectedCameraIdx + 1) % _cameras.length;
    await _onNewCameraSelected(_cameras[_selectedCameraIdx]);
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
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final previewSize = _controller!.value.previewSize;
                    if (previewSize == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Use locked orientation if recording, otherwise current
                    final orientation = _isRecording && _lockedOrientation != null
                        ? _lockedOrientation!
                        : MediaQuery.of(context).orientation;
                    // Camera preview size is always in landscape (width > height)
                    // In portrait mode, we swap the dimensions
                    final double previewWidth;
                    final double previewHeight;
                    if (orientation == Orientation.portrait) {
                      previewWidth = previewSize.height;
                      previewHeight = previewSize.width;
                    } else {
                      previewWidth = previewSize.width;
                      previewHeight = previewSize.height;
                    }
                    return SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: previewWidth,
                          height: previewHeight,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    );
                  },
                ),
                // Show "Still Recording" indicator when in photo mode while recording video
                if (_isRecording && _mode == CaptureMode.photo)
                  Positioned(
                    bottom: MediaQuery.of(context).orientation == Orientation.portrait ? 32 : 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Still Recording Video',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 36),
              onPressed: _switchCamera,
            ),
            const SizedBox(width: 32),
            GestureDetector(
              onTap: _isSaving
                  ? null
                  : _mode == CaptureMode.photo
                      ? _takePhoto
                      : _isRecording
                          ? _stopVideoRecording
                          : _startVideoRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isRecording ? Colors.redAccent : Colors.white,
                    width: 4,
                  ),
                ),
                child: _isSaving
                    ? const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : _mode == CaptureMode.video && _isRecording
                        ? const Icon(Icons.stop, color: Colors.white, size: 40)
                        : _mode == CaptureMode.photo
                            ? const Icon(Icons.camera_alt, color: Colors.black, size: 40)
                            : const Icon(Icons.videocam, color: Colors.red, size: 40),
              ),
            ),
            const SizedBox(width: 32),
            ToggleButtons(
              borderRadius: BorderRadius.circular(24),
              selectedColor: Colors.white,
              fillColor: Colors.black45,
              color: Colors.white70,
              isSelected: [
                _mode == CaptureMode.photo,
                _mode == CaptureMode.video,
              ],
              onPressed: (idx) {
                setState(() {
                  _mode = idx == 0 ? CaptureMode.photo : CaptureMode.video;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.camera_alt),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.videocam),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
