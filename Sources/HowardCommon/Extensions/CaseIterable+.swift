//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self) else { return self }
        let next = all.index(after: index)
        return all[next == all.endIndex ?  all.startIndex : next]
    }
}
