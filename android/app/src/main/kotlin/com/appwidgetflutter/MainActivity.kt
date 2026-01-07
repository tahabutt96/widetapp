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

    private fun requestToPinWidget() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val appWidgetManager: AppWidgetManager? = getSystemService(AppWidgetManager::class.java)
            val myProvider = ComponentName(this, AppWidgetProvider::class.java)
            assert(appWidgetManager != null)
            if (appWidgetManager!!.isRequestPinAppWidgetSupported) {
                val pinnedWidgetCallbackIntent = Intent(this, MainActivity::class.java)
                val successCallback: PendingIntent = PendingIntent.getBroadcast(
                    this, 0,
                    pinnedWidgetCallbackIntent, PendingIntent.FLAG_UPDATE_CURRENT
                )
                val ids = AppWidgetManager.getInstance(this).getAppWidgetIds(
                    ComponentName(
                        this,
                        AppWidgetProvider::class.java
                    )
                )
                if(ids.isEmpty()){
                    appWidgetManager.requestPinAppWidget(myProvider, null, successCallback)
                }else{
                    Toast.makeText(this, "Widget already added to Home screen", Toast.LENGTH_LONG).show()
                }
            }
        }
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
