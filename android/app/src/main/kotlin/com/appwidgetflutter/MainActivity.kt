package com.appwidgetflutter

import android.app.PendingIntent
import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.widget.RemoteViews
import android.widget.Toast
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/pinWidget"
    private val WIDGET_PINNED_ACTION = "com.appwidgetflutter.WIDGET_PINNED"
    private var widgetPinnedReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(context))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
                when(call?.method) {
                    "pinWidget" -> {
                        val data = requestToPinWidget()
                        result?.success(data)
                    }
                    "remove" -> {
                        removeAppWidget()
                        result?.success("removed")
                    }
                    else -> result?.notImplemented()
                }
            }
    }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
    }

    /**
     * Creates an enhanced preview of the widget for the pin dialog
     * Uses the widget_preview_layout which shows the app_screen.png image
     */
    private fun createWidgetPreview(): RemoteViews {
        // Use special preview layout that shows the app_screen.png image
        val views = RemoteViews(packageName, R.layout.widget_preview_layout)

        // The preview layout shows the widget_preview.png (app_screen.png) image
        // No need to set any text or data - it's a static preview image

        return views
    }

    /**
     * Registers a broadcast receiver to listen for widget pin success
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun registerWidgetPinnedReceiver() {
        widgetPinnedReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == WIDGET_PINNED_ACTION) {
                    // Widget was successfully pinned - update it immediately with current data
                    updateAllWidgets()
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(
                widgetPinnedReceiver,
                IntentFilter(WIDGET_PINNED_ACTION),
                Context.RECEIVER_NOT_EXPORTED
            )
        } else {
            registerReceiver(widgetPinnedReceiver, IntentFilter(WIDGET_PINNED_ACTION))
        }
    }

    /**
     * Updates all existing widgets with the latest data
     */
    private fun updateAllWidgets() {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val myProvider = ComponentName(context, AppWidgetProvider::class.java)
        val widgetIds = appWidgetManager.getAppWidgetIds(myProvider)

        if (widgetIds.isNotEmpty()) {
            val updateIntent = Intent(context, AppWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
            }
            context.sendBroadcast(updateIntent)
        }
    }

    /**
     * Requests to pin the widget to the user's home screen
     * Returns a status string indicating the result
     */
    private fun requestToPinWidget(): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return "api_below_26"
        }

        val appWidgetManager = getSystemService(AppWidgetManager::class.java)
        val myProvider = ComponentName(this, AppWidgetProvider::class.java)

        if (appWidgetManager == null) {
            return "unavailable"
        }

        if (!appWidgetManager.isRequestPinAppWidgetSupported) {
            return "not_supported"
        }

        return try {
            // Register receiver to handle successful pin
            registerWidgetPinnedReceiver()

            // Create enhanced preview bundle
            val bundle = Bundle().apply {
                putParcelable(AppWidgetManager.EXTRA_APPWIDGET_PREVIEW, createWidgetPreview())
            }

            // Create success callback
            val successIntent = Intent(WIDGET_PINNED_ACTION).apply {
                setPackage(packageName)
            }
            val successCallback = PendingIntent.getBroadcast(
                this,
                0,
                successIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Request to pin the widget
            val requested = appWidgetManager.requestPinAppWidget(
                myProvider,
                bundle,
                successCallback
            )

            if (requested) "requested" else "rejected"
        } catch (e: SecurityException) {
            "security_error: ${e.message}"
        } catch (e: IllegalStateException) {
            "state_error: ${e.message}"
        } catch (e: Exception) {
            "error: ${e.message}"
        }
    }
    /**
     * Removes all app widgets from the home screen
     */
    private fun removeAppWidget() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val appWidgetManager = getSystemService(AppWidgetManager::class.java) ?: return
        val myProvider = ComponentName(this, AppWidgetProvider::class.java)
        val widgetIds = appWidgetManager.getAppWidgetIds(myProvider)

        if (widgetIds.isNotEmpty()) {
            val host = AppWidgetHost(context, 0)
            widgetIds.forEach { widgetId ->
                try {
                    host.deleteAppWidgetId(widgetId)
                } catch (e: Exception) {
                    // Widget might already be deleted
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Unregister the receiver to prevent memory leaks
        widgetPinnedReceiver?.let {
            try {
                unregisterReceiver(it)
            } catch (e: Exception) {
                // Receiver might not be registered
            }
        }
    }
}
