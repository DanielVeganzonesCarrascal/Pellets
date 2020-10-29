import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                if (cierto)
                  Icon(Icons.check_circle,
                      size: 200,
                      color: Colors.green)
                else
                  Icon(Icons.error,
                      size: 200,
                      color: Colors.red)
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
                Container(
                  width: 370,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                  ),child:
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'http page',
                  ),
                ),
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

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white10,
                    ),
                    child: FlatButton(
                        onPressed: click,
                        child:Text("Check"))
                )
              ]
          )
        ]
    );
  }
}
