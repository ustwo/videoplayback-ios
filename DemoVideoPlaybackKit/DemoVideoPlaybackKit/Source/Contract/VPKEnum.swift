//
//  VPKEnum.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/4/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation


//**** Used between presenter & view to manage view size & state
//**
//*
enum VideoSizeState {
    case normal, fullScreen
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
    
    var buttonTitle: String {
        switch self {
        case .playing:
            return "Pause" //TODO: Replace with icons
        case .paused:
            return "Play"
        }
    }
}


//***** Used as the Entity 
//**
//*
public enum VPKVideoType {
    case remote(url: String), local(pathName: String, fileType: String)
}
