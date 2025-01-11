import 'dart:convert';

import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';

import '../objects/car.dart';

class LinkedDropDownList extends StatefulWidget {
  const LinkedDropDownList({super.key});

  @override
  State<LinkedDropDownList> createState() => _MyAppState();
}

class _MyAppState extends State<LinkedDropDownList> {
  Map<String, dynamic> values = {};
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
                      dataSource: DfSource(
                        id: "types",
                        values: Brands.values
                            .elementAt(values["brand"] ?? 0)
                            .modelsList
                            .asMap()
                            .map<int, String>((i, e) => MapEntry(i, e.name)),
                      ),
                    ),
                  ],
                  paramValues: values,
                  icon: true,
                  forcedColumnNumber: (MediaQuery.of(context).size.width / 400).round(),
                  onChange: (modifiedParamId) {
                    setState(() {});
                  },
                ),
              ),
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
