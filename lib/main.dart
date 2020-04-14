import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import  'dart:convert';


const  request = "https://api.hgbrasil.com/finance?format=json-cors&key=a21620a7";

Future<void> main() async {

  print( await getData());

 runApp(MaterialApp(
   home: Home(),
   theme: ThemeData(
     hintColor: Colors.amber,
     primaryColor: Colors.white,
     inputDecorationTheme: InputDecorationTheme(
       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
       hintStyle: TextStyle(color: Colors.amber)
     )
   ),
 ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
return json.decode(response.body)["results"]["currencies"];
}

class Home extends StatefulWidget {
  @override
  _HomeSate createState() => _HomeSate();
}

class _HomeSate extends State<Home>  {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){
    realController.text='';
    euroController.text = '';
    dolarController.text = '';
  }

  void _realChanged(String text){

    if(text.isEmpty){
      _clearAll();
      return ;
    }
     double real = double.parse(text);

     dolarController.text = (real/dolar).toStringAsFixed(2);
     euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return ;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);
    }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return ;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro)/dolar).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),


        builder: (context,snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:

            case ConnectionState.none:
              return Center(
                child: Text('Carregando os Daos...',
                  style: TextStyle(color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar os Dados!!",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {


                dolar = snapshot.data["USD"]["buy"];
                euro = snapshot.data["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolares", "US\$",dolarController,_dolarChanged),
                      Divider(),
                      buildTextField("Euros", "€",euroController,_euroChanged),

                    ],
                  ),
                );
              }
          }
        })
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController c, Function f){

    return  TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
      style: TextStyle(color: Colors.amber),
      onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal:true),
    );
  }



}