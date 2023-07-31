//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

public struct BottomSheetItem: OverlayModifierPresentable {
    public init(id: UUID = UUID(), contentView: AnyView, opacity: Double? = 0.4, dismissByBackground: Bool = true) {
        self.id = id
        self.contentView = contentView
        self.opacity = opacity
        self.dismissByBackground = dismissByBackground
    }
    
    public var id = UUID()
    public let contentView: AnyView
    public var opacity: Double?
    public var dismissByBackground = true
    
    
    
    public static func == (lhs: BottomSheetItem, rhs: BottomSheetItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    public func showBottomSheet(item: Binding<BottomSheetItem?>) -> some View {
        modifier(OverlayModifier(item: item, overlayContent: BottomSheetItemView(bottomSheetItem: item)))
    }
}

public struct BottomSheetItemView: View {
    @Binding var bottomSheetItem: BottomSheetItem?
    @State var showContent = false {
        didSet {
            if showContent == false {
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        bottomSheetItem = nil
                    }
                }
            }
        }
    }
    
    
    private let defaultOffset = 70.0
    private let threshold = 10.0
    private let minTopPadding = -30.0
    @State private var offsetY: Double = 70.0
    @State private var oldTranslationY: Double = .zero
    
    @State private var gaps: [Double] = []
    
    public var body: some View {
        if let view = bottomSheetItem?.contentView {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if bottomSheetItem?.dismissByBackground == true {
                            withAnimation {
                                showContent = false
                            }
                        }
                    }
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 20)
                        .background(
                            Rectangle()
                                .frame(height: 40)
                                .cornerRadius(20)
                                .foregroundColor(Colors.white)
                                .offset(y:10)
                        )
                        .overlay {
                            Rectangle()
                                .frame(width: 40, height: 4)
                                .foregroundColor(Colors.gray300)
                                .cornerRadius(2)
                        }
                    VStack(spacing: 0) {
                        view
                    }
                    .frame(maxWidth: .infinity)
                    .background(Colors.white)
                    
                    Rectangle()
                        .frame(height: defaultOffset)
                        .foregroundColor(Colors.white)
                }
                .offset(y: self.offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height < minTopPadding { return }
                            
                            let gapY = value.translation.height - oldTranslationY
                            self.gaps.append(gapY)
                            self.offsetY = value.translation.height + defaultOffset
                            self.oldTranslationY = value.translation.height
                        }
                        .onEnded { value in
                            let gap = value.translation.height - oldTranslationY
                            self.gaps.append(gap)
                            let count = min(self.gaps.count, 3)
                            let sum = self.gaps[(self.gaps.count - count) ... (self.gaps.count - 1)].reduce(0) { partialResult, partialValue in
                                partialResult + partialValue
                            }
                            
                            if (sum / Double(count)) > threshold {
                                withAnimation {
                                    showContent = false
                                }
                            } else {
                                withAnimation {
                                    self.offsetY = defaultOffset
                                }
                            }
                        }
                )
                .transition(.move(edge: .bottom))
                .isHidden(!showContent)
            }
            .onAppear() {
                DispatchQueue.main.async {
                    withAnimation {
                        showContent = true
                    }
                }
                
            }
            
        } else {
            EmptyView()
        }
    }
}


struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                    }
                }
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 20)
                    .background(
                        Rectangle()
                            .frame(height: 40)
                            .cornerRadius(20)
                            .foregroundColor(Colors.white)
                            .offset(y:10)
                    )
                    .overlay {
                        Rectangle()
                            .frame(width: 40, height: 4)
                            .foregroundColor(Colors.gray300)
                            .cornerRadius(2)
                    }
                
                VStack(spacing: 0) {
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                    Text("aaaa")
                }
                .frame(maxWidth: .infinity)
                .background(Colors.white)
            }
            .transition(.move(edge: .bottom))
        }
    }
}
