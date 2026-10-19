import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoCacheService {

  Geocoding geo = Geocoding();

  static const _prefsKey = 'geo_cache';
  final Map<String, List<double>> _memory = {};
  bool _loaded = false;

  String _normalize(String address) => address.trim().toLowerCase();

  // Load saved cache from disk once
  Future<void> _load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        _memory[k] = (v as List).map((e) => (e as num).toDouble()).toList();
      });
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_memory));
  }

  /// Returns [lat, lng], or null if the address can't be resolved.
  Future<List<double>?> getLatLng(String address) async {
    await _load();
    final key = _normalize(address);

    // 1. cache hit: instant
    if (_memory.containsKey(key)) return _memory[key];

    // 2. cache miss: geocode, then store
    try {
      final results = await geo.locationFromAddress(address);
      if (results.isEmpty) return null;

      final coords = [results.first.latitude, results.first.longitude];
      _memory[key] = coords;
      await _save();
      return coords;
    } catch (e) {
      print('Error $e');
      return null; // not found, timeout, or no internet
    }
  }

  Future<void> clear() async {
    _memory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}