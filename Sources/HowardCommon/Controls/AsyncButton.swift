//
//  File.swift
//
//
//  Created by howard on 4/11/24.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    public init(
        progressColor: Color = Color.yellow,
        action: @escaping () async -> Void,
        label: @escaping () -> Label
    ) {
        self.progressColor = progressColor
        self.action = action
        self.label = label
    }
    
    var progressColor: Color
    var action: () async -> Void
    @ViewBuilder var label: () -> Label
    @State private var isPerformingTask = false
    
    public var body: some View {
        BaseButton {
            isPerformingTask = true
            Task {
                defer {
                    isPerformingTask = false
                }
                await action()
            }
        } label: {
            label()
                .overlay {
                    if isPerformingTask  {
                        VStack {
                            Spacer()
                            HStack(alignment: .center) {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: progressColor))
                                    .frame(width:16, height: 16)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
        }
        .disabled(isPerformingTask)
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        AsyncButton {
            
        } label: {
            Text("로그인")
        }
        
    }
}
