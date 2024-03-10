//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import CryptoKit
import UIKit

public extension String {
    func appending(pathComponent: String) -> String {
        if self.hasSuffix("/") || pathComponent.hasPrefix("/") {
            return "\(self)\(pathComponent)"
        } else {
            return "\(self)/\(pathComponent)"
        }
    }
    
    var jsonObject: Any? {
        return self.data(using: .utf8)?.jsonObject
    }
    
    var toDictionary: [String: Any]? {
        return jsonObject as? [String: Any]
    }
    
    func jsonStringAppend(key: String, value: Any) -> String? {
        guard var dictionary = toDictionary else {
            return nil
        }
        
        dictionary[key] = value
        return dictionary.toString
    }
    
    func sha256() -> String {
        if let data = self.data(using: .utf8) {
            let sha256 = SHA256.hash(data: data)
            return sha256.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            return ""
        }
    }
    
    func ranges(of targetString: Self, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
        let result: [Range<String.Index>] = self.indices.compactMap { startIndex in
            let targetStringEndIndex = index(startIndex, offsetBy: targetString.count, limitedBy: endIndex) ?? endIndex
            return range(of: targetString, options: options, range: startIndex..<targetStringEndIndex, locale: locale)
        }
        return result
    }
    
    //    func removeExtraSpaces() -> String {
    //        return self.replacingOccurrences(of: "[\\s]+", with: " ", options: .regularExpression, range: nil)
    //    }
    
    func removeExtraSpaces() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func decode<T>(_ type: T.Type) throws -> T? where T: Decodable {
        let decoder = JSONDecoder()
        if let data = self.data(using: .utf8) {
            return try decoder.decode(T.self, from: data)
        } else {
            return nil
        }
    }
    
    func trimed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var decimalDigits: Double {
        return Double(components(separatedBy: .decimalDigits.inverted).joined()) ?? 0
    }
    
    var timeintervalFromFormattedString: TimeInterval? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        
        return dateFormatter.date(from: self)?.timeIntervalSince1970
    }
    
    var durationFromFormattedString: TimeInterval {
        let regex = #"^\s*(\d+d)?(\d+h)?(\d+m)?(\d+s)?(\d+ms)?\s*$"#
        let regexResult = getRegexStrings(regex: regex)
        
        var result: TimeInterval = 0
        
        let milliseconds = #"(\d+ms)"#
        let seconds = #"(\d+s)"#
        let minutes = #"(\d+m)"#
        let hours = #"(\d+h)"#
        let days = #"(\d+d)"#
        
        regexResult?.forEach { value in
            if value.checkRegexString(regex: milliseconds) {
                result += value.decimalDigits
            } else if value.checkRegexString(regex: seconds) {
                result += value.decimalDigits * 1000
            } else if value.checkRegexString(regex: minutes) {
                result += value.decimalDigits * 60 * 1000
            } else if value.checkRegexString(regex: hours) {
                result += value.decimalDigits * 60 * 60 * 1000
            } else if value.checkRegexString(regex: days) {
                result += value.decimalDigits * 24 * 60 * 60 * 1000
            }
        }
        
        return result
    }
    
    func checkRegexString(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            
            let match = regex.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
            
            return match.count > 0
        } catch let error {
            Logger.error("invalid regex: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func getRegexStrings(regex: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            var result = [String]()
            
            if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                for i in 0..<match.numberOfRanges {
                    if let substring = Range(match.range(at: i), in: self) {
                        result.append(String(self[substring]))
                    }
                }
            }
            
            result.removeFirst()
            
            return result
        } catch let error {
            Logger.error("invalid regex: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func width(height: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var dateFromISO8601Format: Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from:self)
    }
    
    var dateFromISO8601FormatForRecordList: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:self)
    }
    
    func extractPhoneNumbers() -> [String] {
        do {
            let phoneNumberRegex = try NSRegularExpression(pattern: "\\b\\d{1,3}?[-.: )]?\\d{3,4}[-.: ]\\d{4}\\b", options: [])
            let matches = phoneNumberRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            return matches.map {
                let range = Range($0.range, in: self)!
                return String(self[range])
            }
        } catch {
            print("Error creating regular expression: \(error)")
            return []
        }
    }

    func extractURLs() -> [String] {
        do {
            let urlRegex = try NSRegularExpression(pattern: "(?i)(https?://|www\\.)[a-z0-9-]+\\.[a-z]+(?:\\.[a-z]+)?(?:/[^\\s]*)?", options: [])
            let matches = urlRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            return matches.map {
                let range = Range($0.range, in: self)!
                return String(self[range])
            }
        } catch {
            print("Error creating regular expression: \(error)")
            return []
        }
    }

    func extractEmails() -> [String] {
        do {
            let emailRegex = try NSRegularExpression(pattern: "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b", options: [])
            let matches = emailRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            return matches.map {
                let range = Range($0.range, in: self)!
                return String(self[range])
            }
        } catch {
            print("Error creating regular expression: \(error)")
            return []
        }
    }
}
