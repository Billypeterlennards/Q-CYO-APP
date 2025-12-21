import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final r=TextEditingController(),t=TextEditingController(),a=TextEditingController();
  String soil="sandy",crop="maize";
  Map? result;

  void predict() async {
    result = await ApiService.recommend({
      "rainfall": double.parse(r.text),
      "temperature": double.parse(t.text),
      "soil_type": soil,
      "crop_type": crop,
      "area": double.parse(a.text)
    });
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Q-CYO")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children:[
          TextField(controller:r,decoration:const InputDecoration(labelText:"Rainfall")),
          TextField(controller:t,decoration:const InputDecoration(labelText:"Temperature")),
          TextField(controller:a,decoration:const InputDecoration(labelText:"Area")),
          ElevatedButton(onPressed:predict, child:const Text("Predict")),
          if(result!=null) Text(result.toString())
        ]),
      ),
    );
  }
}
