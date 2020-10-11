import 'package:flutter/widgets.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../model/ais_targets.dart';

class AISTargetsPluginOptions extends LayerOptions {
  AISTargetsPluginOptions({Key key, rebuild})
      : super(key: key, rebuild: rebuild);
}

class AISTargetsPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is AISTargetsPluginOptions) {
      return AISTargetsLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for AISTargetsPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AISTargetsPluginOptions;
  }
}

class AISTargetsLayer extends StatelessWidget {
  final AISTargetsPluginOptions layerOpts;
  final MapState map;
  final Stream<Null> stream;

  AISTargetsLayer(this.layerOpts, this.map, this.stream)
      : super(key: layerOpts.key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Consumer<AISTargets>(
            builder: (BuildContext context, AISTargets targets, _) {
              var targetMarkers = <Widget>[];

              for (var mmsi in targets.targetMMSIs) {
                targetMarkers.add(ChangeNotifierProvider.value(
                  value: targets.getState(mmsi),
                  child: TargetWidget(key: Key(mmsi.toString()), map: map),
                ));
              }
              return Container(
                child: Stack(
                  children: targetMarkers,
                ),
              );
            },
          );
        });
  }
}

class TargetWidget extends StatelessWidget {
  static const double markerSize = 10.0;
  final MapState map;

  TargetWidget({Key key, @required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AISTargetState>(
      builder: (BuildContext context, AISTargetState target, _) {
        if (target.pcs == null) {
          return Positioned(
            width: 0,
            height: 0,
            left: 0,
            top: 0,
            child: Container(),
          );
        }

        LatLng point = LatLng(target.pcs.lat, target.pcs.lon);
        var pos = map.project(point);
        pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
            map.getPixelOrigin();
        var pixelPosX = (pos.x - markerSize / 2).toDouble();
        var pixelPosY = (pos.y - markerSize / 2).toDouble();

        return Positioned(
          width: markerSize,
          height: markerSize,
          left: pixelPosX,
          top: pixelPosY,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: FlutterGradients.sharpBlues(
                  type: GradientType.radial,
                  center: Alignment.center,
                  radius: 1,
                  tileMode: TileMode.clamp),
            ),
          ),
        );
      },
    );
  }
}
