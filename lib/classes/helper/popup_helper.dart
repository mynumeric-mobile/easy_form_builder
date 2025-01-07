import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'localization.dart';

class PopupHelper {
  //
  static void displayInfo(String message, context,
      {bool info = false, IconData icon = Icons.report_problem_outlined}) {
    var ctx = context;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(!info ? icon : Icons.check_circle),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: Text(message,
                style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onSecondary))),
      ]),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      //backgroundColor:
      //  !info ? Colors.red : MaterialColorHelper.buildColor(26, 92, 6),
      duration: const Duration(seconds: 4),
    ));
  }

  Widget popupDialog(BuildContext context, String title, String text, button1,
      {button2}) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: <Widget>[
        if (button1 != null) button1,
        if (button2 != null) button2
      ],
    );
  }

  static Future<Object?> showDialog(BuildContext context, Widget body,
      {Widget? button1,
      Widget? button2,
      Widget? button3,
      Widget? button4,
      String? title,
      Widget? titleWidget,
      IconData? icon,
      bool handleTVRemote = false,
      key}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, a1, a2) {
        return Container();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        var child = popupWidget(
            key: key,
            context: context,
            icon: icon,
            title: title,
            titleWidget: titleWidget,
            body: body,
            button1: button1,
            button2: button2,
            button3: button3,
            button4: button4);
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
          child: FadeTransition(
            opacity: anim1,
            child: handleTVRemote
                ? Shortcuts(shortcuts: <LogicalKeySet, Intent>{
                    LogicalKeySet(LogicalKeyboardKey.select):
                        const ActivateIntent(),
                  }, child: child)
                : child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Future<Object?> confirm(
      {required context,
      title,
      titleWidget,
      text,
      textWidget,
      cancelText,
      onValidate,
      onCancel}) {
    assert(text != null || textWidget != null,
        "You must specify either text or textWidget");
    assert(onValidate != null, "You must specify an handler for onValidate");
    return PopupHelper.showDialog(
      context,
      icon: Icons.contact_support,
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textWidget ??
                Text(text, style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
      button1: okButton(
          context: context,
          onPress: () {
            onValidate?.call();
          }),
      button2: cancelButton(
          context: context,
          onPress: () {
            Navigator.of(context).pop();
            onCancel?.call();
          }),
      title: title,
      titleWidget: titleWidget,
    );
  }

  static Widget popupWidget(
      {required BuildContext context,
      String? title,
      Widget? titleWidget,
      IconData? icon,
      body,
      button1,
      button2,
      button3,
      button4,
      key}) {
    return AlertDialog(
      key: key,
      titlePadding:
          EdgeInsets.zero, //const EdgeInsets.fromLTRB(4.0, 14, 5.0, 3),
      contentPadding: const EdgeInsets.all(4.0),
      actionsPadding: const EdgeInsets.all(8.0),
      insetPadding: const EdgeInsets.all(8.0),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      title: titleWidget ??
          (title != null
              ? titleBar(
                  context: context, icon: icon, title: title, buttons: null)
              : null),
      content: body,
      actions: <Widget>[
        if (button1 != null) button1,
        if (button2 != null) button2,
        if (button3 != null) button3,
        if (button4 != null) button4
      ],
    );
  }

  static Container titleBar(
      {required BuildContext context, IconData? icon, String? title, buttons}) {
    return Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 30),
            if (icon != null)
              const SizedBox(
                width: 5,
              ),
            Expanded(
              child: title != null
                  ? Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Container(),
            ),
            if (buttons != null)
              for (Widget button in buttons) button,
          ],
        ));
  }

  static Widget cancelButton(
          {Function? onPress,
          bool enable = true,
          dynamic returnValue = false,
          required BuildContext context}) =>
      button(
          title: localizationOptions.cancel,
          icon: Icons.cancel,
          onPress: enable
              ? onPress ??
                  () {
                    Navigator.pop(context, returnValue);
                  }
              : null,
          context: context);
  static Widget okButton(
          {Function? onPress,
          bool waiting = false,
          required BuildContext context}) =>
      button(
          title: localizationOptions.ok,
          icon: Icons.check_circle,
          waiting: waiting,
          onPress: onPress,
          context: context);

  static Widget helpButton({
    required String title,
    String? text,
    Widget? content,
    required BuildContext context,
    Color? background,
  }) {
    return InkWell(
      onTap: () {
        PopupHelper.showDialog(
            context,
            title: title,
            icon: Icons.help,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  child: text != null
                      ? Text(
                          text,
                        )
                      : content),
            ),
            button1: okButton(
                onPress: () {
                  Navigator.pop(context);
                },
                context: context));
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: background,
          ),
          child: const Icon(
            Icons.help,
            //color: Colors.white70,
          ),
        ),
      ),
    );
  }

  static Widget button(
      {String? title,
      IconData? icon,
      Color? iconColor,
      bool waiting = false,
      onPress,
      Widget? titleWidget,
      required context}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(5.0),
            side: BorderSide(
                width: 1, // the thickness
                color: Theme.of(context)
                    .colorScheme
                    .primary // the color of the border
                )),
        onPressed: !waiting ? onPress : null,
        child: titleWidget ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && !waiting)
                  Icon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                if (waiting)
                  const Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator()),
                  ),
                if (title != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(title),
                    ],
                  ),
              ],
            ));
  }

  static Widget titleButton({
    required icon,
    onPress,
    required BuildContext context,
  }) {
    return GestureDetector(
      child: Icon(icon),
      onTap: () {
        onPress?.call();
      },
    );
  }

  static Widget titleButtonCancel(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: titleButton(
          icon: Icons.cancel,
          onPress: () {
            Navigator.pop(context);
          },
          context: context),
    );
  }

  static Widget titleButtonOk(context, onPress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: titleButton(
          icon: Icons.check_circle,
          onPress: () {
            onPress?.call();
          },
          context: context),
    );
  }
}

class WaitingWidgetWithTimer extends StatefulWidget {
  const WaitingWidgetWithTimer({super.key, required this.title});
  final String title;

  @override
  State<WaitingWidgetWithTimer> createState() => WaitingStateWithTimer();
}

class WaitingStateWithTimer extends State<WaitingWidgetWithTimer> {
  double _progress = 0;
  DateTime start = DateTime.now();
  double ratio = 0;
  Duration left = const Duration(seconds: 0);
  String _remaining = "";

  update(newValue) {
    var duration = DateTime.now().difference(start).inMilliseconds;
    ratio = newValue / duration;
    if (ratio > 0) {
      left = Duration(milliseconds: ((1 - newValue) / ratio).round());
      _remaining = ratio == 0
          ? "----"
          : "${left.inMinutes} mn ${(left.inSeconds % 60).toString().padLeft(2, '0')} s";
    }
    setState(() {
      _progress = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      value: _progress,
                      // ignore: use_build_context_synchronously
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${localizationOptions.remainingTime} $_remaining",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class WaitingWidget extends StatefulWidget {
  const WaitingWidget({super.key, required this.title});
  final String title;

  @override
  State<WaitingWidget> createState() => WaitingState();
}

class WaitingState extends State<WaitingWidget> {
  double _progress = -1;

  update(newValue) {
    setState(() {
      _progress = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
