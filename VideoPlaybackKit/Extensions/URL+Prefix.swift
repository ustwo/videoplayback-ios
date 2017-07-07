//
//  URL+Prefix.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation

extension URL {
    
    /// Adds the scheme prefix to a copy of the receiver.
    func convertToRedirectURL(prefix: String) -> URL? {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else {return nil}
        guard let scheme = comps.scheme else {return nil}
        comps.scheme = prefix + scheme
        return comps.url
    }
    
    //Removes the scheme and returns URL back to original
    func convertFromRedirectURL(prefix: String) -> URL? {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let scheme = comps.scheme else { return nil }
        comps.scheme = scheme.replacingOccurrences(of: prefix, with: "")
        return comps.url
    }
}
