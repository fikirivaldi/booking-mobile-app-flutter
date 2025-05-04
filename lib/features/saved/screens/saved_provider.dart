import 'package:flutter/material.dart';
import '../../../models/property_model.dart';

class SavedProvider with ChangeNotifier {
  final List<Property> _savedProperties = [];

  List<Property> get saved => _savedProperties;

  void toggleSaved(Property property) {
    if (_savedProperties.any((p) => p.id == property.id)) {
      _savedProperties.removeWhere((p) => p.id == property.id);
    } else {
      _savedProperties.add(property);
    }
    notifyListeners();
  }

  bool isSaved(Property property) {
    return _savedProperties.any((p) => p.id == property.id);
  }
}
