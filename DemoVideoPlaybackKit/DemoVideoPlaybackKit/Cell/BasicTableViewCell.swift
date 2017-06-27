//
//  BasicTableViewCell.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 4/25/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit
import SnapKit

class BasicTableViewCell: UITableViewCell {

    static let identifier = "Basic"
    private let titleLabel = UILabel(frame: .zero)
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(8.0)
            make.right.equalTo(contentView).offset(-8.0)
            make.center.equalTo(contentView)
        }
    }
   
}
