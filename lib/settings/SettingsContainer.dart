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
    return prefs.getString('storiesConfig') ?? 'rss'; // default to RSS
  }

  static Future<bool> getAutoSaveVideo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('autoSaveVideo') ?? true; // default to true
  }

  static Future<bool> getProtestsCompactMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('protestsCompactMode') ?? false;
  }

  static Future<bool> getDisableRssFeedCache() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true in debug mode, false otherwise
    bool defaultValue = false;
    assert(() {
      defaultValue = true;
      return true;
    }());
    return prefs.getBool('disableRssFeedCache') ?? defaultValue;
  }

  static Future<bool> getMenuBackOpensDrawer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('menuBackOpensDrawer') ?? false; // default to false
  }

  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String _menuConfig = 'homeOnly';
  String _storiesConfig = 'rss'; // default to RSS
  bool _autoSaveVideo = true; // default to true
  bool _protestsCompactMode = false;
  bool _disableRssFeedCache = false;
  bool _menuBackOpensDrawer = false; // default to false

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    bool defaultDisableCache = false;
    assert(() {
      defaultDisableCache = true;
      return true;
    }());
    setState(() {
      _menuConfig = prefs.getString('menuConfig') ?? 'homeOnly';
      _storiesConfig =
          prefs.getString('storiesConfig') ?? 'rss'; // default to RSS
      _autoSaveVideo =
          prefs.getBool('autoSaveVideo') ?? true; // default to true
      _protestsCompactMode = prefs.getBool('protestsCompactMode') ?? false;
      _disableRssFeedCache =
          prefs.getBool('disableRssFeedCache') ?? defaultDisableCache;
      _menuBackOpensDrawer =
          prefs.getBool('menuBackOpensDrawer') ?? false; // default to false
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

  Future<void> _saveMenuBackOpensDrawer(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('menuBackOpensDrawer', value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Menu Configuration',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        _buildRadioGroup(
          groupValue: _menuConfig,
          onChanged: (value) {
            setState(() => _menuConfig = value);
            _saveMenuConfig(value);
          },
          options: const [
            {
              'label': "Menu on 'Proof of Oath' screen only",
              'value': 'homeOnly'
            },
            {'label': "Menu on all screens", 'value': 'allScreens'},
            {
              'label': "Buttons only on 'Proof of Oath' screen",
              'value': 'buttonsOnly'
            },
          ],
        ),
        SwitchListTile(
          title: const Text("Back button opens menu on home"),
          subtitle: const Text(
              "When enabled, pressing back navigates to home with the menu open."),
          value: _menuBackOpensDrawer,
          onChanged: (value) {
            setState(() => _menuBackOpensDrawer = value);
            _saveMenuBackOpensDrawer(value);
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Stories Configuration',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SwitchListTile(
          title: const Text('Stories from RSS feed'),
          subtitle: const Text(
              'Toggle on to load stories from RSS feed, off for stories installed with app'),
          value: _storiesConfig == 'rss',
          onChanged: (value) {
            setState(() => _storiesConfig = value ? 'rss' : 'installed');
            _saveStoriesConfig(value ? 'rss' : 'installed');
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Camera Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SwitchListTile(
          title: const Text('Auto-save videos to Camera Roll'),
          subtitle:
              const Text('Automatically save videos when you stop recording'),
          value: _autoSaveVideo,
          onChanged: (value) {
            setState(() => _autoSaveVideo = value);
            _saveAutoSaveVideo(value);
          },
        ),
        Divider(),
        if (kDebugMode)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text('Development Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        if (kDebugMode)
          SwitchListTile(
            title: const Text('Disable RSS Feed Caching'),
            subtitle: const Text(
                'Always fetch RSS feed from the network (development only)'),
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
