//
//  File.swift
//  
//
//  Created by howard on 8/6/24.
//

import SwiftUI

public struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    var availableWidth: CGFloat
    let data: Data
    let content: (Data.Element) -> Content
    let horizontalSpacing: CGFloat = 6
    let verticalSpacing: CGFloat = 12
    
    @State private var elementSizes: [Data.Element: CGSize] = [:]
    
    public init(availableWidth: CGFloat, data: Data, content: @escaping (Data.Element) -> Content) {
        self.availableWidth = availableWidth
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(computeRows(), id: \.self) { rowElement in
                HStack(spacing: horizontalSpacing) {
                    ForEach(rowElement, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .onGeometryChange(for: CGSize.self, of: { proxy in
                                proxy.size
                            }, action: { newValue in
                                elementSizes[element] = newValue
                            })
                    }
                    Spacer()
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainWidth = availableWidth
        
        for element in data {
            let elementSize = elementSizes[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainWidth - (elementSize.width + horizontalSpacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainWidth = availableWidth
            }
            
            remainWidth = remainWidth - (elementSize.width + horizontalSpacing)
        }
        
        return rows
    }
}
