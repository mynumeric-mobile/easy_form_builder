import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import 'classes/helper.dart/generic_font.dart';
import 'classes/helper.dart/localization.dart';
import 'classes/helper.dart/popup_helper.dart';
import 'classes/objects/df_param.dart';
import 'classes/objects/validator/validator.dart';
import 'widgets/color_picker.dart';
import 'widgets/textfield.dart';

class EasyFormBuilder extends StatefulWidget {
  const EasyFormBuilder(
      {super.key,
      required this.params,
      required this.paramValues,
      this.onChange,
      this.forcedColumnNumber,
      //this.baseRowSize = 50,
      this.colSpacing = 4,
      this.rowSpacing = 5,
      this.forceReadOnly = false,
      this.border = false,
      this.icon = false,
      this.iconSizeRatio = 1,
      this.textStyle,
      this.formKey});
  final List<DfCfgParam> params;
  final Map<String, dynamic> paramValues;
  final Function(String modifiedParamId)? onChange;

  final TextStyle? textStyle;

  //final double baseRowSize;
  final double colSpacing;
  final double rowSpacing;
  final bool border;
  final bool icon;
  final double iconSizeRatio;
  final bool forceReadOnly;

  final int? forcedColumnNumber;
  final Key? formKey;

  @override
  State<EasyFormBuilder> createState() => _EasyFormBuilderState();
}

