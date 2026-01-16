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
  Orientation? _recordingOrientation;
  double? _recordingAspectRatio;

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
      _showSaveSnackbar('Photo saved to Camera Roll!', true);
    } catch (e) {
      _showSaveSnackbar('Failed to save photo', false);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || _isRecording) return;
    try {
      // Save the orientation and aspect ratio at the start of recording
      final contextOrientation = MediaQuery.of(context).orientation;
      setState(() {
        _recordingOrientation = contextOrientation;
        _recordingAspectRatio = _controller!.value.aspectRatio;
      });
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
        _recordingOrientation = null;
        _recordingAspectRatio = null;
      });
      await GallerySaver.saveVideo(file.path);
      _showSaveSnackbar('Video saved to Camera Roll!', true);
    } catch (e) {
      _showSaveSnackbar('Failed to save video', false);
    }
  }

  void _showSaveSnackbar(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
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
          : Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
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
