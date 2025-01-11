import 'dart:convert';
import 'dart:math';

import 'package:easy_form_builder/classes/objects/df_param.dart';
import 'package:easy_form_builder/classes/objects/validator/email_validator.dart';
import 'package:easy_form_builder/classes/objects/validator/required_validator.dart';
import 'package:easy_form_builder/easy_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

import '../objects/keyboard_aux.dart';
import '../objects/keyboard_types.dart';

class VirtualKeyboard extends StatefulWidget {
  const VirtualKeyboard({super.key});

  @override
  State<VirtualKeyboard> createState() => _MyAppState();
}

class _MyAppState extends State<VirtualKeyboard> {
  Map<String, dynamic> values = {};
  var formKey = GlobalKey<FormState>();
  TextEditingController? currentController;
  String? currentparamId;
  var isKeyboardVisible = false;
  //var controllerKeyboard = TextEditingController();
  late double keyboardHeight;
  GlobalKey keyboardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    keyboardHeight = max(160, MediaQuery.of(context).size.height * 0.35);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Plugin example app'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            )),
            AnimatedPositioned(
              top: 0,
              duration: const Duration(milliseconds: 200),
              bottom: isKeyboardVisible ? 0 : keyboardHeight * -1,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: EasyFormBuilder(
                                formKey: formKey,
                                textFieldOnFocus: (controller, paramId) {
                                  currentController = controller;
                                  currentparamId = paramId;
                                  isKeyboardVisible = currentController != null;
                                  setState(() {});
                                },
                                forcedKeyboardType: TextInputType.none,
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
                                    id: "email",
                                    icon: Icon(Icons.email),
                                    type: String,
                                    title: "Email",
                                    validators: [RequiredValidator(), EmailValidator()],
                                  )
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
                  ),
                  SizedBox(
                    height: keyboardHeight,
                    child: KeyboardAux(
                      key: keyboardKey,
                      alwaysCaps: false,
                      height: keyboardHeight,
                      controller: currentController,
                      typeLayout: KeyboardTypes.alphaEmail,
                      typeKeyboard: VirtualKeyboardType.Custom,
                      onChange: (controller) {
                        values[currentparamId!] = controller.text;
                        //currentController?.text = controller.text;
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
