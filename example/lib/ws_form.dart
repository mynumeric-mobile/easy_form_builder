import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/classes/objects/df_param.dart';
import 'package:flutter_dynamic_form/classes/objects/validator/not_null_or_empty_validator.dart';
import 'package:flutter_dynamic_form/classes/objects/validator/email_validator.dart';

enum WsFormTypes {
  simpleContact,
  inscription,
  advancedContact;

  List<DfCfgParam> get wsParams {
    return [
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
        validators: [NotNullOrEmptyValidator(), EmailValidator()],
      ),
      if (this == WsFormTypes.advancedContact)
        DfCfgParam(
          id: "phone",
          icon: Icon(Icons.phone),
          type: String,
          title: "Phone",
        ),
      if (this != WsFormTypes.inscription)
        DfCfgParam(
          id: "message",
          icon: Icon(Icons.message),
          usedColumn: 2,
          usedRow: 1.5,
          type: String,
          title: "Message",
          maxTextFieldLine: 3,
        ),
    ];
  }
}

class WsForm {}
