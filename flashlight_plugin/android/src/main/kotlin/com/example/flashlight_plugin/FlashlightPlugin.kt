package com.example.flashlight_plugin

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlashlightPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var applicationContext: Context
    private lateinit var channel: MethodChannel
    private var isTorchOn = false
    private var cameraId: String? = null

    override fun onAttachedToEngine(
        flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    ) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "flashlight_plugin",
        )
        channel.setMethodCallHandler(this)
        cameraId = findFlashCameraId()
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "toggleFlashlight" -> result.success(setTorch(!isTorchOn))
            "turnOnFlashlight" -> result.success(setTorch(true))
            "turnOffFlashlight" -> result.success(setTorch(false))
            "isFlashlightOn" -> result.success(isTorchOn)
            "isFlashlightSupported" -> result.success(isSupported())
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun isSupported(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
            applicationContext.packageManager.hasSystemFeature(
                PackageManager.FEATURE_CAMERA_FLASH,
            ) &&
            cameraId != null
    }

    private fun setTorch(enabled: Boolean): Boolean {
        if (!isSupported()) return false
        val manager = applicationContext.getSystemService(
            Context.CAMERA_SERVICE,
        ) as CameraManager
        val id = cameraId ?: return false

        return try {
            manager.setTorchMode(id, enabled)
            isTorchOn = enabled
            isTorchOn
        } catch (_: Exception) {
            false
        }
    }

    private fun findFlashCameraId(): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return null

        val manager = applicationContext.getSystemService(
            Context.CAMERA_SERVICE,
        ) as CameraManager
        return try {
            manager.cameraIdList.firstOrNull { id ->
                val characteristics = manager.getCameraCharacteristics(id)
                val flashAvailable =
                    characteristics.get(
                        CameraCharacteristics.FLASH_INFO_AVAILABLE,
                    ) == true
                val lensFacing =
                    characteristics.get(CameraCharacteristics.LENS_FACING)

                flashAvailable &&
                    lensFacing == CameraCharacteristics.LENS_FACING_BACK
            }
        } catch (_: Exception) {
            null
        }
    }
}
