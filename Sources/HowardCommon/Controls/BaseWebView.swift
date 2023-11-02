//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import SwiftUI
import WebKit

public struct BaseWebView: View {
    let url: URL
    @Binding var reload: Bool
    
    public init(url: URL, reload: Binding<Bool>) {
        self.url = url
        _reload = reload
    }
    
    public var body: some View {
        InnerWebView(url: url, reload: $reload)
    }
}

struct BaseWebView_Previews: PreviewProvider {
    @State static var reload = false
    static var previews: some View {
        BaseWebView(url:URL(string: "https://www.naver.com")!, reload: $reload)
    }
}

struct InnerWebView: UIViewRepresentable {
    var url: URL
    @Binding var reload: Bool
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<InnerWebView>) {
        uiView.reload()
    }
}
