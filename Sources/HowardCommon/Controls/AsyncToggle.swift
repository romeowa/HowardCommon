//
//  File.swift
//  
//
//  Created by howard on 3/24/24.
//

import SwiftUI

struct AsyncToggle: View {
    @State var title: String
    @State var description: String = ""
    @State private(set) var isProgressing = false
    @State private var bodySize = CGSize.zero
    @Binding var isOn: Bool
    var action: () async -> Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(Font.system(size: 16))
                        .foregroundColor(Color.black)
                    if description.isNotEmpty {
                        Text(description)
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.gray)
                            .padding(.top, 2)
                    }
                }
                Spacer()
                ZStack {
                    Toggle(isOn: $isOn) {
                        EmptyView()
                    }
                    .frame(width: 51)
                    .buttonStyle(.plain)
                    .tint(Color.primary)
                    .allowsHitTesting(false)
                    .isHidden(isProgressing)
                    
                    ProgressView()
                        .frame(width: 51)
                        .progressViewStyle(.circular)
                        .allowsHitTesting(false)
                        .isHidden(!isProgressing)
                }
            }
            
            Button() {
                Task {
                    withAnimation {
                        isProgressing = true
                    }
                    
                    let result = await action()
                    DispatchQueue.main.async {
                        withAnimation {
                            isProgressing = false
                            isOn = result
                        }
                    }
                }
            } label: {
                Rectangle()
                    .foregroundColor(.clear)
            }
            .allowsHitTesting(!isProgressing)
            .frame(width: bodySize.width, height: bodySize.height)
        }
        .background(.clear)
        .readSize { size in
            bodySize = size
        }
    }
}

struct AsyncToggle_Previews: PreviewProvider {
    @State static var isOn = true
    static var previews: some View {
        AsyncToggle(title: "캘린더 연결을 하면 정말로 좋을수도 있겠지만 꼭 그렇게 해야 하는지는 모르겠습니다.",description: "내 미팅 일정이 있을 경우 미리 알림을 받을 수 있습니다.", isOn: $isOn) {
            return true
        }
        .padding(.horizontal, 80)
    }
}

