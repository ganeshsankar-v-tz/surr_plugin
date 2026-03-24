package com.example.surr_plugin.surr_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.Manifest
import android.content.Context
import androidx.core.content.ContextCompat
import `in`.museinc.android.surr_ui_kit.recorder.RecorderActivity
import `in`.museinc.android.surr_ui_kit.player.PlayerActivity
import `in`.museinc.android.surr_core.utils.PreFilter
import `in`.museinc.android.surr_core.utils.SurrUtils

/** SurrPlugin */
class SurrPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "surr_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isTaalDeviceConnected" -> {
                val ctx = activity ?: context
                if (ctx == null) {
                    result.error("NO_CONTEXT", "Context is null", null)
                    return
                }
                val status = SurrUtils.isTaalDeviceConnected(ctx)
                result.success(status.ordinal)
            }
            "startRecorder" -> {
                val act = activity
                if (act == null) {
                    result.error("NO_ACTIVITY", "Activity is null", null)
                    return
                }

                // Check for audio recording permission
                if (ContextCompat.checkSelfPermission(act, Manifest.permission.RECORD_AUDIO) 
                    != PackageManager.PERMISSION_GRANTED) {
                    result.error("PERMISSION_DENIED", "Audio recording permission is required", "RECORD_AUDIO")
                    return
                }

                val rawPath = call.argument<String>("rawAudioFilePath")!!
                val filteredPath = call.argument<String>("preFilterAudioFilePath")!!
                val playback = call.argument<Boolean>("playback") ?: true
                val recordingTime = call.argument<Int>("recordingTime") ?: 30
                val preAmplification = call.argument<Int>("preAmplification") ?: 5
                val filterIndex = call.argument<Int>("preFilter") ?: 0

                val filter = when (filterIndex) {
                    0 -> PreFilter.HEART
                    1 -> PreFilter.LUNGS
                    2 -> PreFilter.BOWEL
                    3 -> PreFilter.PREGNANCY
                    4 -> PreFilter.FULL_BODY
                    else -> PreFilter.HEART
                }

                val intent = RecorderActivity.getIntent(
                    act,
                    rawPath,
                    filteredPath,
                    playback,
                    recordingTime,
                    preAmplification,
                    filter
                )
                act.startActivity(intent)
                result.success(null)
            }
            "startPlayer" -> {
                val act = activity
                if (act == null) {
                    result.error("NO_ACTIVITY", "Activity is null", null)
                    return
                }
                val path = call.argument<String>("filePath")!!
                val intent = PlayerActivity.getIntent(act, path)
                act.startActivity(intent)
                result.success(null)
            }
            "readSampleRate" -> {
                val path = call.argument<String>("path")!!
                val sampleRate = SurrUtils.readSampleRate(path)
                result.success(sampleRate)
            }
            "getFloatBuffer" -> {
                val path = call.argument<String>("path")!!
                val buffer = SurrUtils.getFloatBuffer(path)
                result.success(buffer)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
