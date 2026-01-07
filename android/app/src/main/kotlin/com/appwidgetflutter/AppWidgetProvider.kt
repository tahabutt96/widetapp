package com.appwidgetflutter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import android.widget.TextView
import androidx.annotation.RequiresApi
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import io.flutter.embedding.android.FlutterActivity

class AppWidgetProvider : HomeWidgetProvider() {
    @RequiresApi(Build.VERSION_CODES.S)
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)


                // Swap Title Text by calling Dart Code in the Background
               /* setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                        ?: "No Title Set")*/

                val message = widgetData.getString("message", null)
                val category = widgetData.getString("category", "الفئة")
                val categoryId = widgetData.getString("categoryId", "")
                val favourite = widgetData.getString("favourite", "")
                setTextViewText(R.id.widget_message, message?: "آية")
                setTextViewText(R.id.category_text,category)

                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("homeWidgetExample://message?message=$message"))
                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)

                val backgroundIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("myAppWidget://categoryId?categoryId=$categoryId")
                )
                val favouriteIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("myAppWidget://favourite?favourite=$favourite")
                )
                setOnClickPendingIntent(R.id.category_click, backgroundIntent)
                setOnClickPendingIntent(R.id.heart, favouriteIntent)
                val shareIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("myAppWidget://share")
                )
                setOnClickPendingIntent(R.id.share_button, shareIntent)
//                val backgroundCategoryIntent = HomeWidgetLaunchIntent.getActivity(context,
//                    MainActivity::class.java,
//                    Uri.parse("homeWidgetExample://categoryClick"))
//                setOnClickPendingIntent(R.id.category_click, backgroundCategoryIntent)
            }
            val invisible = RemoteViews(context.packageName, R.layout.no_widget_layout).apply {
            }
            val view = widgetData.getBoolean("view", true);
            if(view){
                views.setViewVisibility(R.id.widget_container, View.VISIBLE)
                appWidgetManager.updateAppWidget(widgetId, views)
            } else {
                appWidgetManager.updateAppWidget(widgetId, invisible)
                views.setViewVisibility(R.id.widget_container, View.GONE)
            }

        }
    }

}

