// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(num) =>
      "${Intl.plural(num, one: 'Delete Task', other: 'Delete Tasks')}";

  static m1(num) =>
      "${Intl.plural(num, one: 'Daily', other: 'Every ${num} days')}";

  static m2(num) =>
      "${Intl.plural(num, one: 'Weekly', other: 'Every ${num} weeks')}";

  static m3(num) =>
      "${Intl.plural(num, one: 'Monthly', other: 'Every ${num} months')}";

  static m4(num) =>
      "${Intl.plural(num, one: 'Yearly', other: 'Every ${num} years')}";

  static m5(num) => "${Intl.plural(num, one: 'Label', other: 'Labels')}";

  static m6(num) =>
      "${Intl.plural(num, one: 'Delete Item', other: 'Delete Items')}";

  static m7(num) =>
      "${Intl.plural(num, one: 'Uncheck all', other: 'Unchecked all')}";

  static m8(num) => "${num} lines";

  static m9(num) => "Created ${num} minutes ago";

  static m10(num) => "Created ${num} hours ago";

  static m11(date) => "Created on ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "p0": m0,
        "p1": m1,
        "p2": m2,
        "p3": m3,
        "p4": m4,
        "p5": m5,
        "p6": m6,
        "p7": m7,
        "v0": m8,
        "v1": m9,
        "v2": m10,
        "v3": m11,
        "w0": MessageLookupByLibrary.simpleMessage("Taskiee"),
        "w1": MessageLookupByLibrary.simpleMessage(
            "What are you planning today?"),
        "w10": MessageLookupByLibrary.simpleMessage("New List"),
        "w100":
            MessageLookupByLibrary.simpleMessage("Reminder cannot set past"),
        "w101": MessageLookupByLibrary.simpleMessage("Sorted by importance"),
        "w102": MessageLookupByLibrary.simpleMessage("Sorted alphabetically"),
        "w103": MessageLookupByLibrary.simpleMessage("Sorted by due date"),
        "w104": MessageLookupByLibrary.simpleMessage("Sorted by creation date"),
        "w105":
            MessageLookupByLibrary.simpleMessage("Created a few moments ago"),
        "w106": MessageLookupByLibrary.simpleMessage("General"),
        "w107": MessageLookupByLibrary.simpleMessage("Notifications"),
        "w109": MessageLookupByLibrary.simpleMessage("Backup and Restore"),
        "w11": MessageLookupByLibrary.simpleMessage("New Label"),
        "w110": MessageLookupByLibrary.simpleMessage("About"),
        "w111": MessageLookupByLibrary.simpleMessage(
            "Buy the developer a coffee :)"),
        "w112": MessageLookupByLibrary.simpleMessage("Language"),
        "w115": MessageLookupByLibrary.simpleMessage(
            "System notification settings"),
        "w116": MessageLookupByLibrary.simpleMessage("Font"),
        "w117": MessageLookupByLibrary.simpleMessage("Theme"),
        "w118": MessageLookupByLibrary.simpleMessage("Color"),
        "w119": MessageLookupByLibrary.simpleMessage("Add button shape"),
        "w12": MessageLookupByLibrary.simpleMessage("New subtask"),
        "w120": MessageLookupByLibrary.simpleMessage("Shape"),
        "w121": MessageLookupByLibrary.simpleMessage("Label shape"),
        "w123": MessageLookupByLibrary.simpleMessage("Sort bar view"),
        "w124": MessageLookupByLibrary.simpleMessage("Swipe to delete view"),
        "w125": MessageLookupByLibrary.simpleMessage("Label view"),
        "w127": MessageLookupByLibrary.simpleMessage("Notification sound"),
        "w128": MessageLookupByLibrary.simpleMessage("Enable vibration"),
        "w129": MessageLookupByLibrary.simpleMessage("Enable LED"),
        "w13": MessageLookupByLibrary.simpleMessage("Edit List"),
        "w130": MessageLookupByLibrary.simpleMessage("Text view"),
        "w131": MessageLookupByLibrary.simpleMessage("Icon size"),
        "w132": MessageLookupByLibrary.simpleMessage("Enjoying our app?"),
        "w133": MessageLookupByLibrary.simpleMessage("Send feedback"),
        "w134": MessageLookupByLibrary.simpleMessage(
            "Restore your data from device storage"),
        "w135": MessageLookupByLibrary.simpleMessage(
            "Backup your data to device storage"),
        "w136": MessageLookupByLibrary.simpleMessage(
            "Please ensure the backup file located at device\'s downloads folder as taskiee_backup.json"),
        "w137": MessageLookupByLibrary.simpleMessage(
            "Backup file is located in the device\'s downloads folder as taskiee_backup.json. You can send it to another phone via email, bluetooth etc."),
        "w138": MessageLookupByLibrary.simpleMessage("Report an issue"),
        "w139": MessageLookupByLibrary.simpleMessage("Request a feature"),
        "w14": MessageLookupByLibrary.simpleMessage("Edit Label"),
        "w140":
            MessageLookupByLibrary.simpleMessage("Report a translation error"),
        "w141":
            MessageLookupByLibrary.simpleMessage("Contribute to translation"),
        "w142": MessageLookupByLibrary.simpleMessage(
            "Having trouble with notifications?"),
        "w143": MessageLookupByLibrary.simpleMessage("Notification Help"),
        "w144": MessageLookupByLibrary.simpleMessage(
            "Notifications does not fired on time"),
        "w145": MessageLookupByLibrary.simpleMessage(
            "Due to some manufacturers add very aggressive power saving, Taskiee may be cleared from the background by the system. You can try below steps to get notification on time."),
        "w146": MessageLookupByLibrary.simpleMessage("Possible Solutions"),
        "w147": MessageLookupByLibrary.simpleMessage(
            "Tap to enable the \"Ignore battery optimization\""),
        "w149": MessageLookupByLibrary.simpleMessage(
            "Can\'t set reminder for a completed task"),
        "w15": MessageLookupByLibrary.simpleMessage("Delete List"),
        "w150": MessageLookupByLibrary.simpleMessage("Primary"),
        "w151": MessageLookupByLibrary.simpleMessage("Accent"),
        "w152": MessageLookupByLibrary.simpleMessage("Custom"),
        "w153": MessageLookupByLibrary.simpleMessage("Delete Note"),
        "w154": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this note?"),
        "w155": MessageLookupByLibrary.simpleMessage("Reminder canceled"),
        "w156": MessageLookupByLibrary.simpleMessage("Reminder is set"),
        "w157": MessageLookupByLibrary.simpleMessage("Sort type"),
        "w158": MessageLookupByLibrary.simpleMessage("Alphabetic (A-Z)"),
        "w159": MessageLookupByLibrary.simpleMessage("Alphabetic (Z-A)"),
        "w172": MessageLookupByLibrary.simpleMessage("Reorder"),
        "w16": MessageLookupByLibrary.simpleMessage("Delete Label"),
        "w160": MessageLookupByLibrary.simpleMessage("Creation (Newest)"),
        "w161": MessageLookupByLibrary.simpleMessage("Creation (Oldest)"),
        "w163": MessageLookupByLibrary.simpleMessage("Tap to sort as custom"),
        "w164": MessageLookupByLibrary.simpleMessage("Reorder Lists"),
        "w165": MessageLookupByLibrary.simpleMessage("Reorder Labels"),
        "w166": MessageLookupByLibrary.simpleMessage("Reorder Tasks"),
        "w167": MessageLookupByLibrary.simpleMessage("Note content"),
        "w168": MessageLookupByLibrary.simpleMessage("Task Notes"),
        "w169": MessageLookupByLibrary.simpleMessage("Edit Note"),
        "w17": MessageLookupByLibrary.simpleMessage("Delete completed"),
        "w170": MessageLookupByLibrary.simpleMessage("New Note"),
        "w171": MessageLookupByLibrary.simpleMessage("View"),
        "w19": MessageLookupByLibrary.simpleMessage("Contribute"),
        "w2": MessageLookupByLibrary.simpleMessage("Select Year"),
        "w20": MessageLookupByLibrary.simpleMessage("Items to Search"),
        "w21": MessageLookupByLibrary.simpleMessage("How can we help?"),
        "w23": MessageLookupByLibrary.simpleMessage("Sort By"),
        "w24": MessageLookupByLibrary.simpleMessage("Add List"),
        "w25": MessageLookupByLibrary.simpleMessage("Add Label"),
        "w26": MessageLookupByLibrary.simpleMessage("Add Task"),
        "w27": MessageLookupByLibrary.simpleMessage("Add note"),
        "w28": MessageLookupByLibrary.simpleMessage("List name"),
        "w29": MessageLookupByLibrary.simpleMessage("Label name"),
        "w3": MessageLookupByLibrary.simpleMessage("Select List"),
        "w30": MessageLookupByLibrary.simpleMessage("Set due date"),
        "w31": MessageLookupByLibrary.simpleMessage("Repeat"),
        "w32": MessageLookupByLibrary.simpleMessage("Remind me"),
        "w33": MessageLookupByLibrary.simpleMessage("Show completed"),
        "w34": MessageLookupByLibrary.simpleMessage("Hide completed"),
        "w35": MessageLookupByLibrary.simpleMessage("Filter tasks"),
        "w36": MessageLookupByLibrary.simpleMessage("Sort"),
        "w37": MessageLookupByLibrary.simpleMessage("No due date"),
        "w38": MessageLookupByLibrary.simpleMessage("Pick a date"),
        "w39": MessageLookupByLibrary.simpleMessage("Mark as important"),
        "w4": MessageLookupByLibrary.simpleMessage("Select Time"),
        "w40": MessageLookupByLibrary.simpleMessage("Move"),
        "w41": MessageLookupByLibrary.simpleMessage("Rename task"),
        "w42": MessageLookupByLibrary.simpleMessage("Rename subtask"),
        "w43": MessageLookupByLibrary.simpleMessage("Task deleted"),
        "w44": MessageLookupByLibrary.simpleMessage("Subtask deleted"),
        "w46": MessageLookupByLibrary.simpleMessage(
            "You don\'t have any labels yet"),
        "w47": MessageLookupByLibrary.simpleMessage(
            "You can search by filtering your tasks"),
        "w48": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete these items?"),
        "w49": MessageLookupByLibrary.simpleMessage(
            "What would you like to search? You can search whatever you want"),
        "w5": MessageLookupByLibrary.simpleMessage("Select Color"),
        "w50": MessageLookupByLibrary.simpleMessage(
            "Unfortunately we couldn\'t find what you\'re looking for"),
        "w51": MessageLookupByLibrary.simpleMessage("Lists"),
        "w53": MessageLookupByLibrary.simpleMessage("Tasks"),
        "w54": MessageLookupByLibrary.simpleMessage("Notes"),
        "w55": MessageLookupByLibrary.simpleMessage("Subtasks"),
        "w56": MessageLookupByLibrary.simpleMessage("Today"),
        "w57": MessageLookupByLibrary.simpleMessage("Tomorrow"),
        "w58": MessageLookupByLibrary.simpleMessage("Yesterday"),
        "w59": MessageLookupByLibrary.simpleMessage("days"),
        "w6": MessageLookupByLibrary.simpleMessage("Select Icon"),
        "w60": MessageLookupByLibrary.simpleMessage("weeks"),
        "w61": MessageLookupByLibrary.simpleMessage("months"),
        "w62": MessageLookupByLibrary.simpleMessage("years"),
        "w63": MessageLookupByLibrary.simpleMessage("Done"),
        "w64": MessageLookupByLibrary.simpleMessage("Cancel"),
        "w65": MessageLookupByLibrary.simpleMessage("Delete"),
        "w66": MessageLookupByLibrary.simpleMessage("Undo"),
        "w7": MessageLookupByLibrary.simpleMessage("Select Label"),
        "w70": MessageLookupByLibrary.simpleMessage("Search"),
        "w71": MessageLookupByLibrary.simpleMessage("Rate it"),
        "w72": MessageLookupByLibrary.simpleMessage("Important"),
        "w73": MessageLookupByLibrary.simpleMessage("Importance"),
        "w74": MessageLookupByLibrary.simpleMessage("Alphabetically"),
        "w75": MessageLookupByLibrary.simpleMessage("Due Date"),
        "w76": MessageLookupByLibrary.simpleMessage("Newest First"),
        "w77": MessageLookupByLibrary.simpleMessage("Oldest First"),
        "w78": MessageLookupByLibrary.simpleMessage("Normal"),
        "w79": MessageLookupByLibrary.simpleMessage("Colored"),
        "w8": MessageLookupByLibrary.simpleMessage("Select Filters"),
        "w80": MessageLookupByLibrary.simpleMessage("Version"),
        "w81": MessageLookupByLibrary.simpleMessage("All"),
        "w82": MessageLookupByLibrary.simpleMessage("Big"),
        "w83": MessageLookupByLibrary.simpleMessage("Understand"),
        "w84": MessageLookupByLibrary.simpleMessage("Bigger"),
        "w85": MessageLookupByLibrary.simpleMessage("Colored Border"),
        "w86": MessageLookupByLibrary.simpleMessage("Creation Date"),
        "w87": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this list and all of its tasks?"),
        "w89": MessageLookupByLibrary.simpleMessage(
            "Taskiee made by independent developer and it needs to be translated to other languages. So, If you want to contribute to the translation please email me from feedback section. It really helps to other people and also me :)"),
        "w9": MessageLookupByLibrary.simpleMessage("Select Language"),
        "w90": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this label?"),
        "w91": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete completed tasks?"),
        "w92": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this task?"),
        "w93": MessageLookupByLibrary.simpleMessage("Please select a list"),
        "w94": MessageLookupByLibrary.simpleMessage("Text cannot be empty"),
        "w95":
            MessageLookupByLibrary.simpleMessage("Data backed up successfully"),
        "w96":
            MessageLookupByLibrary.simpleMessage("Data restored successfully"),
        "w97":
            MessageLookupByLibrary.simpleMessage("An unknown error occurred"),
        "w98": MessageLookupByLibrary.simpleMessage(
            "An error occurred while reading file"),
        "w99": MessageLookupByLibrary.simpleMessage("File not found"),
        "w173": MessageLookupByLibrary.simpleMessage(
            "Line-through completed tasks"),
        "w174": MessageLookupByLibrary.simpleMessage(
            "Show completed tasks in calendar"),
        "w175":
            MessageLookupByLibrary.simpleMessage("Auto-delete completed tasks"),
        "w177": MessageLookupByLibrary.simpleMessage(
            "Disable battery saver in app settings if available"),
        "w178": MessageLookupByLibrary.simpleMessage(
            "Turn on \"AutoStart\" in phone or app settings if available"),
        "w176": MessageLookupByLibrary.simpleMessage(
            "Warning: When enabled, it will delete all your currently completed tasks"),
        "w179": MessageLookupByLibrary.simpleMessage(
            "It looks like you\'ve made some changes. Do you want to save them?"),
        "w180": MessageLookupByLibrary.simpleMessage(
            "Insert new task to the bottom of the list"),
        "w181": MessageLookupByLibrary.simpleMessage(
            "Move completed tasks to the bottom of the list"),
        "w182": MessageLookupByLibrary.simpleMessage(
            "Include subtasks in the calculation of the list\'s completion rate"),
        "w183": MessageLookupByLibrary.simpleMessage(
            "Include subtasks in the calculation"),
        "w184": MessageLookupByLibrary.simpleMessage("Save"),
        "w185": MessageLookupByLibrary.simpleMessage("No"),
        "w186": MessageLookupByLibrary.simpleMessage("Save Task"),
        "w189": MessageLookupByLibrary.simpleMessage("Calculate next due from"),
        "w190": MessageLookupByLibrary.simpleMessage("completion date"),
        "w191": MessageLookupByLibrary.simpleMessage("old due date (default)"),
        "w188": MessageLookupByLibrary.simpleMessage(
            "Darken the bottom navigation bar"),
        "w187": MessageLookupByLibrary.simpleMessage(
            "Warning: If you already have backup file you need to override it. Otherwise, the system will create it as a new file that will consume your storage space unnecessarily. To override, simply tap on it and then press save button"),
      };
}
