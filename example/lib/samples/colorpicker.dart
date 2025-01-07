import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _MyAppState();
}

class _MyAppState extends State<ColorPicker> {
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
                  colorHistory: [Colors.blue, Colors.white, Colors.red],
                  params: [
                    DfCfgParam(
                      id: "color1",
                      type: Color,
                      title: "Simple color",
                      defaultValue: Colors.green,
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
                    debugPrint(values.values.first.toString());
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
