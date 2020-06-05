package com.example.fluggy;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Bundle;
import android.util.Base64;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements PluginRegistry.PluginRegistrantCallback {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    printKeyHash();
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
  }

  private void printKeyHash() {
    // Add code to print out the key hash
    try {
      PackageInfo info = getPackageManager().getPackageInfo("com.example.fluggy", PackageManager.GET_SIGNATURES);
      for (Signature signature : info.signatures) {
        MessageDigest md = MessageDigest.getInstance("SHA");
        md.update(signature.toByteArray());
        Log.d("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT));
      }
    } catch (PackageManager.NameNotFoundException e) {
      Log.e("KeyHash:", e.toString());
    } catch (NoSuchAlgorithmException e) {
      Log.e("KeyHash:", e.toString());
    }
  }
}
