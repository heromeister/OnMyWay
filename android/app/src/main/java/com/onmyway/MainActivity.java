package com.onmyway;

import android.content.Intent;
import android.os.Bundle;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "plugin_google_maps";
  private static final String METHOD_SWITCH_VIEW = "switchView";

  private MethodChannel.Result result;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            MainActivity.this.result = result;
            Object location = methodCall.arguments;
            if(methodCall.method.equals(METHOD_SWITCH_VIEW)) {
              onLaunchFullScreen(location);
            }
          }
        }
    );
  }

  private void onLaunchFullScreen(Object location) {
    /*Intent fullScreenIntent = new Intent(this, CountActivity.class);
    fullScreenIntent.putExtra(CountActivity.EXTRA_COUNTER, count);
    startActivityForResult(fullScreenIntent, COUNT_REQUEST);*/
  }
}
