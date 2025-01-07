import 'package:easy_form_builder_example/samples/colorpicker.dart';
import 'package:easy_form_builder_example/samples/dropdownlist.dart';
import 'package:easy_form_builder_example/samples/linked_dropdownlist.dart';
import 'package:easy_form_builder_example/samples/objectProperties.dart';
import 'package:flutter/material.dart';

import 'samples/field_displayable_form.dart';
import 'samples/simple_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> values = {};
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => const SimpleForm()));
                },
                child: const Text("Simple form"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute<void>(builder: (BuildContext context) => const FieldDisplayableForm()));
                },
                child: const Text("On the fly hidding field"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => const DropDownList()));
                },
                child: const Text("Dropdown list"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => const LinkedDropDownList()));
                },
                child: const Text("Linked Dropdown List"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => const ObjectProperties()));
                },
                child: const Text("Generic object properties"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => const ColorPicker()));
                },
                child: const Text("Color Picker"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
