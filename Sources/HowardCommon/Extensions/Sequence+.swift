//
//  File.swift
//
//
//  Created by howard on 10/2/23.
//

import Foundation

extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        var results = [T]()
        for element in self {
            results.append(try await transform(element))
        }
        return results
    }
    
    public func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
    
    public func concurrentForEach(
        _ operation: @escaping (Element) async throws -> Void
    ) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try  await operation(element)
                }
            }
            
            try await group.waitForAll()
        }
    }
    
    public func concurrentMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) async throws -> [T] {
        let indexedResults = try await withThrowingTaskGroup(of: (Int, T).self) { group in
            for (index, element) in self.enumerated() {
                group.addTask {
                    (index, try await transform(element))
                }
            }
            
            var results: [(Int, T)] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        
        return indexedResults.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
    }
}
