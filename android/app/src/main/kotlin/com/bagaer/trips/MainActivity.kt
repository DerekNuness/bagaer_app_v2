package com.bagaer.trips

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import android.net.Uri
import android.content.Context
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.OutputStream

class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.bagaer.trips/downloads"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "saveFileToPublic" -> {
          val tempPath = call.argument<String>("tempPath")
          val filename = call.argument<String>("filename")
          val directory = call.argument<String>("directory") ?: "Download"
          if (tempPath == null || filename == null) {
            result.error("INVALID_ARGS", "tempPath or filename was null", null)
            return@setMethodCallHandler
          }
          try {
            val uriOrPath = saveFileToPublic(this, tempPath, filename, directory)
            result.success(uriOrPath)
          } catch (e: Exception) {
            result.error("SAVE_FAILED", e.message ?: "unknown", null)
          }
        }
        else -> result.notImplemented()
      }
    }
  }

  private fun saveFileToPublic(context: Context, tempPath: String, filename: String, directory: String): String {
    val tempFile = File(tempPath)
    if (!tempFile.exists()) throw Exception("Arquivo temporário não existe")

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      val resolver = context.contentResolver
      val values = ContentValues().apply {
        put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
        put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
        put(MediaStore.MediaColumns.RELATIVE_PATH, "$directory/")
      }

      val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
      val uri: Uri? = resolver.insert(collection, values)
      if (uri == null) throw Exception("Não foi possível criar entrada no MediaStore")

      resolver.openOutputStream(uri).use { out ->
        FileInputStream(tempFile).use { input ->
          input.copyTo(out!!)
        }
      }
      return uri.toString()
    } else {
      val publicDir = when (directory.lowercase()) {
        "download", "downloads" -> Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        "documents" -> Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)
        else -> Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
      }

      if (!publicDir.exists()) publicDir.mkdirs()
      val dest = File(publicDir, filename)
      FileInputStream(tempFile).use { input ->
        FileOutputStream(dest).use { output ->
          input.copyTo(output)
        }
      }
      return dest.absolutePath
    }
  }
}
