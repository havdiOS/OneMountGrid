//
//  WebView.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    private let webView: WKWebView

    init(_ url: String) {
        webView = WKWebView(frame: .zero)
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
