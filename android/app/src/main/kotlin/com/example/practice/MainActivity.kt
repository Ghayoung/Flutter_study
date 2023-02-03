package com.example.practice

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Base64

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.flutter.dev/info"
    private val CHANNEL2 = "com.flutter.dev/encrypto"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceInfo") {
                    val deviceInfo = getDeviceInfo()
                    result.success(deviceInfo)
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
            .setMethodCallHandler { call, result ->
                if (call.method == "getEncrypto") {
                    val data = call.arguments.toString().toByteArray();
                    val changeText = Base64.encodeToString(data, Base64.DEFAULT)
                    result.success(changeText)
                }
            }
    }

    private fun getDeviceInfo(): String {
        val sb = StringBuffer()
        sb.append(Build.DEVICE + "\n")
        sb.append(Build.BRAND + "\n")
        sb.append(Build.MODEL + "\n")
        return sb.toString()
    }
}
