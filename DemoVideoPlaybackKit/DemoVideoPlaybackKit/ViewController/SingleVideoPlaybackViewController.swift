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
    
    convenience init(shouldAutoPlay: Bool) {
        self.init()
        self.shouldAutoPlay = shouldAutoPlay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        let videoType = VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4")
        VPKVideoPlaybackBuilder.vpk_buildModuleFor(videoType, withPlaceholder: "elon_1", shouldAutoplay: self.shouldAutoPlay) { (videoView) in
            self.view.addSubview(videoView)
            videoView.snp.makeConstraints({ (make) in
                make.height.equalTo(view.snp.height).dividedBy(2)
                make.left.right.top.equalTo(view)
            })
        }
    }
}
