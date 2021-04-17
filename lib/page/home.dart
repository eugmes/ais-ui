import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ais_targets.dart';
import '../widget/ais_map.dart';
import '../widget/ais_target_list_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;

    return Row(
      children: [
        if (!displayMobileLayout)
          const AISTargetListDrawer(
            permanentDisplay: true,
          ),
        Expanded(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('AIS Map'),
              automaticallyImplyLeading: displayMobileLayout,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.wifi_tethering),
                  onPressed: () {
                    var handler = context.read<AISTargets>();
                    handler.run();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cleaning_services),
                  onPressed: () {
                    var handler = context.read<AISTargets>();
                    handler.clear();
                  },
                ),
              ],
            ),
            drawer: displayMobileLayout
                ? const AISTargetListDrawer(
                    permanentDisplay: false,
                  )
                : null,
            body: Column(
              children: [
                Flexible(
                  child: AISMap(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
