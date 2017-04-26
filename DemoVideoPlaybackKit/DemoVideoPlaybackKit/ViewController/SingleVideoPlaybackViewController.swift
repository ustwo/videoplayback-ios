//
//  SingleVideoPlaybackViewController.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 4/25/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit

class SingleVideoPlaybackViewController: UIViewController {
    
    private let vpkBuilder = VPKPlayerBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.purple

        VPKPlayerBuilder.vpk_buildLocal("Elon_Musk", withType: "mp4", withPlaceHolder: "elon_1") { (videoView) in
            self.view.addSubview(videoView)
            videoView.snp.makeConstraints({ (make) in
                make.height.equalTo(view.snp.height).dividedBy(2)
                make.left.right.top.equalTo(view)
            })
        }
        
    }
    
}


