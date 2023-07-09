//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import SwiftUI

public struct NavigationBackButtonModifier<BackView: View>: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    @ViewBuilder var label: () -> BackView
    public init(label: @escaping ()-> BackView) {
        self.label = label
    }
    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    BaseButton {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        label()
                    }
                }
            }
    }
}

