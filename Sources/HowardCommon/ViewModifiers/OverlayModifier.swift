//
//  File.swift
//
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI


public protocol OverlayModifierPresentable: Identifiable, Equatable {}

public struct OverlayModifier<Item: OverlayModifierPresentable, OverlayContent: View>: ViewModifier {
    @Binding var item: Item?
    let overlayContent: OverlayContent
    var allowUserInteraction: Bool = true
    
    @State private var overlayWindow: UIWindow!
    @State private var viewController: UIViewController!
    @State private var transitioning: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .introspectViewController { viewController in
                self.viewController = viewController
            }
            .onChange(of: item) { _ in
                present(overlayContent: overlayContent, allowUserInteraction: allowUserInteraction)
            }
    }
    
    private func present<OverlayContent: View>(overlayContent: OverlayContent, allowUserInteraction: Bool) {
        if transitioning { return }
        
        guard let windowScene = self.viewController.view.window?.windowScene else { return }
        
        if overlayWindow == nil {
            let window = UIWindow()
            window.isUserInteractionEnabled = allowUserInteraction
            window.rootViewController = UIViewController()
            window.backgroundColor = .clear
            window.windowLevel = .alert
            window.windowScene = windowScene
            overlayWindow = window
        }
        
        let rootViewController = overlayWindow.rootViewController!
        let overlayAlreadyPresented = rootViewController.presentedViewController is OverlayHostingController<OverlayContent>
        let anotherOverlayAlreadyPresented = windowScene
            .windows
            .compactMap { String(describing: $0.rootViewController?.presentedViewController) }
            .contains(where: "OverlayHostingController".contains)
        
        if item != nil {
            if anotherOverlayAlreadyPresented { return }
            if overlayAlreadyPresented { return }
            
            transitioning = true
            
            overlayWindow.makeKeyAndVisible()
            
            rootViewController.present(OverlayHostingController(rootView: overlayContent), animated: true) {
                transitioning = false
            }
        } else {
            if !overlayAlreadyPresented, !anotherOverlayAlreadyPresented { return }
            
            rootViewController.dismiss(animated: true) {
                overlayWindow.windowScene = nil
                overlayWindow = nil
                transitioning = false
            }
        }
    }
}

final class OverlayHostingController<Content: View>: UIHostingController<Content> {
    override init(rootView: Content) {
        super.init(rootView: rootView)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct IntrospectionViewController: UIViewControllerRepresentable {
    let targetViewController: (UIViewController) -> Void
    
    init(targetViewController: @escaping (UIViewController) -> Void) {
        self.targetViewController = targetViewController
    }
    
    func makeUIViewController(context _: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context _: Context) {
        DispatchQueue.main.async {
            targetViewController(uiViewController)
        }
    }
}

extension View {
    func introspectViewController(targetViewController: @escaping (UIViewController) -> Void) -> some View {
        background(
            IntrospectionViewController(targetViewController: targetViewController)
                .frame(width: 0, height: 0)
                .disabled(true)
        )
    }
}
