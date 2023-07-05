//
//  HTSubtitles.swift
//  Cartoon
//
//  Created by James on 2023/5/8.
//

import Foundation
import AVKit

public class HTSubtitles {

    // MARK: - Private properties
    
    private var parsedPayload: NSDictionary?
    
    // MARK: - Public methods
    
    public init(file filePath: URL, encoding: String.Encoding = .utf8) throws {
        // Get string
        let string = try String(contentsOf: filePath, encoding: encoding)
        // Parse string
        parsedPayload = try HTSubtitles.ht_parseSubRip(string)
    }
    
    public init(subtitles string: String) throws {
        // Parse string
        parsedPayload = try HTSubtitles.ht_parseSubRip(string)
    }
    
    /// Search subtitles at time
    ///
    /// - Parameter time: Time
    /// - Returns: String if exists
    public func searchSubtitles(at time: TimeInterval) -> String? {
        return HTSubtitles.ht_searchSubtitles(parsedPayload, time)
    }
    
}

extension HTSubtitles {
    
    // MARK: - Static methods
        
    /// Subtitle parser
    ///
    /// - Parameter payload: Input string
    /// - Returns: NSDictionary
    static func ht_parseSubRip(_ payload: String) throws -> NSDictionary? {
        // Prepare payload
        var payload = payload.replacingOccurrences(of: "\n\r\n", with: "\n\n")
        payload = payload.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        payload = payload.replacingOccurrences(of: "\r\n", with: "\n")
        
        // Parsed dict
        let parsed = NSMutableDictionary()
        
        // Get groups
        let regexStr = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"
        let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
        let matches = regex.matches(in: payload, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, payload.count))
        
        for m in matches {
            let group = (payload as NSString).substring(with: m.range)
            
            // Get index
            var regex = try NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
            var match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
            
            guard let i = match.first else {
                continue
            }
            
            let index = (group as NSString).substring(with: i.range)
                    
            
            // Get "from" & "to" time
//            regex = try NSRegularExpression(pattern: "\\d{1,2}:\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
            /// 适配前面没有小时的情况
            regex = try NSRegularExpression(pattern: "\\d{1,2}:?\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
            
            match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
            
            guard match.count == 2 else {
                continue
            }
            
            guard let from = match.first, let to = match.last else {
                continue
            }
            
            var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0
            
            let fromStr = (group as NSString).substring(with: from.range)
            
            let fromStr_m_count = fromStr.filter { $0 == Character(":") }.count
            
            var scanner = Scanner(string: fromStr)
            if #available(iOS 13.0, *) {
                
                if fromStr_m_count == 1 {
                  
                    m = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    s = scanner.scanDouble() ?? 0.0
                    
                    if fromStr.contains(",") {
                        scanner.scanString(",", into: nil)
                        c = scanner.scanDouble() ?? 0.0
                    }
                    else if fromStr.contains(".") {
                        
                        scanner.scanString(".", into: nil)
                        c = scanner.scanDouble() ?? 0.0
                    }
                    
                }
                else {
                    
                    h = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    m = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    s = scanner.scanDouble() ?? 0.0
                    scanner.scanString(",", into: nil)
                    c = scanner.scanDouble() ?? 0.0
                }
                
                
            } else {
                
                if fromStr_m_count == 1 {
                    
                    scanner.scanDouble(&m)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&s)
                    
                    
                    if fromStr.contains(",") {
                        scanner.scanString(",", into: nil)
                        scanner.scanDouble(&c)
                    }
                    else if fromStr.contains(".") {
                        
                        scanner.scanString(".", into: nil)
                        scanner.scanDouble(&c)
                    }
                    
                    
                }
                else {
                    
                    scanner.scanDouble(&h)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&m)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&s)
                    scanner.scanString(",", into: nil)
                    scanner.scanDouble(&c)
                }
                
                
            }
            
            let fromTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
            
            let toStr = (group as NSString).substring(with: to.range)
            
            let toStr_m_count = toStr.filter { $0 == Character(":") }.count
            
            scanner = Scanner(string: toStr)
            if #available(iOS 13.0, *) {
                
                if toStr_m_count == 1 {
                    
                    m = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    s = scanner.scanDouble() ?? 0.0
                    
                    if toStr.contains(",") {
                        scanner.scanString(",", into: nil)
                        c = scanner.scanDouble() ?? 0.0
                    }
                    else if fromStr.contains(".") {
                        
                        scanner.scanString(".", into: nil)
                        c = scanner.scanDouble() ?? 0.0
                    }
                    
                    
                }
                else {
                    
                    h = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    m = scanner.scanDouble() ?? 0.0
                    scanner.scanString(":", into: nil)
                    s = scanner.scanDouble() ?? 0.0
                    scanner.scanString(",", into: nil)
                    c = scanner.scanDouble() ?? 0.0
                }
                
                
            } else {
                
                if toStr_m_count == 1 {
                    
                    scanner.scanDouble(&m)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&s)
                    
                    
                    if toStr.contains(",") {
                        scanner.scanString(",", into: nil)
                        scanner.scanDouble(&c)
                    }
                    else if fromStr.contains(".") {
                        
                        scanner.scanString(".", into: nil)
                        scanner.scanDouble(&c)
                    }
                    
                    
                }
                else {
                    
                    scanner.scanDouble(&h)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&m)
                    scanner.scanString(":", into: nil)
                    scanner.scanDouble(&s)
                    scanner.scanString(",", into: nil)
                    scanner.scanDouble(&c)
                }
                
                
            }
            
            
            let toTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
            
            // Get text & check if empty
            let range = NSMakeRange(0, to.range.location + to.range.length + 1)
            guard (group as NSString).length - range.length > 0 else {
                continue
            }
            
            let text = (group as NSString).replacingCharacters(in: range, with: "")
            
            // Create final object
            let final = NSMutableDictionary()
            final["from"] = fromTime
            final["to"] = toTime
            final["text"] = text
            parsed[index] = final
        }
        
        return parsed
    }
    
    /// Search subtitle on time
    ///
    /// - Parameters:
    ///   - payload: Inout payload
    ///   - time: Time
    /// - Returns: String
    public static func ht_searchSubtitles(_ payload: NSDictionary?, _ time: TimeInterval) -> String? {
        let predicate = NSPredicate(format: "(%f >= %K) AND (%f <= %K)", time, "from", time, "to")
        
        guard let values = payload?.allValues, let result = (values as NSArray).filtered(using: predicate).first as? NSDictionary else {
            return nil
        }
        
        guard let text = result.value(forKey: "text") as? String else {
            return nil
        }
        
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
}
