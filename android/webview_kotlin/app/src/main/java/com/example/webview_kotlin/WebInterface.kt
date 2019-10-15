package com.example.webview_kotlin

import android.content.Context
import android.webkit.JavascriptInterface
import android.widget.Toast

class WebInterface constructor(private val context: Context) {

    @JavascriptInterface
    fun web_to_android(fromWeb: String) {
        Toast.makeText(context, "fromWeb:$fromWeb", Toast.LENGTH_SHORT).show()
    }
}