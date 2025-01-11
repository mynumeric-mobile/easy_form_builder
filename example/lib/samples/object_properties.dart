import 'dart:convert';

import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';

import '../objects/car.dart';

class ObjectProperties extends StatefulWidget {
  const ObjectProperties({super.key});

  @override
  State<ObjectProperties> createState() => _MyAppState();
}

class _MyAppState extends State<ObjectProperties> {
  Map<String, dynamic> values = {};
  var formKey = GlobalKey<FormState>();
  late Car myCar;
  late Map<String, dynamic> jsonCar;

  @override
  void initState() {
    myCar = Car();
    jsonCar = myCar.toJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Plugin example app'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyFormBuilder(
                  formKey: formKey,
                  rowSpacing: 30,
                  params: [
                    DfCfgParam(
                      type: int,
                      id: "brand",
                      title: "Car brand",
                      defaultValue: 0,
                      dataSource:
                          DfSource(id: "brands", values: Brands.values.asMap().map<int, String>((i, e) => MapEntry(i, e.name))),
                    ),
                    DfCfgParam(
                      type: int,
                      id: "type",
                      title: "Type",
                      defaultValue: 0,
                      dataSource: DfSource(
                        id: "types",
                        values: Brands.values
                            .elementAt(jsonCar["brand"] ?? 0)
                            .modelsList
                            .asMap()
                            .map<int, String>((i, e) => MapEntry(i, e.name)),
                      ),
                    ),
                  ],
                  paramValues: jsonCar,
                  icon: true,
                  forcedColumnNumber: (MediaQuery.of(context).size.width / 400).round(),
                  onChange: (modifiedParamId) {
                    setState(() {
                      myCar = Car.fromJson(jsonCar);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("My car is : $myCar"),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    debugPrint(json.encode(values));
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
