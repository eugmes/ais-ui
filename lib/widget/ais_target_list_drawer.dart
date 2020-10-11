import 'package:ais_ui/model/ais_targets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AISTargetListDrawer extends StatelessWidget {
  final bool permanentDisplay;

  const AISTargetListDrawer({@required this.permanentDisplay, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var targets = Provider.of<AISTargets>(context, listen: true);

    return Drawer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    child: const Text('AIS Targets')
                ),
                for (var mmsi in targets.targetMMSIs)
                  ChangeNotifierProvider.value(
                    value: targets.getState(mmsi),
                    child: TargetTile(key: Key(mmsi.toString())),
                  )
              ],
            ),
          ),
          if (permanentDisplay) const VerticalDivider(width: 1)
        ],
      ),
    );
  }
}

class TargetTile extends StatelessWidget {
  TargetTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var target = Provider.of<AISTargetState>(context);

    return ListTile(
      leading: const Icon(Icons.directions_boat),
      title: Text(target.name ?? target.mmsi.toString()),
      subtitle: target.pcs == null ? null : Text(target.pcs.toString()),
      onTap: () {
        print("Tapped!");
      },
    );
  }
}
