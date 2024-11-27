//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import UIKit

// https://medium.com/hcleedev/swift-custom-navigationview%EC%97%90%EC%84%9C-swipe-back-%EA%B0%80%EB%8A%A5%ED%95%98%EA%B2%8C-%ED%95%98%EA%B8%B0-c3c519c59bcb
// BackButton을 custom 하기 위해서 back swipe를 지원하기 위함.
extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

