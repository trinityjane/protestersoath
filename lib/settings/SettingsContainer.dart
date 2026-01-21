import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  static Future<bool> getProtestsCompactMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('protestsCompactMode') ?? false;
  }

  static Future<bool> getDisableRssFeedCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('disableRssFeedCache') ?? false;
  }

  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String _menuConfig = 'homeOnly';
  String _storiesConfig = 'installed';
  bool _autoSaveVideo = false;
  bool _protestsCompactMode = false;
  bool _disableRssFeedCache = false;

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
      _protestsCompactMode = prefs.getBool('protestsCompactMode') ?? false;
      _disableRssFeedCache = prefs.getBool('disableRssFeedCache') ?? false;
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

  Future<void> _saveProtestsCompactMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('protestsCompactMode', value);
  }

  Future<void> _saveDisableRssFeedCache(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disableRssFeedCache', value);
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
        SwitchListTile(
          title: const Text('Stories from RSS feed'),
          subtitle: const Text('Toggle on to load stories from RSS feed, off for stories installed with app'),
          value: _storiesConfig == 'rss',
          onChanged: (value) {
            setState(() => _storiesConfig = value ? 'rss' : 'installed');
            _saveStoriesConfig(value ? 'rss' : 'installed');
          },
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
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Upcoming Protests Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SwitchListTile(
          title: const Text('Show protests as compact list'),
          subtitle: const Text('Toggle between compact list and full content cards for upcoming protests'),
          value: _protestsCompactMode,
          onChanged: (value) {
            setState(() => _protestsCompactMode = value);
            _saveProtestsCompactMode(value);
          },
        ),
        Divider(),
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text('Development Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        if (kDebugMode)
          SwitchListTile(
            title: const Text('Disable RSS Feed Caching'),
            subtitle: const Text('Always fetch RSS feed from the network (development only)'),
            value: _disableRssFeedCache,
            onChanged: (value) {
              setState(() => _disableRssFeedCache = value);
              _saveDisableRssFeedCache(value);
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
