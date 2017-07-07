//
//  ByeRange.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation


protocol Summable: Comparable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    func decremented() -> Self
    func toInt() -> Int
}

extension Int64: Summable {
    func decremented() -> Int64 {
        return self - 1
    }
    func toInt() -> Int {
        return Int(self)
    }
}

public typealias ByteRange = Range<Int64>

enum ByteRangeIndexPosition {
    case before
    case inside
    case after
}

extension Range where Bound: Summable {
    
    var length: Bound {
        return upperBound - lowerBound
    }
    
    var lastValidIndex: Bound {
        return upperBound.decremented()
    }
    
    var subdataRange: Range<Int> {
        return lowerBound.toInt()..<(upperBound.toInt())
    }
    
    func leadingIntersection(in otherRange: Range) -> Range? {
        if lowerBound <= otherRange.lowerBound && lastValidIndex >= otherRange.lowerBound {
            if lastValidIndex > otherRange.lastValidIndex {
                return otherRange
            } else {
                let lowerBound = otherRange.lowerBound
                let upperBound = otherRange.lowerBound + length - otherRange.lowerBound
                return (lowerBound..<upperBound)
            }
        } else {
            return nil
        }
    }
    
    func trailingRange(in otherRange: Range) -> Range? {
        if let leading = leadingIntersection(in: otherRange), !fullySatisfies(otherRange) {
            return ((otherRange.lowerBound + leading.length)..<otherRange.upperBound)
        } else {
            return nil
        }
    }
    
    func fullySatisfies(_ requestedRange: Range) -> Bool {
        if let intersection = leadingIntersection(in: requestedRange) {
            return intersection == requestedRange
        } else {
            return false
        }
    }
    
    func intersects(_ otherRange: Range) -> Bool {
        return otherRange.lowerBound < upperBound && lowerBound < otherRange.upperBound
    }
    
    func isContiguousWith(_ otherRange: Range) -> Bool {
        if otherRange.upperBound == lowerBound {
            return true
        } else if upperBound == otherRange.lowerBound {
            return true
        } else {
            return false
        }
    }
    
    func relativePosition(of index: Bound) -> ByteRangeIndexPosition {
        if index < lowerBound {
            return .before
        } else if index >= upperBound {
            return .after
        } else {
            return .inside
        }
    }
    
}

func combine(_ ranges: [ByteRange]) -> [ByteRange] {
    var combinedRanges = [ByteRange]()
    let uncheckedRanges = ranges.sorted{$0.length > $1.length}
    for uncheckedRange in uncheckedRanges {
        let intersectingRanges = combinedRanges.filter{
            $0.intersects(uncheckedRange) || $0.isContiguousWith(uncheckedRange)
        }
        if intersectingRanges.isEmpty {
            combinedRanges.append(uncheckedRange)
        } else {
            for range in intersectingRanges {
                if let index = combinedRanges.index(of: range) {
                    combinedRanges.remove(at: index)
                }
            }
            let combinedRange = intersectingRanges.reduce(uncheckedRange, +)
            combinedRanges.append(combinedRange)
        }
    }
    return combinedRanges.sorted{$0.lowerBound < $1.lowerBound}
}

/// Adding byte ranges is currently very naive. It takes the lowest lowerBound
/// and the highest upper bound and computes a range between the two. It assumes
/// that the programmer desires this behavior, for instance, when you're adding
/// a sequence of byte ranges which form a continuous range when summed as a
/// whole even though any two random members might not overlap or be contiguous.
private func +(lhs: ByteRange, rhs: ByteRange) -> ByteRange {
    let lowerBound = min(lhs.lowerBound, rhs.lowerBound)
    let upperBound = max(lhs.upperBound, rhs.upperBound)
    return (lowerBound..<upperBound)
}
