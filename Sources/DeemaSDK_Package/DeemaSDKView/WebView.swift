//
//  WebView.swift
//  DeemaSDK
//
//  Created by Taimur Imam on 28/11/24.
import SwiftUI
@preconcurrency import WebKit


struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var currentURL: String
    @Binding var isRemove: Bool
    @Binding var isLoading: Bool
    var environment : Environment
    let paymentCompleted:(_ status : PaymentStatus , _ message : String )-> Void
//    let successUrl =   "https://staging-pay.deema.me/sdk/success"
//    let failureUrl = "https://staging-pay.deema.me/sdk/failure"
    let successUrl =   "sdk/success"
    let failureUrl = "sdk/failure"

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Update the web view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Detect when the navigation finishes
            parent.currentURL = webView.url?.absoluteString ?? ""
            parent.isLoading = false
            let url : String = webView.url?.absoluteString ?? ""

            if url.contains(parent.successUrl){
                self.parent.paymentCompleted(.success, "")
            }else
            if url.contains(parent.successUrl){
                self.parent.paymentCompleted(.failure, "Payment failed.")
            }
        }
        
        private func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Detect redirects or new navigation
            
            if let url = navigationAction.request.url {
                print("hello ....") 
                print(url.absoluteString)
                
                if url.absoluteString.contains(parent.successUrl){
                    self.parent.paymentCompleted(.success, "")
                }else
                if url.absoluteString.contains(parent.successUrl){
                    self.parent.paymentCompleted(.failure, "Payment failed.")
                }
                parent.currentURL = url.absoluteString
            }
            decisionHandler(.allow)
        }
    }
}

