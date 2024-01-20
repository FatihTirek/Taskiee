package com.dev.taskiee;

import android.annotation.SuppressLint;
import android.app.Activity;

import android.content.pm.PackageManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.pm.PackageInfo;
import android.database.Cursor;
import android.media.RingtoneManager;
import android.media.AudioAttributes;
import android.provider.DocumentsContract;
import android.provider.OpenableColumns;
import android.provider.Settings;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.widget.Toast;
import android.os.Bundle;
import android.os.Build;
import android.net.Uri;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private MethodChannel.Result result;
    private MethodCall call;

    private static final String DOWNLOADS_FOLDER = "content://com.android.externalstorage.documents/tree/primary%3ADownloads/document/primary%3ADownloads";
    private static final String METHOD_CHANNEL_NAME = "com.dev.taskiee";
    private static final String CHANNEL_ID = "Task_Notification_ID";
    private static final String FILE_TITLE = "taskiee_backup.json";
    private static final int OPEN_SOUND_PICKER = 1;
    private static final int CREATE_FILE = 2;
    private static final int OPEN_FILE = 3;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL_NAME)
                .setMethodCallHandler((call, result) -> {
                    this.result = result;
                    this.call = call;

                    switch (call.method) {
                        case "showToast":
                            showToast(call.argument("message"));
                            break;
                        case "createFile":
                            createFile();
                            break;
                        case "openFile":
                            openFile();
                            break;
                        case "getSoundUri":
                            result.success(getSoundUri().toString());
                            break;
                        case "openNotificationSettings":
                            openNotificationSettings();
                            break;
                        case "openChannelSettings":
                            openChannelSettings();
                            break;
                        case "getVersionName":
                            result.success(getPackageInfo().versionName);
                            break;
                        case "openSoundPicker":
                            openSoundPicker(call.argument("soundUri"));
                            break;
                    }
                });
    }

    @SuppressLint({"NewApi", "Range"})
    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);

        if (resultCode == Activity.RESULT_OK && intent != null) {
            if (requestCode == OPEN_SOUND_PICKER) {
                Uri uri = intent.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI);

                if (uri != null) {
                    result.success(uri.toString());
                } else {
                    result.success(null);
                }
            } else if (requestCode == CREATE_FILE) {
                Uri uri = intent.getData();

                if (uri != null) {
                    String json = call.argument("json");
                    String error = call.argument("error");
                    String success = call.argument("success");

                    try {
                        OutputStream stream = getContentResolver().openOutputStream(uri);
                        stream.write(Objects.requireNonNull(json).getBytes());
                        stream.close();

                        showToast(success);
                    } catch (IOException e) {
                        showToast(error);
                    }
                }
            } else if (requestCode == OPEN_FILE) {
                Uri uri = intent.getData();

                if (uri != null) {
                    String name = "";

                    try (Cursor cursor = getContentResolver().query(uri, null, null, null)) {
                        if (cursor != null && cursor.moveToFirst()) {
                            name = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                        }
                    }

                    if (name.equals("taskiee_backup.json")) {
                        StringBuilder builder = new StringBuilder();

                        try {
                            InputStream stream = getContentResolver().openInputStream(uri);
                            InputStreamReader inputStreamReader = new InputStreamReader(stream);
                            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                            String json;

                            while ((json = bufferedReader.readLine()) != null) {
                                builder.append(json);
                            }

                            result.success(builder.toString());
                        } catch (IOException e) {
                            result.success("{}");
                        }
                    } else {
                        result.success("{}");
                    }
                } else {
                    result.success("{}");
                }
            }
        }
    }

    @SuppressLint("InlinedApi")
    private void createFile() {
        Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/json");

        intent.putExtra(Intent.EXTRA_TITLE, FILE_TITLE);
        intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(DOWNLOADS_FOLDER));

        startActivityForResult(intent, CREATE_FILE);
    }

    @SuppressLint("InlinedApi")
    private void openFile() {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/json");

        intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(DOWNLOADS_FOLDER));

        startActivityForResult(intent, OPEN_FILE);
    }

    private Uri getSoundUri() {
        return RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
    }

    void showToast(String message) {
        Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
    }

    @SuppressLint("InlinedApi")
    private void openChannelSettings() {
        Intent intent = new Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName())
                .putExtra(Settings.EXTRA_CHANNEL_ID, CHANNEL_ID);
        startActivity(intent);
    }

    @SuppressLint("InlinedApi")
    private void openNotificationSettings() {
        Intent intent;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            intent = new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName());
        } else {
            intent = new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra("app_package", getPackageName())
                    .putExtra("app_uid", getApplicationInfo().uid);
        }

        startActivity(intent);
    }

    private void openSoundPicker(String soundUri) {
        Uri uri = soundUri == null ? getSoundUri() : Uri.parse(soundUri);

        Intent intent = new Intent(RingtoneManager.ACTION_RINGTONE_PICKER);

        intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION);
        intent.putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, uri);

        startActivityForResult(intent, OPEN_SOUND_PICKER);
    }

    private PackageInfo getPackageInfo() {
        Context context = getContext();
        PackageInfo packageInfo = null;

        try {
            packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return packageInfo;
    }
}