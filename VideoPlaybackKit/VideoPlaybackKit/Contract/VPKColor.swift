//
//  VPKColorEnum.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 6/28/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit


enum VPKColor {
    
    case backgroundiOS11Default, borderiOS11Default, timeSliderBackground
    
    var rgbColor: UIColor {
        switch self {
        case .backgroundiOS11Default:
            return UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 0.45)
        case .borderiOS11Default:
            return UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        case .timeSliderBackground:
            return UIColor(red: 188/255, green: 198/255, blue: 193/255, alpha: 1.0)
        }
    }
    
}
