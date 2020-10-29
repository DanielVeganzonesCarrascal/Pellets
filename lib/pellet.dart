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

  Future<String> consultar() async {
    print("lanza la consulta");
    var respuesta = await http.get("http://192.168.42.108:8008/hello/");

    // sample info available in response
    int statusCode = respuesta.statusCode;
    Map<String, String> headers = respuesta.headers;
    String contentType = headers['content-type'];
    String js = respuesta.body;
    print(statusCode.toString() + "\n" + headers.toString() + "\n" +
        js.toString());
    print(respuesta.toString());
    return js;
  }


  pelletState(){
    print("constructor");
    var s = consultar().then((x) {
      setState(() {
        objeto = json.decode(x);
      });
    });
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
            height:20,
            thickness:5,
            indent:20,
            endIndent:0,
          ),

          Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: double.parse(objeto['tempMax'].toString()),
                          ranges: <GaugeRange>[
                            GaugeRange(startValue: 0, endValue: 15, color:Colors.blue),
                            GaugeRange(startValue: 15,endValue: 30,color: Colors.green),
                            GaugeRange(startValue: 30,endValue: 35,color: Colors.orange),
                            GaugeRange(startValue: 35,endValue: 100,color: Colors.red)],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: double.parse(objeto['estado']['temp'].toString()))],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(widget: Container(child:
                            Text(objeto['estado']['temp'].toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                angle: 90, positionFactor: 0.5
                            )]
                      )])
              ]

          ),




        ]
    );
  }
}
