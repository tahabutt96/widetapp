package com.appwidgetflutter
 
import android.app.PendingIntent
import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/pinWidget"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(context))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
                if(call!!.method.equals("pinWidget")){
                   var data =  requestToPinWidget()
                    result!!.success(data.toString());
                }else if(call!!.method.equals("remove")){
                    removeAppWidget()
                    result!!.success("removed");
                }
            }
    }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
    }

    private fun requestToPinWidget(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val appWidgetManager: AppWidgetManager? = getSystemService(AppWidgetManager::class.java)
            val myProvider = ComponentName(this, AppWidgetProvider::class.java)

            if (appWidgetManager == null) {
                Toast.makeText(this, "AppWidgetManager unavailable", Toast.LENGTH_LONG).show()
                return "unavailable"
            }

            if (!appWidgetManager.isRequestPinAppWidgetSupported) {
                Toast.makeText(this, "Your launcher doesn't support pinning widgets", Toast.LENGTH_LONG).show()
                return "not_supported"
            }

            return try {
                val requested = appWidgetManager.requestPinAppWidget(myProvider, null, null)
                if (requested) {
                    //Toast.makeText(this, "Pin request sent. Confirm on home screen.", Toast.LENGTH_LONG).show()
                    "requested"
                } else {
                    //Toast.makeText(this, "Pin request was not accepted by launcher", Toast.LENGTH_LONG).show()
                    "rejected"
                }
            } catch (e: Exception) {
                Toast.makeText(this, "Error: ${e.message}", Toast.LENGTH_LONG).show()
                "error: ${e.message}"
            }
        }
        return "api_below_26"
    }
    private fun removeAppWidget(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val appWidgetManager: AppWidgetManager? = getSystemService(AppWidgetManager::class.java)
            val myProvider = ComponentName(this, AppWidgetProvider::class.java)
            appWidgetManager!!.getAppWidgetIds(myProvider)
            var host = AppWidgetHost(context,0)
            appWidgetManager!!.getAppWidgetIds(myProvider).forEach { widgetId->
                host.deleteAppWidgetId(widgetId)
            }
        }
    }
}
