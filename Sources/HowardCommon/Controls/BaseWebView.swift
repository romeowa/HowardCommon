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
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        InnerWebView(url: url)
    }
}

struct BaseWebView_Previews: PreviewProvider {
    static var previews: some View {
        BaseWebView(url:URL(string: "https://www.naver.com")!)
    }
}

struct InnerWebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<InnerWebView>) {
        
    }
}
