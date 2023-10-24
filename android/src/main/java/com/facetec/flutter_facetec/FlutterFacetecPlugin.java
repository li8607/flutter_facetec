package com.facetec.flutter_facetec;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facetec.sdk.FaceTecCustomization;
import com.facetec.sdk.FaceTecFaceScanProcessor;
import com.facetec.sdk.FaceTecFaceScanResultCallback;
import com.facetec.sdk.FaceTecSDK;
import com.facetec.sdk.FaceTecSDKStatus;
import com.facetec.sdk.FaceTecSessionActivity;
import com.facetec.sdk.FaceTecSessionResult;
import com.facetec.sdk.FaceTecSessionStatus;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterFacetecPlugin */
public class FlutterFacetecPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_facetec");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initialize")) {
      String deviceKeyIdentifier = call.argument("deviceKeyIdentifier");
      String publicFaceScanEncryptionKey = call.argument("publicFaceScanEncryptionKey");
      initializeSDK(deviceKeyIdentifier, publicFaceScanEncryptionKey, result);
    } else if (call.method.equals("startLiveness")) {
      startLiveness(result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void initializeSDK(String deviceKeyIdentifier, String publicFaceScanEncryptionKey, MethodChannel.Result result) {
    FaceTecCustomization ftCustomization = new FaceTecCustomization();
//    ftCustomization.getOverlayCustomization().brandingImage = R.drawable.ic_
    FaceTecSDK.setCustomization(ftCustomization);

    FaceTecSDK.initializeInDevelopmentMode(activity, deviceKeyIdentifier, publicFaceScanEncryptionKey, new FaceTecSDK.InitializeCallback() {
      @Override
      public void onCompletion(boolean success) {
        if (success) {
          result.success(true);
        }
        else {
          FaceTecSDKStatus status = FaceTecSDK.getStatus(activity);
          result.error(status.name(), status.toString(), null);
        }
      }
    });
  }
//
  private void startLiveness(MethodChannel.Result result) {
    FaceTecSessionActivity.createAndLaunchSession(activity, (sessionResult, faceTecFaceScanResultCallback) -> {
      if(sessionResult.getStatus() != FaceTecSessionStatus.SESSION_COMPLETED_SUCCESSFULLY) {
        Log.d("FaceTecSDKSampleApp", "Session was not completed successfully, cancelling. Session Status: " + sessionResult.getStatus());
        result.error(sessionResult.getStatus().toString(), sessionResult.getStatus().toString(), sessionResult.getStatus());
        return;        // It simply means the User completed the Session and a 3D FaceScan was created.  You still need to perform the Liveness Check on your Servers.

      }
      // IMPORTANT:  FaceTecSDK.FaceTecSessionStatus.SessionCompletedSuccessfully DOES NOT mean the Liveness Check was Successful.
      // Part 4:  Get essential data off the FaceTecSessionResult
      JSONObject parameters = new JSONObject();
      try {
        parameters.put("faceScan", sessionResult.getFaceScanBase64());
        parameters.put("auditTrailImage", sessionResult.getAuditTrailCompressedBase64()[0]);
        parameters.put("lowQualityAuditTrailImage", sessionResult.getLowQualityAuditTrailCompressedBase64()[0]);
        result.success(parameters.toString());
      }catch(JSONException e) {
        e.printStackTrace();
        Log.d("FaceTecSDKSampleApp", "Exception raised while attempting to create JSON payload for upload.");
        result.error("-1", e.getMessage(), e);
      }
    });
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }
}
