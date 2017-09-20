//
//  VideoPlaybackKitTests.swift
//  VideoPlaybackKitTests
//
//  Created by Sonam on 9/4/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import XCTest
@testable import VideoPlaybackKit

final class VideoPlaybackInteractorTests: XCTestCase {
    
    let testURLString = "http://www.ustwo.com"
    let testPlaceholderURLName = "ustwo website"
    
    
    // MARK: - Tests
    
    func testGivenMockPlaybackManager_WhenDidTapVideoIsCalled_ThenManagerDidSelectVideoIsCalled() {
        
        // Given
        
        let mockPlaybackManager = MockVideoPlaybackManager()
        let videoType = VPKVideoType.remote(url: testURLString, placeholderURLName: testPlaceholderURLName)
        let interactor = VPKVideoPlaybackInteractor(entity: videoType)
        interactor.playbackManager = mockPlaybackManager
        
        // When
        
        let url = URL(string: testURLString)!
        interactor.didTapVideo(videoURL: url)
        
        // Then
        
        XCTAssertTrue(mockPlaybackManager.stubDidSelectVideoUrlIsCalled)
        XCTAssertEqual(mockPlaybackManager.spyDidSelectVideoUrl, url)
    }
}