class _EasyFormBuilderState extends State<EasyFormBuilder> {
  //final ScrollController _scrollController = ScrollController();
  final Map<String, TextEditingController> _textControler = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: SingleChildScrollView(
              child: Form(
                  key: widget.formKey,
                  child: StaggeredGrid.count(
                    crossAxisSpacing: widget.colSpacing,
                    mainAxisSpacing: widget.rowSpacing,
                    crossAxisCount: widget.forcedColumnNumber ?? max(1, (constraints.maxWidth / 290).round()),
                    children: [
                      for (DfCfgParam p in widget.params)
                        if (field(p) != null)
                          StaggeredGridTile.fit(
                              crossAxisCellCount: p.usedColumn ?? 1,
                              //mainAxisCellCount: 1,
                              //mainAxisExtent: widget.baseRowSize * (p.usedRow ?? 1) * p.maxTextFieldLine,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: field(p)!),
                                      if (p.comment != null)
                                        PopupHelper.helpButton(
                                            title: localizationOptions.help, text: p.comment!, context: context)
                                    ],
                                  ),
                                ),
                              ))
                    ],
                  )),
            ));
      },
    );
  }

  Widget? field(DfCfgParam param) {
    widget.paramValues[param.id] = widget.paramValues[param.id] ?? param.defaultValue;

    if (!(param.isDisplayable?.call(widget.paramValues) ?? true)) return null;

    if (param.readOnly || widget.forceReadOnly) {
      var txt = param.title;

      if (widget.paramValues[param.id] != null && widget.paramValues[param.id] != "") {
        txt += " : ${widget.paramValues[param.id]}";
      }

      return Text(txt);
    }

    if (param.dataSource != null) {
      return ddl(param);
    }
    switch (param.type) {
      case const (Color):
        return WsColorPicker(
          visualDensity: VisualDensity.compact,
          title: param.title,
          color: widget.paramValues[param.id],
          onChange: (value) {
            if (value == widget.paramValues[param.id]) return;
            widget.paramValues[param.id] = value;
            setState(() {});
            widget.onChange?.call(param.id);
          },
        );
      case const (bool):
        return SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: Text(
                param.title,
              )),
              Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: widget.paramValues[param.id] ?? false,
                  onChanged: (v) {
                    if ((v ?? false) == widget.paramValues[param.id]) return;
                    widget.paramValues[param.id] = v ?? false;
                    setState(() {});
                    widget.onChange?.call(param.id);
                  }),
            ],
          ),
        );
      case const (DateTime):
        return datePicker(
            title: param.title,
            withTime: param.includeTimeInDateTime,
            value: widget.paramValues[param.id],
            onChange: (v) {
              if (v == widget.paramValues[param.id]) return;
              setState(() {
                widget.paramValues[param.id] = v;
                widget.onChange?.call(param.id);
              });
            });
      default:
        return textForm(param, widget.onChange);
    }
  }

  Widget textForm(param, onChange) {
    if (_textControler[param.id] == null) {
      _textControler[param.id] =
          TextEditingController(text: (widget.paramValues[param.id] ?? param.defaultValue ?? "").toString());
    }

    var icon = param.icon;

    if (param.icon != null && param.icon is Icon) {
      icon = Icon(
        param.icon.icon,
        size: (param.icon.size ?? 24) * widget.iconSizeRatio,
      );
    }

    return BnTextField(
        name: param.title,
        keyboardType: _getKeyboardType(param.type, param.maxTextFieldLine),
        prefixIcon: widget.icon ? icon : null,
        maxLine: param.maxTextFieldLine,
        border: widget.border,
        style: widget.textStyle,
        controler: _textControler[param.id],
        password: param.isPassword,
        validator: (value) {
          if (param.validators != null) {
            for (Validator v in param.validators!) {
              if (!v.isValid(value, widget.paramValues)) return v.errorMessage;
            }
          }
          return null;
        },
        onChange: (value) {
          var val = value ?? param.defaultValue;
          widget.paramValues[param.id] = _getValue(param.type, val);
          onChange?.call(param.id);
        });
  }

  _getValue(type, val) {
    switch (type) {
      case const (int):
        return int.tryParse(val);
      case const (double):
        return double.tryParse(val);

      case const (num):
        return num.tryParse(val);
      default:
        return val;
    }
  }

  _getKeyboardType(type, maxLine) {
    switch (type) {
      case const (int):
        return TextInputType.number;
      case const (num):
      case const (double):
        return const TextInputType.numberWithOptions(signed: false, decimal: true);
      default:
        return maxLine > 1 ? TextInputType.multiline : null;
    }
  }

  Widget ddl(DfCfgParam param) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("${param.title} : "),
        Expanded(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            var v = widget.paramValues[param.id];
            if (param.dataSource!.values.isEmpty && !param.dataSource!.keysValues.containsKey(v)) v = null;
            return SizedBox(
              width: constraints.maxWidth,
              child: DropdownButton(
                isExpanded: true,
                value: v,
                itemHeight: null,
                isDense: true,
                items: [
                  for (MapEntry<dynamic, dynamic> v in param.dataSource!.keysValues.entries) //display from key values map
                    DropdownMenuItem(
                      value: v.key,
                      child: v.value is String
                          ? SizedBox(
                              width: constraints.maxWidth - 30,
                              //fit: BoxFit.contain,
                              child: Text(
                                v.value,
                                overflow: TextOverflow.ellipsis,
                                style: param.dataSource!.fontFamilyMode
                                    ? GenericFontHelper.getDynamicStyle(fontFamily: v.key)
                                    : null,
                              ),
                            )
                          : v.value,
                    ),
                  for (dynamic v in param.dataSource!.values) // display from values list
                    DropdownMenuItem(
                      value: v,
                      child: SizedBox(
                          width: constraints.maxWidth - 30,
                          child: v is String
                              ? Text(
                                  v.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: param.dataSource!.fontFamilyMode
                                      ? GenericFontHelper.getDynamicStyle(fontFamily: v.toString())
                                      //const TextStyle().copyWith(fontFamily: v.toString())
                                      : null,
                                )
                              : v as Widget),
                    )
                ],
                onChanged: (value) {
                  if (widget.paramValues[param.id] == value) return;
                  widget.paramValues[param.id] = value;
                  setState(() {});
                  widget.onChange?.call(param.id);
                },
              ),
            );
          }),
        )
      ],
    );
  }

  Widget datePicker({title, DateTime? value, bool withTime = false, minValue, maxValue, onChange}) => Row(children: [
        Text("$title :"),
        GestureDetector(
          onTap: () async {
            var result = withTime
                ? await showDateTimePicker(
                    // ignore: use_build_context_synchronously
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: minValue ?? DateTime(1900),
                    lastDate: maxValue ?? DateTime(2050))
                : await showDatePicker(
                    // ignore: use_build_context_synchronously
                    context: context,
                    initialDate: value ?? DateTime.now(), //get today's date
                    firstDate: minValue ?? DateTime(1900), //DateTime.now() - not to allow to choose before today.
                    lastDate: maxValue ?? DateTime(2050));

            onChange?.call(result);
          },
          child: Container(
              margin: const EdgeInsets.only(left: 6.0),
              padding: const EdgeInsets.fromLTRB(2, 0, 6, 0),
              constraints: const BoxConstraints(minWidth: 75),
              decoration: BoxDecoration(
                //color: Theme.of(context).colorScheme.background,
                border: Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                  textAlign: TextAlign.center,
                  " ${value == null ? "-" : (withTime ? DateFormat('dd-MM-yyyy HH:mm') : DateFormat.yMd()).format(value)}")),
        )
      ]);

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
