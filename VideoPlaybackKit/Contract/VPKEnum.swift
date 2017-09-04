//
//  VPKEnum.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/4/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

//*** UI ****
//**
//*

public enum ToolBarTheme {
    case normal
    case custom(bottomBackgroundColor: UIColor, sliderBackgroundColor: UIColor, sliderIndicatorColor: UIColor, sliderCalloutColors: [UIColor])
}


//**** Used between presenter & view to manage view size & state
//**
//*
enum VideoSizeState {
    case normal, fullScreen
   
    mutating func toggle() {
        switch self {
        case .normal:
            self = .fullScreen
        case .fullScreen:
            self = .normal
        }
    }
}

//*** These enums are used throughout the framework & viper architecture
//**
//*
//*
public enum PlayerState {
    case playing, paused
    
    mutating func toggle() {
        switch self {
        case .playing:
            self = .paused
        case .paused:
            self = .playing
        }
    }
    
    var buttonImageName: String {
        switch self {
        case .playing:
            return "defaultPause"
        case .paused:
            return "defaultPlay"
        }
    }
}


//***** Used as the Entity 
//**
//*
public enum VPKVideoType {
    
    case remote(url: String, placeholderURLName: String)
    case local(videoPathName: String, fileType: String, placeholderImageName: String)
    
    var videoUrl: URL? {
        switch self {
        case let .local(videoPathName: aName, fileType: aType, placeholderImageName: _) where Bundle.main.path(forResource: aName, ofType: aType) != nil:
            return URL(fileURLWithPath: Bundle.main.path(forResource: aName, ofType: aType)!)
        case let .remote(url: remoteUrlName, placeholderURLName: _) where URL(string: remoteUrlName) != nil:
           return URL(string: remoteUrlName)
        default:
            return nil
        }
    }
}
