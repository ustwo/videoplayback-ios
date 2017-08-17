//
//  VideoTableViewCell.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/11/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell, VPKViewInCellProtocol {

    static let identifier = "VideoCell"
    var videoView: VPKVideoView? {
        didSet {
            self.setupVideoViewConstraints()
            layoutIfNeeded()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideoViewConstraints() {
        guard let safeView = videoView else { return }
        addSubview(safeView)
        safeView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(20.0)
            make.right.bottom.equalTo(self).offset(-20.0)
            
            make.height.equalTo(250) //Ideally we would use an aspect ratio adjusted height based on data from json
        }
        safeView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        self.setNeedsDisplay()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareForVideoReuse() //Extension default
    }
}
