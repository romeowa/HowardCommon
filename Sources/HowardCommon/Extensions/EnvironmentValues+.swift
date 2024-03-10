//
//  File.swift
//
//
//  Created by howard on 11/14/23.
//

import UIKit
import SwiftUI

public struct WindowKey: EnvironmentKey {
    public struct Value {
        weak var value: UIWindow?
    }
    
    public static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
    public var window: UIWindow? {
        get { return self[WindowKey.self].value }
        set { self[WindowKey.self] = .init(value: newValue) }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return EdgeInsets() }
        return windowScene.windows.first?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    public var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

