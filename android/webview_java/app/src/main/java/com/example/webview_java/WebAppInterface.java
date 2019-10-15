package com.example.webview_java;

import android.content.Context;
import android.webkit.JavascriptInterface;
import android.widget.Toast;

public class WebAppInterface {

    private Context context;

    WebAppInterface(Context c) {
        context = c;
    }

    @JavascriptInterface
    public void web_to_android(String fromWeb) {
        Toast.makeText(context, "fromWeb:"+fromWeb, Toast.LENGTH_SHORT).show();
    }
}
