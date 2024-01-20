import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum PickerMode { Primary, Accent, Custom }

// ignore: must_be_immutable
class ColorPicker extends HookWidget with Utils {
  final Color color;

  ColorPicker({this.color});

  TextTheme textTheme;
  ValueNotifier<int> sliderR;
  ValueNotifier<int> sliderG;
  ValueNotifier<int> sliderB;
  ValueNotifier<PickerMode> pickerMode;
  ValueNotifier<Color> accentSelectedColor;
  ValueNotifier<Color> primarySelectedColor;
  ValueNotifier<MaterialColor> primaryColor;
  ValueNotifier<MaterialAccentColor> accentColor;

  @override
  Widget build(BuildContext context) {
    final isPrimary = ColorTools.isPrimary(color);
    final colorScheme = Theme.of(context).colorScheme;
    final isAccent = !isPrimary ? ColorTools.isAccent(color) : false;

    sliderR = useState(color.red);
    sliderB = useState(color.blue);
    sliderG = useState(color.green);
    textTheme = Theme.of(context).textTheme;
    primarySelectedColor = useState(isPrimary ? color : Colors.red);
    accentSelectedColor = useState(isAccent ? color : Colors.redAccent);
    primaryColor =
        useState(isPrimary ? ColorTools.primarySwatch(color) : Colors.red);
    accentColor =
        useState(isAccent ? ColorTools.accentSwatch(color) : Colors.redAccent);
    pickerMode = useState(isPrimary
        ? PickerMode.Primary
        : isAccent
            ? PickerMode.Accent
            : PickerMode.Custom);

    return AlertDialog(
      title: Text(
        AppLocalizations.instance.w5,
        style: textTheme.headline2.copyWith(color: color),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 296),
        child: ScrollConfiguration(
          behavior: NonGlowBehavior(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoSlidingSegmentedControl(
                  backgroundColor: colorScheme.brightness == Brightness.light
                      ? Color.fromARGB(30, 118, 118, 128)
                      : colorScheme.surface,
                  onValueChanged: (value) =>
                      pickerMode.value = value as PickerMode,
                  groupValue: pickerMode.value,
                  padding: EdgeInsets.zero,
                  thumbColor: color,
                  children: {
                    PickerMode.Primary: AnimatedDefaultTextStyle(
                      child: Text(AppLocalizations.instance.w150),
                      duration: kThemeAnimationDuration,
                      style: getStyle(PickerMode.Primary, context),
                    ),
                    PickerMode.Accent: AnimatedDefaultTextStyle(
                      child: Text(AppLocalizations.instance.w151),
                      duration: kThemeAnimationDuration,
                      style: getStyle(PickerMode.Accent, context),
                    ),
                    PickerMode.Custom: AnimatedDefaultTextStyle(
                      child: Text(AppLocalizations.instance.w152),
                      duration: kThemeAnimationDuration,
                      style: getStyle(PickerMode.Custom, context),
                    ),
                  },
                ),
                const SizedBox(height: 16),
                child(context),
              ],
            ),
          ),
        ),
      ),
      actions: actions(context, color: color, onPressed: () => onDone(context)),
    );
  }

  // ignore: missing_return
  Widget child(BuildContext context) {
    switch (pickerMode.value) {
      case PickerMode.Primary:
        return Column(
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: Colors.primaries
                  .map((e) => item(e, primaryColor.value.shade500))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: ColorTools.getPrimaryShades(primaryColor.value)
                  .map((e) => item(e, primarySelectedColor.value, shades: true))
                  .toList(),
            ),
          ],
        );
      case PickerMode.Accent:
        return Column(
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: Colors.accents
                  .map((e) => item(e, accentColor.value.shade200))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: ColorTools.getAccentShades(accentColor.value)
                  .map((e) => item(e, accentSelectedColor.value, shades: true))
                  .toList(),
            ),
          ],
        );
      case PickerMode.Custom:
        return Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: 64,
              height: 64,
              child: Material(
                elevation: 3,
                shape: CircleBorder(),
                color: Color.fromRGBO(
                  sliderR.value.toInt(),
                  sliderG.value.toInt(),
                  sliderB.value.toInt(),
                  1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            slider(Colors.red, sliderR),
            slider(Colors.green, sliderG),
            slider(Colors.blue, sliderB),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'R: ${sliderR.value}',
                  style: textTheme.bodyText2,
                ),
                const SizedBox(width: 12),
                Text(
                  'G: ${sliderG.value}',
                  style: textTheme.bodyText2,
                ),
                const SizedBox(width: 12),
                Text(
                  'B: ${sliderB.value}',
                  style: textTheme.bodyText2,
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget slider(Color color, ValueNotifier valueNotifier) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: color,
        overlayColor: color.withOpacity(.2),
        activeTrackColor: color.withOpacity(.87),
        inactiveTrackColor: color.withOpacity(.45),
      ),
      child: Slider(
        min: 0,
        max: 255,
        value: valueNotifier.value.toDouble(),
        onChanged: (value) => valueNotifier.value = value.toInt(),
      ),
    );
  }

  Widget item(Color color, Color selectedColor, {bool shades = false}) {
    return GestureDetector(
      onTap: () => onTap(color, shades),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
        child: selectedColor.value == color.value
            ? Icon(Icons.done_outline_rounded, color: getOnColor(color))
            : null,
      ),
    );
  }

  TextStyle getStyle(PickerMode pickerMode, BuildContext context) {
    if (this.pickerMode.value == pickerMode)
      return textTheme.subtitle2.copyWith(color: getOnColor(color));

    return textTheme.subtitle2 ?? TextStyle();
  }

  void onTap(Color color, bool shades) {
    switch (pickerMode.value) {
      case PickerMode.Primary:
        if (!shades) primaryColor.value = color as MaterialColor;

        primarySelectedColor.value = color;
        break;
      case PickerMode.Accent:
        if (!shades) accentColor.value = color as MaterialAccentColor;

        accentSelectedColor.value = color;
        break;
      case PickerMode.Custom:
        break;
    }
  }

  void onDone(BuildContext context) {
    Color selectedColor;

    switch (pickerMode.value) {
      case PickerMode.Primary:
        selectedColor = primarySelectedColor.value;
        break;
      case PickerMode.Accent:
        selectedColor = accentSelectedColor.value;
        break;
      case PickerMode.Custom:
        selectedColor = Color.fromRGBO(
          sliderR.value,
          sliderG.value,
          sliderB.value,
          1,
        );
        break;
    }

    Navigator.pop(context, selectedColor);
  }
}

