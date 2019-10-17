package com.example.webview_java;

import androidx.appcompat.app.AppCompatActivity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View.MeasureSpec;
import android.view.ViewTreeObserver;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.gun0912.tedpermission.PermissionListener;
import com.gun0912.tedpermission.TedPermission;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;


public class MainActivity extends AppCompatActivity {

    final String url = "http://10.17.119.151:8888/";
    private static final String TAG = "fromWeb";

    private Gson gson = new Gson();
    private WebView webView;
    private Bitmap bitmap;

    @Override
    @SuppressLint("SetJavaScriptEnabled")
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WebView.setWebContentsDebuggingEnabled(true);
        WebView.enableSlowWholeDocumentDraw();

        setContentView(R.layout.activity_main);
        webView = findViewById(R.id.webView);

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);

        webView.addJavascriptInterface(new JavaScriptInterface(), "Android");
        webView.loadUrl(url);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
            }



        });

        TedPermission.with(this)
                .setPermissionListener(permissionListener)
                .setRationaleMessage("화면 캡쳐를 위해서 파일 읽기/쓰기, 화면오버레이 권한이 필요합니다.")
                .setDeniedMessage("권한을 거부하셨습니다.")
                .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE)
                .check();
    }



    PermissionListener permissionListener = new PermissionListener() {
        @Override
        public void onPermissionGranted() {
        }

        @Override
        public void onPermissionDenied(List<String> deniedPermissions) {
        }
    };

    class JavaScriptInterface {
        @JavascriptInterface
        public void web_to_android(String fromWeb) {

            Toast.makeText(MainActivity.this, "fromWeb:"+fromWeb, Toast.LENGTH_SHORT).show();

            JsonObject reader = gson.fromJson(fromWeb, JsonObject.class);
            String value = reader.get("command").getAsString();

            Log.d(TAG, "web_to_android: value:"+value);

            switch (value) {
                case "capture": {
                    webView.post(new Runnable() {
                        @Override
                        public void run() {
                            int contentHeight = webView.getContentHeight();
                            Log.d(TAG, "onPageFinished: contentHeight:"+contentHeight);

                            int measuredHeight = webView.getMeasuredHeight();
                            Log.d(TAG, "onPageFinished: measuredHeight:"+measuredHeight);

                            int measuredWidth = webView.getMeasuredWidth();
                            Log.d(TAG, "onPageFinished: measuredWidth:"+measuredWidth);

                            float scaleX = webView.getScaleX();
                            float scaleY = webView.getScaleX();

                            Log.d(TAG, "onPageFinished: scaleX:"+scaleX);
                            Log.d(TAG, "onPageFinished: scaleY:"+scaleY);

                            float scale = webView.getScale();
                            Log.d(TAG, "onPageFinished: scale:"+scale);

                            int width = webView.getWidth();
                            int height = (int) (contentHeight * scale);

                            Log.d(TAG, "onPageFinished: width:"+width);
                            Log.d(TAG, "onPageFinished: height:"+height);

                            int scrollX = webView.getScrollX();
                            int scrollY = webView.getScrollY();

                            Log.d(TAG, "onPageFinished: scrollX:"+scrollX);
                            Log.d(TAG, "onPageFinished: scrollY:"+scrollY);

                            bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
                            Canvas canvas = new Canvas(bitmap);
                            webView.draw(canvas);

                            int nextPosition = height - measuredHeight;
                            String sendJson = "{\"type\": \"android\", \"command\": \"scroll_down\", " +
                                    "\"data\": { \"Y\": "+nextPosition+"}";

                            Log.d(TAG, "onPageFinished: sendJson:"+sendJson);

                            webView.loadUrl("javascript:android_to_web('"+sendJson+"');");

                             try {

                                 String directoryPath = Environment.getExternalStorageDirectory().toString() + File.separator + "4grit";
                                 File directory = new File(directoryPath);

                                 if (!directory.exists()) {
                                     if (directory.mkdir()) {
                                         Log.e(TAG, "was not successful.");
                                     }
                                 }

                                 if (directory.isDirectory()) {
                                     String[] children = directory.list();
                                     if (children != null) {
                                         for (String child: children) {
                                             if (child != null && !child.isEmpty()) {
                                                 boolean result = new File(directory, child).delete();
                                                 if (result) {
                                                     Log.d(TAG, directory+File.separator+child+" is deleted");
                                                 }
                                             }
                                         }
                                     }

                                 }

                                 Date currentDate = new Date();
                                 String fileName = new SimpleDateFormat("yyyyMMdd_hhmmss", Locale.US).format(currentDate);

                                 String mPath = directoryPath + File.separator + fileName + ".png";

                                 File imageFile = new File(mPath);
                                 FileOutputStream outputStream = new FileOutputStream(imageFile);
                                 int quality = 0;
                                 bitmap.compress(Bitmap.CompressFormat.PNG, quality, outputStream);
                                 outputStream.flush();
                                 outputStream.close();
                             } catch (IOException e) {
                                 e.printStackTrace();
                             }



                        }
                    });

                }
                break;

                case "capture2": {
                    webView.post(new Runnable() {

                        @Override
                        public void run() {

                        }
                    });
                }
                //viewInfo();
                break;
            }
        }
    }

}
