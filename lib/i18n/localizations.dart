import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final localeName = Intl.canonicalizedLocale(locale.languageCode);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static AppLocalizations get instance => AppLocalizationsDelegate.instance;

  String v0(int num) => Intl.message('$num lines', args: [num], name: 'v0');
  String v1(int num) => Intl.message('Created $num minutes ago', args: [num], name: 'v1');
  String v2(int num) => Intl.message('Created $num hours ago', args: [num], name: 'v2');
  String v3(String date) => Intl.message('Created on $date', args: [date], name: 'v3');

  String p0(int num) => Intl.plural(num, one: 'Delete Task', other: 'Delete Tasks', args: [num], name: 'p0');
  String p1(int num) => Intl.plural(num, one: 'Daily', other: 'Every $num days', args: [num], name: 'p1');
  String p2(int num) => Intl.plural(num, one: 'Weekly', other: 'Every $num weeks', args: [num], name: 'p2');
  String p3(int num) => Intl.plural(num, one: 'Monthly', other: 'Every $num months', args: [num], name: 'p3');
  String p4(int num) => Intl.plural(num, one: 'Yearly', other: 'Every $num years', args: [num], name: 'p4');
  String p5(int num) => Intl.plural(num, one: 'Label', other: 'Labels', args: [num], name: 'p5');
  String p6(int num) => Intl.plural(num, one: 'Delete Item', other: 'Delete Items', args: [num], name: 'p6');
  String p7(int num) => Intl.plural(num, one: 'Uncheck all', other: 'Unchecked all', args: [num], name: 'p7');

  String get w0 => Intl.message('Taskiee', name: 'w0');
  String get w1 => Intl.message('What are you planning today?', name: 'w1');
  String get w2 => Intl.message('Select Year', name: 'w2');
  String get w3 => Intl.message('Select List', name: 'w3');
  String get w4 => Intl.message('Select Time', name: 'w4');
  String get w5 => Intl.message('Select Color', name: 'w5');
  String get w6 => Intl.message('Select Icon', name: 'w6');
  String get w7 => Intl.message('Select Label', name: 'w7');
  String get w8 => Intl.message('Select Filters', name: 'w8');
  String get w9 => Intl.message('Select Language', name: 'w9');
  String get w10 => Intl.message('New List', name: 'w10');
  String get w11 => Intl.message('New Label', name: 'w11');
  String get w12 => Intl.message('New subtask', name: 'w12');
  String get w13 => Intl.message('Edit List', name: 'w13');
  String get w14 => Intl.message('Edit Label', name: 'w14');
  String get w15 => Intl.message('Delete List', name: 'w15');
  String get w16 => Intl.message('Delete Label', name: 'w16');
  String get w17 => Intl.message('Delete completed', name: 'w17');
  String get w19 => Intl.message('Contribute', name: 'w19');
  String get w20 => Intl.message('Items to Search', name: 'w20');
  String get w21 => Intl.message('How can we help?', name: 'w21');
  String get w23 => Intl.message('Sort By', name: 'w23');
  String get w24 => Intl.message('Add List', name: 'w24');
  String get w25 => Intl.message('Add Label', name: 'w25');
  String get w26 => Intl.message('Add Task', name: 'w26');
  String get w27 => Intl.message('Add note', name: 'w27');
  String get w28 => Intl.message('List name', name: 'w28');
  String get w29 => Intl.message('Label name', name: 'w29');
  String get w30 => Intl.message('Set due date', name: 'w30');
  String get w31 => Intl.message('Repeat', name: 'w31');
  String get w32 => Intl.message('Remind me', name: 'w32');
  String get w33 => Intl.message('Show completed', name: 'w33');
  String get w34 => Intl.message('Hide completed', name: 'w34');
  String get w35 => Intl.message('Filter tasks', name: 'w35');
  String get w36 => Intl.message('Sort', name: 'w36');
  String get w37 => Intl.message('No due date', name: 'w37');
  String get w38 => Intl.message('Pick a date', name: 'w38');
  String get w39 => Intl.message('Mark as important', name: 'w39');
  String get w40 => Intl.message('Move', name: 'w40');
  String get w41 => Intl.message('Rename task', name: 'w41');
  String get w42 => Intl.message('Rename subtask', name: 'w42');
  String get w43 => Intl.message('Task deleted', name: 'w43');
  String get w44 => Intl.message('Subtask deleted', name: 'w44');
  String get w46 => Intl.message('You don\'t have any labels yet', name: 'w46');
  String get w47 => Intl.message('You can search by filtering your tasks', name: 'w47');
  String get w48 => Intl.message('Are you sure you want to delete these items?', name: 'w48');
  String get w49 => Intl.message('What would you like to search? You can search whatever you want', name: 'w49');
  String get w50 => Intl.message('Unfortunately we couldn\'t find what you\'re looking for', name: 'w50');
  String get w51 => Intl.message('Lists', name: 'w51');
  String get w53 => Intl.message('Tasks', name: 'w53');
  String get w54 => Intl.message('Notes', name: 'w54');
  String get w55 => Intl.message('Subtasks', name: 'w55');
  String get w56 => Intl.message('Today', name: 'w56');
  String get w57 => Intl.message('Tomorrow', name: 'w57');
  String get w58 => Intl.message('Yesterday', name: 'w58');
  String get w59 => Intl.message('days', name: 'w59');
  String get w60 => Intl.message('weeks', name: 'w60');
  String get w61 => Intl.message('months', name: 'w61');
  String get w62 => Intl.message('years', name: 'w62');
  String get w63 => Intl.message('Done', name: 'w63');
  String get w64 => Intl.message('Cancel', name: 'w64');
  String get w65 => Intl.message('Delete', name: 'w65');
  String get w66 => Intl.message('Undo', name: 'w66');
  String get w70 => Intl.message('Search', name: 'w70');
  String get w71 => Intl.message('Rate it', name: 'w71');
  String get w72 => Intl.message('Important', name: 'w72');
  String get w73 => Intl.message('Importance', name: 'w73');
  String get w74 => Intl.message('Alphabetically', name: 'w74');
  String get w75 => Intl.message('Due Date', name: 'w75');
  String get w76 => Intl.message('Newest First', name: 'w76');
  String get w77 => Intl.message('Oldest First', name: 'w77');
  String get w78 => Intl.message('Normal', name: 'w78');
  String get w79 => Intl.message('Colored', name: 'w79');
  String get w80 => Intl.message('Version', name: 'w80');
  String get w81 => Intl.message('All', name: 'w81');
  String get w82 => Intl.message('Big', name: 'w82');
  String get w83 => Intl.message('Understand', name: 'w83');
  String get w84 => Intl.message('Bigger', name: 'w84');
  String get w85 => Intl.message('Colored Border', name: 'w85');
  String get w86 => Intl.message('Creation Date', name: 'w86');
  String get w87 => Intl.message('Are you sure you want to delete this list and all of its tasks?', name: 'w87');
  String get w89 => Intl.message('Taskiee made by independent developer and it needs to be translated to other languages. So, If you want to contribute to the translation please email me from feedback section. It really helps to other people and also me :)', name: 'w89');
  String get w90 => Intl.message('Are you sure you want to delete this label?', name: 'w90');
  String get w91 => Intl.message('Are you sure you want to delete completed tasks?', name: 'w91');
  String get w92 => Intl.message('Are you sure you want to delete this task?', name: 'w92');
  String get w93 => Intl.message('Please select a list', name: 'w93');
  String get w94 => Intl.message('Text cannot be empty', name: 'w94');
  String get w95 => Intl.message('Data backed up successfully', name: 'w95');
  String get w96 => Intl.message('Data restored successfully', name: 'w96');
  String get w97 => Intl.message('An unknown error occurred', name: 'w97');
  String get w98 => Intl.message('An error occurred while reading file', name: 'w98');
  String get w99 => Intl.message('File not found', name: 'w99');
  String get w100 => Intl.message('Reminder cannot set past', name: 'w100');
  String get w101 => Intl.message('Sorted by importance', name: 'w101');
  String get w102 => Intl.message('Sorted alphabetically', name: 'w102');
  String get w103 => Intl.message('Sorted by due date', name: 'w103');
  String get w104 => Intl.message('Sorted by creation date', name: 'w104');
  String get w105 => Intl.message('Created a few moments ago', name: 'w105');
  String get w106 => Intl.message('General', name: 'w106');
  String get w107 => Intl.message('Notifications', name: 'w107');
  String get w109 => Intl.message('Backup and Restore', name: 'w109');
  String get w110 => Intl.message('About', name: 'w110');
  String get w111 => Intl.message('Buy the developer a coffee :)', name: 'w111');
  String get w112 => Intl.message('Language', name: 'w112');
  String get w115 => Intl.message('System notification settings', name: 'w115');
  String get w116 => Intl.message('Font', name: 'w116');
  String get w117 => Intl.message('Theme', name: 'w117');
  String get w118 => Intl.message('Color', name: 'w118');
  String get w119 => Intl.message('Add button shape', name: 'w119');
  String get w120 => Intl.message('Shape', name: 'w120');
  String get w121 => Intl.message('Label shape', name: 'w121');
  String get w123 => Intl.message('Sort bar view', name: 'w123');
  String get w124 => Intl.message('Swipe deletion view', name: 'w124');
  String get w125 => Intl.message('Label view', name: 'w125');
  String get w127 => Intl.message('Notification sound', name: 'w127');
  String get w128 => Intl.message('Enable vibration', name: 'w128');
  String get w129 => Intl.message('Enable LED', name: 'w129');
  String get w130 => Intl.message('Text view', name: 'w130');
  String get w131 => Intl.message('Icon size', name: 'w131');
  String get w132 => Intl.message('Enjoying our app?', name: 'w132');
  String get w133 => Intl.message('Send feedback', name: 'w133');
  String get w134 => Intl.message('Restore your data from device storage', name: 'w134');
  String get w135 => Intl.message('Backup your data to device storage', name: 'w135');
  String get w136 => Intl.message('Please ensure the backup file located at device\'s downloads folder as taskiee_backup.json', name: 'w136');
  String get w137 => Intl.message('Backed up data is located in the device\'s downloads folder as taskiee_backup.json. You can send it to another phone via email, bluetooth etc.', name: 'w137');
  String get w138 => Intl.message('Report an issue', name: 'w138');
  String get w139 => Intl.message('Request a feature', name: 'w139');
  String get w140 => Intl.message('Report a translation error', name: 'w140');
  String get w141 => Intl.message('Contribute to translation', name: 'w141');
  String get w142 => Intl.message('Having trouble with notifications?', name: 'w142');
  String get w143 => Intl.message('Notification Help', name: 'w143');
  String get w144 => Intl.message('Notifications does not fired on time', name: 'w144');
  String get w145 => Intl.message('Due to some manufacturers add very aggressive power saving, Taskiee may be cleared from the background by the system. You can try below step to get notification on time.', name: 'w145');
  String get w146 => Intl.message('Possible Solution', name: 'w146');
  String get w147 => Intl.message('Enable the \"Ignore battery optimization\"', name: 'w147');
  String get w149 => Intl.message('Can\'t set reminder for a completed task', name: 'w149');
  String get w150 => Intl.message('Primary', name: 'w150');
  String get w151 => Intl.message('Accent', name: 'w151');
  String get w152 => Intl.message('Custom', name: 'w152');
  String get w153 => Intl.message('Delete Note', name: 'w153');
  String get w154 => Intl.message('Are you sure you want to delete this note?', name: 'w154');
  String get w155 => Intl.message('Reminder canceled', name: 'w155');
  String get w156 => Intl.message('Reminder is set', name: 'w156');
  String get w157 => Intl.message('Sort type', name: 'w157');
  String get w158 => Intl.message('Alphabetic (A-Z)', name: 'w158');
  String get w159 => Intl.message('Alphabetic (Z-A)', name: 'w159');
  String get w160 => Intl.message('Creation (Newest)', name: 'w160');
  String get w161 => Intl.message('Creation (Oldest)', name: 'w161');
  String get w163 => Intl.message('Tap to sort as custom', name: 'w163');
  String get w164 => Intl.message('Reorder Lists', name: 'w164');
  String get w165 => Intl.message('Reorder Labels', name: 'w165');
  String get w166 => Intl.message('Reorder Tasks', name: 'w166');
  String get w167 => Intl.message('Note content', name: 'w167');
  String get w169 => Intl.message('Edit Note', name: 'w169');
  String get w170 => Intl.message('New Note', name: 'w170');
  String get w171 => Intl.message('View', name: 'w171');
  String get w172 => Intl.message('Reorder', name: 'w172');
  String get w173 => Intl.message('Line-through completed tasks', name: 'w173');
  String get w174 => Intl.message('Show completed tasks in calendar', name: 'w174');
  String get w175 => Intl.message('Auto-delete completed tasks', name: 'w175');
  String get w176 => Intl.message('Warning: When enabled, it will delete all your currently completed tasks', name: 'w176');
  String get w177 => Intl.message('Disable battery saver in app settings if available', name: 'w177');
  String get w178 => Intl.message('Turn on AutoStart in phone or app settings if available', name: 'w178');
  String get w179 => Intl.message('It looks like you\'ve made some changes. Do you want to save them?', name: 'w179');
  String get w180 => Intl.message('Insert new task to the bottom of the list', name: 'w180');
  String get w181 => Intl.message('Move completed tasks to the bottom of the list', name: 'w181');
  String get w182 => Intl.message('Include subtasks in the calculation of the list\'s completion rate', name: 'w182');
  String get w183 => Intl.message('Include subtasks in the calculation', name: 'w183');
  String get w184 => Intl.message('Save', name: 'w184');
  String get w185 => Intl.message('No', name: 'w185');
  String get w186 => Intl.message('Save Task', name: 'w186');
  String get w187 => Intl.message('Warning: If you already have backup file you need to override it. Otherwise, the system will create it as a new file that will consume your storage space unnecessarily. To override, simply tap on it and then press save button', name: 'w187');
  String get w188 => Intl.message('Darken the bottom navigation bar', name: 'w188');
  String get w189 => Intl.message('Calculate next due from', name: 'w189');
  String get w190 => Intl.message('completion date', name: 'w190');
  String get w191 => Intl.message('old due date (default)', name: 'w191');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  static AppLocalizations instance;
  static const defaultLocale = 'en';
  static const locales = [defaultLocale, 'tr'];

  @override
  bool isSupported(Locale locale) {
    return locales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    instance = await AppLocalizations.load(locale);
    return instance;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/i18n/messages lib/localizations.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/i18n  --no-use-deferred-loading lib/localizations.dart lib/i18n/messages/intl_en.arb lib/i18n/messages/intl_tr.arb