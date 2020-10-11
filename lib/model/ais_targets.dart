import 'package:ais/ais.dart';
import 'package:flutter/cupertino.dart';

/// State of an AIS target.
class AISTargetState with ChangeNotifier {
  /// Maritime Mobile Service Identity.
  ///
  /// This is a number that uniquely identifies the target.
  final int mmsi;
  String _name;
  PCS _pcs;

  AISTargetState({@required this.mmsi, name, pcs})
      : _name = name,
        _pcs = pcs;

  /// A readable name of the target.
  ///
  /// This property may be [null] if the name is not known.
  String get name => _name;

  set name(String newValue) {
    _name = newValue;
    notifyListeners();
  }

  PCS get pcs => _pcs;

  set pcs(PCS newValue) {
    _pcs = newValue;
    notifyListeners();
  }
}

class AISTargets extends AISHandler with ChangeNotifier {
  final Map<int, AISTargetState> _targets = {};

  // FIXME
  AISTargets() : super('127.0.0.1', 6667);

  Iterable<int> get targetMMSIs => _targets.keys;

  AISTargetState getState(int mmsi) => _targets[mmsi];

  @override
  void they(PCS them, int mmsi) {
    var target = _targets[mmsi];
    if (target != null) {
      target.pcs = them;
    } else {
      _addTarget(mmsi, AISTargetState(mmsi: mmsi, pcs: them));
    }
  }

  @override
  void nameFor(int mmsi, String shipName) {
    var target = _targets[mmsi];
    if (target != null) {
      target.name = shipName;
    } else {
      _addTarget(mmsi, AISTargetState(mmsi: mmsi, name: shipName));
    }
  }

  void _addTarget(int mmsi, AISTargetState state) {
    _targets[mmsi] = state;
    notifyListeners();
  }

  void clear() {
    _targets.clear();
    notifyListeners();
  }
}
