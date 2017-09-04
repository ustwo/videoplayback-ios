//
//  SingleVideoPlaybackViewController.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 4/25/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit

class SingleVideoPlaybackViewController: UIViewController {
    
    private let vpkBuilder = VPKVideoPlaybackBuilder()
    private var shouldAutoPlay: Bool = false
    private var toolBarTheme: ToolBarTheme = .normal
    
    convenience init(shouldAutoPlay: Bool, customTheme: ToolBarTheme = .normal) {
        self.init()
        self.shouldAutoPlay = shouldAutoPlay
        self.toolBarTheme = customTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        title = "Single Video"
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        let videoType = VPKVideoType.local(videoPathName: "Elon_Musk", fileType: "mp4", placeholderImageName: "elon_1")
        
        
        VPKVideoPlaybackBuilder.vpk_buildVideoView(for: videoType, shouldAutoplay: self.shouldAutoPlay, playbackBarTheme: self.toolBarTheme) { (videoView) in
            
            self.view.addSubview(videoView)
            videoView.snp.makeConstraints({ (make) in
            make.height.equalTo(view.snp.height).dividedBy(2)
                make.top.equalTo(view.snp.top).offset(10)
                make.left.right.equalTo(view)
            })
        }
    }
}
