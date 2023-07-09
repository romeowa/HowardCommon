//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import UIKit

public extension Array where Element: Equatable {
    mutating func add(_ object: Element) {
        insert(object, at: count)
    }
    
    mutating func remove(_ object: Element) {
        removeAll(where: { $0 == object} )
    }
}

public extension Array where Element == String {
    func truncatePlusString(height: CGFloat, font: UIFont, maxWidth: CGFloat, separator: String = ", ") -> String {
        var elememts = self
        var result = elememts.joined(separator: separator)
        var currentResultWidth = result.width(height: height, font: font)

        guard currentResultWidth > maxWidth else { return result }
        
        var removedElements = [String]()
        while currentResultWidth > maxWidth  {
            let removed = elememts.removeLast()
            removedElements.append(removed)
            
            result = elememts.joined(separator: separator)
            result += " +\(removedElements.count)"
            
            currentResultWidth = result.width(height: height, font: font)
        }
        
        return result
    }
}
