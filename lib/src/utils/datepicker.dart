import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker {
  BuildContext context;
  final ValueChanged<DateTime> onDateTimeChanged;

  DatePicker(this.context, {@required this.onDateTimeChanged});

  void show(DateTime date) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child: Stack(
              children: <Widget>[
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                  child: CupertinoDatePicker(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (date) {
                      onDateTimeChanged(date);
                    },
                    initialDateTime: date,
                    minimumDate: DateTime(date.year - 1),
                    maximumDate: DateTime(date.year + 3),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CupertinoButton(
                    child: Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
