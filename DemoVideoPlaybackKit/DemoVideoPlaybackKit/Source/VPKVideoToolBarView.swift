//
//  VPKVideoToolBarView.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

public enum ToolBarTheme {
    case normal
    case transparent(backgroundColor: UIColor, foregroundColor: UIColor,  alphaValue: CGFloat)
}
public class VPKVideoToolBarView: UIView {
    
    private var theme: ToolBarTheme = .normal
    
    convenience init(theme: ToolBarTheme) {
        self.init(frame: .zero)
        self.theme = theme
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        switch theme {
        case .normal:
            setupNormalLayout()
        default:
            return
        }
    }
    
    private func setupNormalLayout() {
        
    }
}
