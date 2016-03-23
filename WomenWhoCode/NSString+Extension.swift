//
//  NSString+Extension.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/23/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import Foundation
import UIKit

// MARK: String https://gist.github.com/zwaldowski/ed2a7c5f79c91d9ae226

extension String {
    
    func convert(index: Int) -> Index? {
        let utfIndex = utf16.startIndex.advancedBy(index)
        return utfIndex.samePositionIn(self)
    }
    
    func convert(index: String.Index) -> Int {
        let utfIndex = index.samePositionIn(utf16)
        return utf16.startIndex.distanceTo(utfIndex)
    }
    
    public func convert(range: NSRange) -> Range<Index>? {
        if range.location == NSNotFound { return nil }
        if let start = convert(range.location),
            end = convert(NSMaxRange(range)) {
            return start..<end
        }
        return nil
    }
    
    public func convert(range: Range<String.Index>) -> NSRange {
        let utfStart = convert(range.startIndex)
        let utfEnd = convert(range.endIndex)
        return NSRange(location: utfStart, length: utfStart.distanceTo(utfEnd))
    }
    
}

// MARK: NSRegularExpression

private func searchRange(string: String, range: Range<String.Index>?) -> NSRange {
    return range.map { string.convert($0) } ?? NSRange(location: 0, length: string.utf16.count)
}

public extension NSRegularExpression {
    
    func matches(string: String, options: NSMatchingOptions = [], range: Range<String.Index>? = nil) -> [NSTextCheckingResult] {
        return matchesInString(string, options: options, range: searchRange(string, range: range)) 
    }
    
    func numberOfMatches(string: String, options: NSMatchingOptions = [], range: Range<String.Index>? = nil) -> Int {
        return numberOfMatchesInString(string, options: options, range: searchRange(string, range: range))
    }
    
    func firstMatch(string: String, options: NSMatchingOptions = [], range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
        return firstMatchInString(string, options: options, range: searchRange(string, range: range))
    }
    
    func rangeOfFirstMatch(string: String, options: NSMatchingOptions = [], range: Range<String.Index>? = nil) -> Range<String.Index>? {
        return string.convert(rangeOfFirstMatchInString(string, options: options, range: searchRange(string, range: range)))
    }
    
}

// MARK: NSTextCheckingResult

public extension NSTextCheckingResult {
    
    func firstRange(string: String) -> Range<String.Index>? {
        return string.convert(range)
    }
    
    subscript (idx: Int, string: String) -> Range<String.Index>? {
        return string.convert(rangeAtIndex(idx))
    }
//    
//    func ranges(string: String) -> LazyCollection<LazyMapCollection<Range<Int>, Range<String.Index>>> {
//        return lazy(0..<numberOfRanges).map {
//            self[$0, string]!
//        }
//    }
    
}