class ColorTools {
  static const List<int> _indexPrimary = [
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ];

  static const List<int> _indexAccent = [100, 200, 400, 700];

  static List<Color> getPrimaryShades(MaterialColor color) {
    return [
      color.shade100,
      color.shade200,
      color.shade300,
      color.shade400,
      color.shade500,
      color.shade600,
      color.shade700,
      color.shade800,
      color.shade900,
    ];
  }

  static List<Color> getAccentShades(MaterialAccentColor color) {
    return [color.shade100, color.shade200, color.shade400, color.shade700];
  }

  static bool isPrimary(Color color) {
    for (final primary in Colors.primaries) {
      for (final i in _indexPrimary) {
        if (primary[i].value == color.value) return true;
      }
    }

    return false;
  }

  static bool isAccent(Color color) {
    for (final accent in Colors.accents) {
      for (final int i in _indexAccent) {
        if (accent[i].value == color.value) return true;
      }
    }

    return false;
  }

  static MaterialAccentColor accentSwatch(Color color) {
    for (final swatch in Colors.accents) {
      for (final int i in _indexAccent) {
        if (swatch[i].value == color.value) return swatch;
      }
    }

    throw UnimplementedError('primaryAccent');
  }

  static MaterialColor primarySwatch(Color color) {
    for (final swatch in Colors.primaries) {
      for (final int i in _indexPrimary) {
        if (swatch[i].value == color.value) return swatch;
      }
    }

    throw UnimplementedError('primarySwatch');
  }
}
