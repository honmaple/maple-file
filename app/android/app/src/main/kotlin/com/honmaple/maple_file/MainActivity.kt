package com.honmaple.maple_file

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.honmaple.maple_file.server.Server

class MainActivity: FlutterActivity() {
  private val CHANNEL = "honmaple.com/maple_file"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call,
        result ->
      if (call.method.equals("Start")) {
        try {
            val addr = Server.start(call.arguments as String)
            result.success(addr);
        } catch (e: Exception) {
            result.error("GRPC", e.message, null);
        }
      } else {
        result.notImplemented()
      }
    }
  }
}