package com.example.flutter_foreground_beacon;

import android.content.BroadcastReceiver;
import android.util.Log;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

public class MainActivity extends FlutterActivity {
  private static final String BATTERY_CHANNEL = "samples.flutter.io/battery";
  private static final String CHARGING_CHANNEL = "samples.flutter.io/charging";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new EventChannel(flutterEngine.getDartExecutor(), CHARGING_CHANNEL).setStreamHandler(
      new StreamHandler() {
        private BroadcastReceiver chargingStateChangeReceiver;
        EventSink eventSink = null;

        @Override
        public void onListen(Object arguments, EventSink events) {
          eventSink = events;
          new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
              //Write whatever to want to do after delay specified (1 sec)
              eventSink.success("charging");
            }
          }, 500);
        }

        @Override
        public void onCancel(Object arguments) {
        }
      }
    );

    new MethodChannel(flutterEngine.getDartExecutor(), BATTERY_CHANNEL).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          if (call.method.equals("getBatteryLevel")) {
            String name = call.argument("name");
            int age = call.argument("age");
            Log.d("test", "name="+name);
            int batteryLevel = 12;

            if (batteryLevel != -1) {
              result.success(batteryLevel);
            } else {
              result.error("UNAVAILABLE", "Battery level not available.", null);
            }
          } else {
            result.notImplemented();
          }
        }
      }
    );
  }

}
