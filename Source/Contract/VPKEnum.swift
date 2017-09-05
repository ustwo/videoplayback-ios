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
