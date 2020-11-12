import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class pellet extends StatefulWidget{
  @override
  pelletState createState(){
    print("CreateState pellet");
    return new pelletState();
  }
}

class pelletState extends State<pellet> {

  TextEditingController _controller = TextEditingController();

  @override
  var objeto;
  var tempMax;
  var tempIdeal;
  var tempActual;
  var actual;

  pelletState(){
    print("constructor");
    consultar().then((x) {
      setState(() {
        objeto = json.decode(x);
        tempMax=double.parse(objeto['tempMax'].toString());
        tempIdeal=double.parse(objeto['tempIdeal'].toString());
        tempActual=double.parse(objeto['estado']['temp'].toString());
      });
    });
  }

  Future<String> consultar() async {
    print("lanza la consulta");
    var respuesta = await http.get("http://192.168.42.108:8008/hello/");
    // sample info available in response
    String js = respuesta.body;
    return js;
  }


  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(objeto['nombre'].toString() +  '  ' + objeto['release'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold,
                                       fontSize:50)

    )
              ]
          ),

          const Divider(
            color: Colors.white10,
            height:70,
            thickness:5,
            indent:20,
            endIndent:0,
          ),

          Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: tempMax,
                          ranges: <GaugeRange>[
                            GaugeRange(startValue: 0, endValue: tempIdeal-5.0, color:Colors.blue),
                            GaugeRange(startValue: tempIdeal-5.0,endValue: tempIdeal+5.0,color: Colors.green),
                            GaugeRange(startValue: tempIdeal+5.0,endValue: 35,color: Colors.yellow),
                            GaugeRange(startValue: 35,endValue: 40,color: Colors.orange),
                            if(tempMax>40) GaugeRange(startValue: 40,endValue: 100,color: Colors.red)],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: tempActual)],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(widget: Container(child:
                            Text(tempActual.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                angle: 90, positionFactor: 0.5
                            )]
                      )]),

              ]
          ),

          const Divider(
            color: Colors.white10,
            height:10,
            thickness:5,
            indent:20,
            endIndent:0,
          ),


          Row(mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.red[700],
                    inactiveTickMarkColor: Colors.red[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.redAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                    child: Slider(
                            value: tempActual,
                            min: 0,
                            max: tempMax,
                            divisions: 120,
                            label: tempActual.round().toString(),
                            onChanged: (double value) {
                            setState(() {
                            tempActual = value;
                            tempActual= double.parse(tempActual.toStringAsFixed(1));
                             });
                           },
                    )
                 )
              ]
          ),

          const Divider(
            color: Colors.white10,
            height:10,
            thickness:5,
            indent:20,
            endIndent:0,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(onPressed: () {
                setState(() {
                  objeto['estado']['temp']=tempActual;
                  actual = json.encode(objeto);
                  http.get("http://192.168.42.108:8008/set/"+ actual + "/");
                });
              },
                child: Text(
                  "Confirmar",
                ),
              )
            ]
          )
        ]
    );
  }
}
