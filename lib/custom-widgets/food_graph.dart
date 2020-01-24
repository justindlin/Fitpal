import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/database/food.dart';

class FoodGraph extends StatelessWidget {

  Widget build(BuildContext context) {

    return FutureBuilder(
      future:getCalories(),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done)
          return Container();
        List<charts.Series<Food, DateTime>> series = [
          new charts.Series<Food, DateTime> (
            id: 'Food',
            colorFn: (_,__) => charts.MaterialPalette.gray.shadeDefault,
            domainFn: (Food food, _) => food.datetime,
            measureFn: (Food food, _) => food.calorieIntake,
            data: snapshot.data,
          )..setAttribute(charts.rendererIdKey, 'customPointRenderer'),
        ];

        return Container (
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
            behaviors: [
              new charts.ChartTitle('Date',
              behaviorPosition: charts.BehaviorPosition.bottom,
              ),
              new charts.ChartTitle('Calories',
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