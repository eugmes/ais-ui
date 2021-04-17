import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../plugin/scale_buttons_plugin.dart';
import '../plugin/scale_layer_plugin.dart';
import '../plugin/ais_targets_plugin.dart';

class AISMap extends StatelessWidget {
  const AISMap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(59.894891, 10.677920),
        zoom: 13.0,
        plugins: [
          AISTargetsPlugin(),
          ScaleLayerPlugin(),
          ZoomButtonsPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        AISTargetsPluginOptions(),
        ScaleLayerPluginOptions(
          lineColor: Colors.blue,
          lineWidth: 2,
          textStyle: TextStyle(color: Colors.blue, fontSize: 12),
          padding: EdgeInsets.all(10),
        ),
        ZoomButtonsPluginOptions(
          minZoom: 3,
          maxZoom: 19,
          mini: true,
          padding: 10,
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}
