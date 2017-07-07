//
//  FileManager+Configure.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/7/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation

public extension Data {
    
    func writeFile(to url: URL, with options: Data.WritingOptions) -> Bool {
        do {
            try write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
}

public extension FileManager {
    
    public func cachesDirectory() -> URL? {
        
        let directories = urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        return directories.first
    }
    
    public func documentsDirectory() -> URL? {
        let directories = urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return directories.first
    }
    
    public func createDirectoryAt(_ url: URL) -> Bool {
        do {
            try createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        catch {
            return false
        }
        return true
    }
    
    public func createSubdirectory(_ name: String, atUrl url: URL) -> Bool {
        let subdirectoryUrl = url.appendingPathComponent(name, isDirectory: true)
        return self.createDirectoryAt(subdirectoryUrl)
    }
    
    public func removeDirectory(_ directory: URL) -> Bool {
        do {
            try removeItem(at: directory)
        }
        catch {
            return false
        }
        return true
    }
    
    public func removeFile(at url: URL) -> Bool {
        do {
            try removeItem(at: url)
        }
        catch {
            return false
        }
        return true
    }
    
}
