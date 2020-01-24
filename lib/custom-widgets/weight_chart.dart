import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/database/weight.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeightChart extends StatelessWidget {

  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: getWeights(),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done)
          return Container();
        List<charts.Series<Weight, DateTime>> series = [
          new charts.Series<Weight, DateTime>(
            id: 'Weights',
            colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
            domainFn: (Weight weight, _) => weight.datetime,
            measureFn: (Weight weight, _) => weight.weight,
            data: snapshot.data,
          )..setAttribute(charts.rendererIdKey, 'customPointRenderer'),
        ];

        // container for the graphs 
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          child: charts.TimeSeriesChart(
            series,
            defaultRenderer: new charts.LineRendererConfig(),
            customSeriesRenderers: [
              new charts.LineRendererConfig(
                customRendererId: 'customPointRenderer',
                includePoints: true,
                radiusPx: 4,
              ),
            ],
            // title of the axises
            behaviors: [
              new charts.ChartTitle('Date',
              behaviorPosition: charts.BehaviorPosition.bottom,
              ),
              new charts.ChartTitle('Weight (lbs)',
              behaviorPosition: charts.BehaviorPosition.start,
              ),
            ],
            primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.GridlineRendererSpec(),
              showAxisLine: true,
            ),
            domainAxis: new charts.DateTimeAxisSpec(
                tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                  day: new charts.TimeFormatterSpec(
                    format: 'dd',
                    transitionFormat: 'dd MMM',
                  ),
              ),
              renderSpec: new charts.GridlineRendererSpec(),
              showAxisLine: true,
            ),
          ),
        );
      }
    );
  }
}

