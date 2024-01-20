import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskiee/models/repeat.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class RepeatPicker extends HookWidget with Utils {
  final Color color;
  final Repeat repeat;

  RepeatPicker({this.color, this.repeat});

  ValueNotifier<RepeatType> repeatType;
  ValueNotifier<List<int>> weekDays;
  TextEditingController controller;
  ValueNotifier<DueFrom> dueFrom;
  AppLocalizations localizations;
  ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    localizations = AppLocalizations.instance;
    dueFrom = useState(repeat?.dueFrom ?? DueFrom.OldDue);
    repeatType = useState(repeat?.repeatType ?? RepeatType.Weeks);
    weekDays = useState(repeat?.weekDays ?? [DateTime.now().weekday]);
    controller = useTextEditingController(
        text: repeat != null ? repeat.amount.toString() : '1');

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        AppLocalizations.instance.w4,
        style: theme.textTheme.headline2.copyWith(color: color),
      ),
      content: SizedBox(
        width: repeatType.value == RepeatType.Weeks ? 256 : 296,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                textField(),
                const SizedBox(width: 8),
                dropDown1(),
              ],
            ),
            repeatType.value != RepeatType.Weeks
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            localizations.w189,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                      ),
                      Align(
                        child: dropDown2(),
                        alignment: Alignment.center,
                      ),
                    ],
                  )
                : const SizedBox(),
            picker(context),
          ],
        ),
      ),
      actions: actions(
        context,
        color: color,
        onPressed: () => onTapDone(context),
      ),
    );
  }

  Widget textField() {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: color.withOpacity(.4),
          selectionHandleColor: color,
          cursorColor: color,
        ),
      ),
      child: TextField(
        maxLength: 3,
        cursorColor: color,
        controller: controller,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyText1,
        keyboardType: TextInputType.number,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        buildCounter: (_, {currentLength, isFocused, maxLength}) => null,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.only(bottom: 4),
          constraints: BoxConstraints(maxWidth: 48),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: theme.textTheme.bodyText1.color.withOpacity(.48),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget dropDown1() {
    final strings = [
      AppLocalizations.instance.w59,
      AppLocalizations.instance.w60,
      AppLocalizations.instance.w61,
      AppLocalizations.instance.w62,
    ];

    return Theme(
      data: theme.copyWith(canvasColor: theme.colorScheme.surface),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          alignment: Alignment.centerRight,
          onChanged: (value) {
            if (value != repeatType.value) repeatType.value = value;
          },
          value: repeatType.value,
          icon: Icon(Icons.keyboard_arrow_down_outlined, color: color),
          items: strings
              .map(
                (e) => DropdownMenuItem(
                  value: RepeatType.values[strings.indexOf(e)],
                  child: Text(e, style: theme.textTheme.bodyText1),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget dropDown2() {
    return Theme(
      data: theme.copyWith(canvasColor: theme.colorScheme.surface),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dueFrom.value,
          onChanged: (value) {
            if (value != dueFrom.value) dueFrom.value = value;
          },
          alignment: Alignment.centerRight,
          icon: Icon(Icons.keyboard_arrow_down_outlined, color: color),
          items: [
            DropdownMenuItem(
              value: DueFrom.Completion,
              child: Text(localizations.w190, style: theme.textTheme.bodyText1),
            ),
            DropdownMenuItem(
              value: DueFrom.OldDue,
              child: Text(localizations.w191, style: theme.textTheme.bodyText1),
            ),
          ],
        ),
      ),
    );
  }

  Widget picker(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final days = DateFormat.EEEE(locale).dateSymbols.STANDALONESHORTWEEKDAYS;

    List order;

    switch (MaterialLocalizations.of(context).firstDayOfWeekIndex) {
      case 1:
        order = [1, 2, 3, 4, 5, 6, 7];
        break;
      case 6:
        order = [6, 7, 1, 2, 3, 4, 5];
        break;
      default:
        order = [7, 1, 2, 3, 4, 5, 6];
        break;
    }

    if (repeatType.value == RepeatType.Weeks) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: order
              .map((e) => child(context, days[e == 7 ? 0 : e], e))
              .toList(),
        ),
      );
    }

    return const SizedBox();
  }

  Widget child(BuildContext context, String day, int index) {
    final isActive = weekDays.value.contains(index);

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? color : Colors.transparent,
          border: Border.all(color: color, width: 1.5),
        ),
        child: AnimatedDefaultTextStyle(
          duration: kThemeAnimationDuration,
          style: theme.textTheme.subtitle1.copyWith(
              color: isActive
                  ? getOnColor(color)
                  : theme.textTheme.subtitle1.color),
          child: Text(day),
        ),
      ),
    );
  }

  void onTapDone(BuildContext context) {
    final amount = int.tryParse(controller.text);

    if (amount != 0 && amount != null) {
      final repeat = Repeat(
        amount: amount,
        repeatType: repeatType.value,
        weekDays: repeatType.value == RepeatType.Weeks ? weekDays.value : null,
        dueFrom: repeatType.value == RepeatType.Weeks
            ? DueFrom.OldDue
            : dueFrom.value,
      );

      Navigator.pop(context, repeat);
    }
  }

  void onTap(int weekDay) {
    final values = [...weekDays.value];

    if (values.contains(weekDay)) {
      if (values.length != 1) {
        values.remove(weekDay);
        weekDays.value = values;
      }
    } else {
      values.add(weekDay);
      weekDays.value = values;
    }
  }
}
