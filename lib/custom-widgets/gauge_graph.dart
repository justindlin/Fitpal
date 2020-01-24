import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GaugeGraph extends StatelessWidget {

  double percent = 0;
  double pointerThickness = null;
  bool animate = false;
  String label;
  charts.Color color, auxColor, pointerColor;

  GaugeGraph(this.percent, this.label, this.color, {this.auxColor, this.pointerThickness, this.pointerColor});

  Widget build(BuildContext context) {
    return charts.PieChart(
      createData(),
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 10,
        startAngle: 4/5 * pi,
        arcLength: 7/5 * pi,
      ),
    );
  }

  List<charts.Series<GaugeSegment, String>> createData() {

    if(auxColor == null) auxColor = charts.Color.fromHex(code: "#dbdad5");
    if(pointerColor == null) pointerColor = charts.Color.fromHex(code: "#111111");

    List<GaugeSegment> data;

    if(pointerThickness == null) {
      data = [
        GaugeSegment(label, percent, color),
        GaugeSegment("", 100-percent, auxColor),
      ];
    }

    else {
      data = [
        GaugeSegment(label, percent-(pointerThickness/2), color),
        GaugeSegment("Pointer", pointerThickness, pointerColor),
        GaugeSegment("", 100-percent-(pointerThickness/2), auxColor),
      ];
    }

    return [
      new charts.Series<GaugeSegment, String>(
        id: "Segments",
        domainFn: (segment, _) => segment.segment,
        measureFn: (segment, _) => segment.size,
        colorFn: (segment, _) => segment.color,
        data: data,
      ),
    ];
  }

}

class GaugeSegment {
  String segment;
  double size;
  charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}