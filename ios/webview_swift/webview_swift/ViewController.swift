//
//  ViewController.swift
//  webview_swift
//
//  Created by jinreol kim on 11/10/2019.
//  Copyright © 2019 jinreol kim. All rights reserved.
//

import UIKit
import WebKit

// WKNavigationDelegate: 접속, 로딩, 완료의 진행상태를 알려준다.
// WKUIDelegate: 네이티브 유저 인터페이스 엘리먼트 위에서의 웹페이지 행동를 알려준다.
// WKScriptMessageHandler: 자바스크립트 메시지 수집
// , WKUIDelegate, WKScriptMessageHandler
//https://medium.com/capital-one-tech/javascript-manipulation-on-ios-using-webkit-2b1115e7e405

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler  {

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
    override func loadView() {
        
        let targetURL = "http://172.20.10.8:8888"
        //let targetURL = "http://10.0.1.49:8888"
//var targetURL = "https://www.apple.com"
        
        let contentController = WKUserContentController()
//        let scriptSource = "document.body.style.backgroundColor=`red`;"
//        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        contentController.addUserScript(script)
//
        contentController.add(self, name: "web_to_ios")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.view = webView
        
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        
    }

    //--------------------------------------------------//
    //  WKNavigationDelegate                            //
    //--------------------------------------------------//
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("웹뷰가 웹 컨텐츠를 받기 시작할 때 호출됩니다.");
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹 컨텐츠가 웹뷰에서 로드되기 시작할 때 호출됩니다.");
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("웹뷰가 서버 리디렉션을 수신 할 때 호출됩니다.")
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 사설 인증서로 구성된 서버로 접근이 가능합니다.
        print("탐색 허용 여부를 결정합니다.")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 사설 인증서로 구성된 서버로 접근이 가능합니다.
        print("웹뷰가 인증 요청에 응답해야 할 때 호출됩니다.")
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("탐색 중에 오류가 발생하면 호출됩니다.")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("웹보기가 내용을로드하는 동안 오류가 발생하면 호출됩니다.")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("탐색이 완료되면 호출됩니다.")
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("웹뷰의 웹 콘텐츠 프로세스가 종료 될 때 호출됩니다.")
    }
    
    //
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //        print("응답이 알려진 후 탐색을 허용할지 또는 취소 할지를 결정합니다.")
    //    }
    //
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
    //        print("instance method")
    //    }
    
    //--------------------------------------------------//
    //  WKUIDelegate                                    //
    //--------------------------------------------------//
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("자바스크립트 alert를 표시합니다.")
        let ac = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        completionHandler()
    }

    //--------------------------------------------------//
    //  WKNavigation                                    //
    //--------------------------------------------------//
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "web_to_ios", let messageBody = message.body as? String {
            print(messageBody)
        }
        
    }
    
    
    
    
    
    
    
    

    
    
    
    
    

//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print("received message")
//        if message.name == "web_to_ios" {
//            print("web_to_ios:", message.body);
//        }
//    }
}

