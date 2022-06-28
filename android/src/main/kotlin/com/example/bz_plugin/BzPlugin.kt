package com.example.bz_plugin

import android.app.Activity
import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import com.bazaarvoice.bvandroidsdk.BVEventValues
import com.bazaarvoice.bvandroidsdk.BVPageViewEvent
import com.bazaarvoice.bvandroidsdk.BVPixel
import com.cesarferreira.tempo.isToday
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat
import java.util.*


/** BzPlugin */
class BzPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bz_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "isToday" -> isToday(call, result)
      "BVPageViewEvent" -> BVPageViewEvent(call, result)
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun isToday(@NonNull call: MethodCall, @NonNull result: Result) {
    var arguments = call.arguments as Map<String, Any>
    var dateTime = arguments["dateTime"] as String
    var localDate = dateTime.toDate()
    var checkToday = localDate.isToday // library Tempo check isToday
    result.success(checkToday)
  }

  private fun BVPageViewEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    var arguments = call.arguments as Map<String, Any>
    var productId = arguments["productId"] as String
    var category = arguments["category"] as String
    var clientId = arguments["clientId"] as String

    BVPixel.builder(context, clientId, false, false, Locale.getDefault())
            .bgHandlerThread(optionalBackgroundHandlerThread)
            .okHttpClient(optionalOkHttpClient)
            .build();

    val event = BVPageViewEvent(
            productId,
            BVEventValues.BVProductType.CONVERSATIONS_REVIEWS,
            category
    )

    BVPixel.getInstance().track(event)
  }

  private fun String.toDate(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss", timeZone: TimeZone = TimeZone.getTimeZone("UTC")): Date {
    val parser = SimpleDateFormat(dateFormat, Locale.getDefault())
    parser.timeZone = timeZone
    return parser.parse(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}
