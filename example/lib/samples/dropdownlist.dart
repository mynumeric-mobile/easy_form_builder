import 'dart:convert';

import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({super.key});

  @override
  State<DropDownList> createState() => _MyAppState();
}

class _MyAppState extends State<DropDownList> {
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
                  params: [
                    DfCfgParam(
                      type: String,
                      id: "department",
                      title: "From MAP",
                      defaultValue: "11",
                      dataSource: DfSource(
                          id: "geographical_zone", values: {"v1": "Fisrt value", "v2": "Second value", "v3": "Third value"}),
                    ),
                    DfCfgParam(
                      type: int,
                      id: "template",
                      title: "From string",
                      defaultValue: 0,
                      dataSource: DfSource(
                        id: "templates",
                        values: "My first choice,My second choice,The third one".split(",").asMap(),
                      ),
                    ),
                    DfCfgParam(
                      type: String,
                      id: "fontFamily",
                      title: "Font family",
                      defaultValue: "Roboto",
                      dataSource: DfSource(id: "fontFamily", values: {
                        "Acrobat": "Acrobat",
                        "AcrobatFilled": "AcrobatFilled",
                        "Agne": "Agne",
                        "Awesome solid": "Awesome solid",
                        "BagelFatOne-Regular": "BagelFatOne-Regular",
                      })
                        ..fontFamilyMode = true,
                    ),
                  ],
                  paramValues: values,
                  icon: true,
                  forcedColumnNumber: (MediaQuery.of(context).size.width / 400).round(),
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
