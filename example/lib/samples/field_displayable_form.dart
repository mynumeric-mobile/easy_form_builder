import 'dart:convert';

import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/classes/objects/validator/email_validator.dart';
import 'package:easy_form_builder/classes/objects/validator/required_validator.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';

class FieldDisplayableForm extends StatefulWidget {
  const FieldDisplayableForm({super.key});

  @override
  State<FieldDisplayableForm> createState() => _MyAppState();
}

class _MyAppState extends State<FieldDisplayableForm> {
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
                      id: "firstName",
                      icon: Icon(Icons.person),
                      type: String,
                      title: "FirstName",
                    ),
                    DfCfgParam(
                      id: "lastName",
                      icon: Icon(Icons.groups),
                      type: String,
                      title: "LastName",
                    ),
                    DfCfgParam(
                      id: "displayEmail",
                      type: bool,
                      title: "With email",
                      defaultValue: false,
                    ),
                    DfCfgParam(
                        id: "email",
                        icon: Icon(Icons.email),
                        type: String,
                        title: "Email",
                        validators: [RequiredValidator(), EmailValidator()],
                        isDisplayable: (values) {
                          return values["displayEmail"];
                        })
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
