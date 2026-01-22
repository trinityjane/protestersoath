import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

enum CaptureMode { photo, video }

enum _CameraInitState { loading, ready, permissionDenied, error }

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIdx = 0;
  CaptureMode _mode = CaptureMode.video;
  bool _isRecording = false;
  bool _isSaving = false;
  Orientation? _lockedOrientation;
  _CameraInitState _cameraInitState = _CameraInitState.loading;
  String? _cameraErrorMessage;
  bool _permissionPermanentlyDenied = false;
  bool _dialogShown = false;

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
    setState(() {
      _cameraInitState = _CameraInitState.loading;
      _cameraErrorMessage = null;
      _permissionPermanentlyDenied = false;
    });
    await _controller?.dispose();
    _controller = null;
    try {
      _cameras = await availableCameras();
      debugPrint(
          '[CameraPage] _initCamera: found [32m${_cameras.length}[0m cameras');
      if (_cameras.isNotEmpty) {
        await _onNewCameraSelected(_cameras[_selectedCameraIdx]);
      } else {
        debugPrint('[CameraPage] _initCamera: No cameras found');
        setState(() {
          _cameraInitState = _CameraInitState.error;
          _cameraErrorMessage = 'No cameras found on this device.';
        });
      }
    } on CameraException catch (e) {
      debugPrint('[CameraPage] _initCamera: CameraException: $e');
      bool isPermissionDenied = false;
      final codeStr = e.code.toString().toLowerCase();
      if (codeStr.contains('permissiondenied') ||
          codeStr.contains('notallowed')) {
        isPermissionDenied = true;
      } else if ((e.description?.toLowerCase() ?? '').contains('permission')) {
        isPermissionDenied = true;
      }
      if (isPermissionDenied) {
        setState(() {
          _cameraInitState = _CameraInitState.permissionDenied;
          _cameraErrorMessage = e.description ?? 'Camera permission denied.';
          _permissionPermanentlyDenied = true;
        });
      } else {
        setState(() {
          _cameraInitState = _CameraInitState.error;
          _cameraErrorMessage = e.description ?? 'Camera error.';
        });
      }
    } catch (e) {
      debugPrint('[CameraPage] _initCamera: Exception: $e');
      setState(() {
        _cameraInitState = _CameraInitState.error;
        _cameraErrorMessage = 'Error initializing camera: $e';
      });
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    await _controller?.dispose();
    _controller = null;
    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );
    try {
      await controller.initialize();
      debugPrint('[CameraPage] _onNewCameraSelected: controller initialized');
      if (mounted) {
        setState(() {
          _controller = controller;
          _cameraInitState = _CameraInitState.ready;
          debugPrint('[CameraPage] _onNewCameraSelected: set ready');
        });
      }
    } on CameraException catch (e) {
      await controller.dispose();
      debugPrint(
          '[CameraPage] CameraException caught: type=${e.code.runtimeType}, code=${e.code}, message=${e.description}');
      bool isPermissionDenied = false;
      final codeStr = e.code.toString().toLowerCase();
      if (codeStr.contains('permissiondenied') ||
          codeStr.contains('notallowed')) {
        isPermissionDenied = true;
      } else if ((e.description?.toLowerCase() ?? '').contains('permission')) {
        isPermissionDenied = true;
      }
      debugPrint(
          '[CameraPage] CameraException: isPermissionDenied=$isPermissionDenied');
      if (mounted) {
        setState(() {
          _controller = null;
          if (isPermissionDenied) {
            _cameraInitState = _CameraInitState.permissionDenied;
            _permissionPermanentlyDenied = true;
            debugPrint(
                '[CameraPage] _onNewCameraSelected: set permissionDenied (CameraException)');
          } else {
            _cameraInitState = _CameraInitState.error;
            _cameraErrorMessage = e.description ?? 'Camera error.';
            debugPrint(
                '[CameraPage] _onNewCameraSelected: set error (CameraException)');
          }
        });
      }
    } catch (e) {
      await controller.dispose();
      // Web-specific: CameraWebException with CameraErrorCode.permissionDenied
      bool isPermissionDenied = false;
      String errorType = e.runtimeType.toString();
      debugPrint('[CameraPage] Generic catch: errorType=$errorType, error=$e');
      try {
        // Try to access code property (for CameraWebException)
        final code = (e as dynamic).code?.toString()?.toLowerCase();
        debugPrint('[CameraPage] Web catch: code=$code');
        if (code != null && code.contains('permissiondenied')) {
          isPermissionDenied = true;
        }
      } catch (err) {
        debugPrint('[CameraPage] Web catch: error accessing code: $err');
      }
      debugPrint(
          '[CameraPage] Web catch: isPermissionDenied=$isPermissionDenied');
      if (mounted) {
        setState(() {
          _controller = null;
          if (isPermissionDenied) {
            _cameraInitState = _CameraInitState.permissionDenied;
            _permissionPermanentlyDenied = true;
            debugPrint(
                '[CameraPage] _onNewCameraSelected: set permissionDenied (web catch)');
          } else {
            _cameraInitState = _CameraInitState.error;
            _cameraErrorMessage = 'Camera error: $e';
            debugPrint('[CameraPage] _onNewCameraSelected: set error (catch)');
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint(
        '[CameraPage] didChangeDependencies: _cameraInitState=$_cameraInitState, _dialogShown=$_dialogShown');
    if (_cameraInitState == _CameraInitState.permissionDenied &&
        !_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint(
            '[CameraPage] didChangeDependencies: Showing permission denied dialog');
        _showPermissionDeniedDialog();
      });
    }
  }

  @override
  void didUpdateWidget(covariant CameraPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dialogShown = false;
    debugPrint('[CameraPage] didUpdateWidget: _dialogShown reset to false');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller?.dispose();
    _controller = null;
    _dialogShown = false;
    debugPrint('[CameraPage] dispose: _dialogShown reset to false');
    super.dispose();
  }

  void _showPermissionDeniedDialog() {
    debugPrint(
        '[CameraPage] _showPermissionDeniedDialog called. _dialogShown=$_dialogShown');
    if (_dialogShown) return;
    _dialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Camera Permission Required'),
          content: Text(
            'Camera access is required. Please enable camera permission in your device or browser settings and reload the app.',
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionDeniedUI() {
    // Show a gray rounded rectangle with instructions and an OK button
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: Colors.white70, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Camera Permission Required',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Camera access is required. Please enable camera permission in your device or browser settings and reload the app.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: const Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 64),
          SizedBox(height: 16),
          Text(_cameraErrorMessage ?? 'Camera error.',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isSaving)
      return;
    try {
      setState(() => _isSaving = true);
      final Directory extDir = await getTemporaryDirectory();
      final String filePath = p.join(
          extDir.path, 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final XFile file = await _controller!.takePicture();
      await file.saveTo(filePath);
      await GallerySaver.saveImage(filePath);
      if (_isRecording) {
        _showSaveSnackbar('Photo saved! Still recording video...', true,
            stillRecording: true);
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
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isRecording) return;
    try {
      // Lock orientation to current orientation while recording
      final orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]);
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
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        !_isRecording) return;
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

  void _showSaveSnackbar(String message, bool success,
      {bool stillRecording = false}) {
    final appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final double marginBottom = MediaQuery.of(context).size.height -
        appBarHeight -
        (stillRecording ? 240 : 215);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(success ? Icons.check_circle : Icons.error,
                    color: Colors.white),
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
    debugPrint(
        '[CameraPage] build: _cameraInitState=$_cameraInitState, _dialogShown=$_dialogShown');
    if (_cameraInitState == _CameraInitState.permissionDenied &&
        !_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('[CameraPage] build: Showing permission denied dialog');
        _showPermissionDeniedDialog();
      });
    }
    Widget bodyWidget;
    switch (_cameraInitState) {
      case _CameraInitState.loading:
        bodyWidget = const Center(child: CircularProgressIndicator());
        break;
      case _CameraInitState.permissionDenied:
        bodyWidget = _buildPermissionDeniedUI();
        break;
      case _CameraInitState.error:
        bodyWidget = _buildErrorUI();
        break;
      case _CameraInitState.ready:
        bodyWidget = (_controller == null || !_controller!.value.isInitialized)
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final previewSize = _controller!.value.previewSize;
                      if (previewSize == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final orientation =
                          _isRecording && _lockedOrientation != null
                              ? _lockedOrientation!
                              : MediaQuery.of(context).orientation;
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
                      bottom: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 32
                          : 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
              );
        break;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Camera'),
      ),
      body: bodyWidget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _cameraInitState == _CameraInitState.ready
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cameraswitch,
                        color: Colors.white, size: 36),
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
                              ? const Icon(Icons.stop,
                                  color: Colors.white, size: 40)
                              : _mode == CaptureMode.photo
                                  ? const Icon(Icons.camera_alt,
                                      color: Colors.black, size: 40)
                                  : const Icon(Icons.videocam,
                                      color: Colors.red, size: 40),
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
                        _mode =
                            idx == 0 ? CaptureMode.photo : CaptureMode.video;
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
            )
          : null,
    );
  }
}
