package com.example.webview_kotlin

import android.annotation.SuppressLint
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView

class MainActivity : AppCompatActivity() {

    private val url = "http://172.20.10.8:8888/"

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val webView: WebView = findViewById(R.id.webView)
        WebView.setWebContentsDebuggingEnabled(true)

        val webSettings: WebSettings = webView.settings
        webSettings.javaScriptEnabled = true

        webView.addJavascriptInterface(WebInterface(this), "Android")
        webView.loadUrl(url)



    }
}
