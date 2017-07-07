//
//  URLRequest+Configure.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation


extension URLRequest {
    
    /// Convenience method
    var byteRange: ByteRange? {
        if let value = allHTTPHeaderFields?["Range"] {
            if let prefixRange = value.range(of: "bytes=") {
                let rangeString = value.substring(from: prefixRange.upperBound)
                let comps = rangeString.components(separatedBy: "-")
                let ints = comps.flatMap{Int64($0)}
                if ints.count == 2 {
                    return (ints[0]..<(ints[1]+1))
                }
            }
        }
        return nil
    }
    
    /// Convenience method
    mutating func setByteRangeHeader(for range: ByteRange) {
        let rangeHeader = "bytes=\(range.lowerBound)-\(range.lastValidIndex)"
        setValue(rangeHeader, forHTTPHeaderField: "Range")
    }
    
    /// Convenience method for creating a byte range network request.
    static func dataRequest(from url: URL, for range: ByteRange) -> URLRequest {
        var request = URLRequest(url: url)
        request.setByteRangeHeader(for: range)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
}
