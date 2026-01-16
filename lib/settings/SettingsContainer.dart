import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer extends StatefulWidget {
  static Future<String> getMenuConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('menuConfig') ?? 'homeOnly';
  }

  static Future<String> getStoriesConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('storiesConfig') ?? 'installed';
  }

  static Future<bool> getAutoSaveVideo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('autoSaveVideo') ?? false;
  }

  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String _menuConfig = 'homeOnly';
  String _storiesConfig = 'installed';
  bool _autoSaveVideo = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _menuConfig = prefs.getString('menuConfig') ?? 'homeOnly';
      _storiesConfig = prefs.getString('storiesConfig') ?? 'installed';
      _autoSaveVideo = prefs.getBool('autoSaveVideo') ?? false;
    });
  }

  Future<void> _saveMenuConfig(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('menuConfig', value);
  }

  Future<void> _saveStoriesConfig(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('storiesConfig', value);
  }

  Future<void> _saveAutoSaveVideo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSaveVideo', value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Menu Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        _buildRadioGroup(
          groupValue: _menuConfig,
          onChanged: (value) {
            setState(() => _menuConfig = value);
            _saveMenuConfig(value);
          },
          options: const [
            {'label': "Menu on 'Proof of Oath' screen only", 'value': 'homeOnly'},
            {'label': "Menu on all screens", 'value': 'allScreens'},
            {'label': "Buttons only on 'Proof of Oath' screen", 'value': 'buttonsOnly'},
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Stories Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        _buildRadioGroup(
          groupValue: _storiesConfig,
          onChanged: (value) {
            setState(() => _storiesConfig = value);
            _saveStoriesConfig(value);
          },
          options: const [
            {'label': "Stories installed with app", 'value': 'installed'},
            {'label': "Stories from RSS feed", 'value': 'rss'},
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Camera Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SwitchListTile(
          title: const Text('Auto-save videos to Camera Roll'),
          subtitle: const Text('Automatically save videos when you stop recording'),
          value: _autoSaveVideo,
          onChanged: (value) {
            setState(() => _autoSaveVideo = value);
            _saveAutoSaveVideo(value);
          },
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String groupValue,
    required void Function(String) onChanged,
    required List<Map<String, String>> options,
  }) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option['label']!),
          value: option['value']!,
          groupValue: groupValue,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        );
      }).toList(),
    );
  }
}
