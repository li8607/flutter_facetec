package com.facetec.flutter_facetec;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facetec.flutter_facetec.processors.LivenessCheckProcessor;
import com.facetec.flutter_facetec.processors.NetworkingHelpers;
import com.facetec.flutter_facetec.processors.Processor;
import com.facetec.sdk.FaceTecCustomization;
import com.facetec.sdk.FaceTecFaceScanProcessor;
import com.facetec.sdk.FaceTecFaceScanResultCallback;
import com.facetec.sdk.FaceTecSDK;
import com.facetec.sdk.FaceTecSDKStatus;
import com.facetec.sdk.FaceTecSessionActivity;
import com.facetec.sdk.FaceTecSessionResult;
import com.facetec.sdk.FaceTecSessionStatus;

import io.flutter.plugin.common.PluginRegistry;
import okhttp3.Call;
import okhttp3.Callback;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** FlutterFacetecPlugin */
public class FlutterFacetecPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and uÏnregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;

  private String baseUrl;

  private String deviceKeyIdentifier;

  private String publicFaceScanEncryptionKey;

  private String token;

  public Processor latestProcessor;

  private static Result pendingCallbackContext = null;

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
      deviceKeyIdentifier = call.argument("deviceKeyIdentifier");
      publicFaceScanEncryptionKey = call.argument("publicFaceScanEncryptionKey");
      baseUrl = call.argument("baseUrl");
      token =  call.argument("token");
      boolean productionMode = call.argument("productionMode");
      if(productionMode) {
        String productionKeyText =  call.argument("productionKeyText");
        initializeInProductionMode(productionKeyText, deviceKeyIdentifier, publicFaceScanEncryptionKey, result);
      }else {
        initializeInDevelopmentMode(deviceKeyIdentifier, publicFaceScanEncryptionKey, result);
      }
    }  else if (call.method.equals("startLiveness")) {
      startLiveness(result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void initializeInDevelopmentMode(String deviceKeyIdentifier, String publicFaceScanEncryptionKey, MethodChannel.Result result) {
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

  private void initializeInProductionMode(String productionKeyText, String deviceKeyIdentifier, String publicFaceScanEncryptionKey, MethodChannel.Result result) {
    FaceTecSDK.initializeInProductionMode(activity, productionKeyText, deviceKeyIdentifier, publicFaceScanEncryptionKey, new FaceTecSDK.InitializeCallback() {
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
    pendingCallbackContext = new MethodResultWrapper(result);
    activity.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        getSessionToken(new SessionTokenCallback() {
          @Override
          public void onSessionTokenReceived(String sessionToken) {
            latestProcessor = new LivenessCheckProcessor("", activity, baseUrl, deviceKeyIdentifier, token);
          }

          @Override
          public void onSessionTokenFailed(int errorCode, String errorMessage) {
            result.error(errorCode + "", errorMessage, errorMessage);
          }
        });
      }
    });
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.d("onActivityResult", "received result");
    if(pendingCallbackContext==null) {
      return false;
    }
    if (latestProcessor == null) {
      Log.d("onActivityResult", "latestProcessor null");
      return false;
    }
    if (!this.latestProcessor.isSuccess()) {
      Log.d("isSuccess", "not isSuccess");
      pendingCallbackContext.success(false);
    }else {
      pendingCallbackContext.success(true);
    }
    return true;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
  }

  @Override
  public void onCancel(Object arguments) {

  }


  interface SessionTokenCallback {
    void onSessionTokenReceived(String sessionToken);
    void onSessionTokenFailed(int errorCode, String errorMessage);
  }

  public void getSessionToken(final SessionTokenCallback sessionTokenCallback) {
    // Do the network call and handle result
    okhttp3.Request request = new okhttp3.Request.Builder()
            .header("X-Device-Key", deviceKeyIdentifier)
            .header("User-Agent", FaceTecSDK.createFaceTecAPIUserAgentString(""))
            .header("X-User-Agent", FaceTecSDK.createFaceTecAPIUserAgentString(""))
            .url(baseUrl + "/session-token")
            .get()
            .build();
    NetworkingHelpers.getApiClient().newCall(request).enqueue(new Callback() {
      @Override
      public void onFailure(Call call, IOException e) {
        e.printStackTrace();
        Log.d("FaceTecSDKSampleApp", "Exception raised while attempting HTTPS call.");
        sessionTokenCallback.onSessionTokenFailed(-1, e.getMessage());
      }

      @Override
      public void onResponse(Call call, okhttp3.Response response) throws IOException {
        String responseString = response.body().string();
        response.body().close();
        try {
          JSONObject responseJSON = new JSONObject(responseString);
          if(responseJSON.has("sessionToken")) {
            sessionTokenCallback.onSessionTokenReceived(responseJSON.getString("sessionToken"));
          }
          else {
            sessionTokenCallback.onSessionTokenFailed(-1, "Exception raised while attempting to parse JSON result.");
          }
        }
        catch(JSONException e) {
          e.printStackTrace();
          Log.d("FaceTecSDKSampleApp", "Exception raised while attempting to parse JSON result.");
          sessionTokenCallback.onSessionTokenFailed(-1, e.getMessage());
        }
      }
    });
  }

  private static class MethodResultWrapper implements MethodChannel.Result {
    private final MethodChannel.Result methodResult;
    private final Handler handler;

    MethodResultWrapper(final MethodChannel.Result result) {
      this.methodResult = result;
      this.handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void success(final Object result) {
      this.handler.post(
              new Runnable() {
                @Override
                public void run() {
                  MethodResultWrapper.this.methodResult.success(result);
                }
              });
    }

    @Override
    public void error(
            final String errorCode, final String errorMessage, final Object errorDetails) {
      this.handler.post(
              new Runnable() {
                @Override
                public void run() {
                  MethodResultWrapper.this.methodResult.error(errorCode, errorMessage, errorDetails);
                }
              });
    }

    @Override
    public void notImplemented() {
      this.handler.post(
              new Runnable() {
                @Override
                public void run() {
                  MethodResultWrapper.this.methodResult.notImplemented();
                }
              });
    }
  }
}
