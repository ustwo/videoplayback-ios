//
//  VPKScrollingVideoPlaybackInteractor.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 6/20/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

internal enum ScrollDirection {
    case up, down, none
}

protocol ScrollInteractor {
    func scrollDidHit(targetMidPoint: Int, acceptableOffset: Int,  direction: ScrollDirection, tableView: UITableView, view: UIView, cell: UITableViewCell) -> Bool
    func scrollDidScrollToTop(_ scrollView: UIScrollView) -> Bool
}

extension ScrollInteractor where Self: UIScrollViewDelegate {
    
    //default implementations
    //use within scrollDidScrollDelegate method
    func scrollDidScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y == 0
    }
    
    func scrollDidHit(targetMidPoint: Int, acceptableOffset: Int,  direction: ScrollDirection, tableView: UITableView, view: UIView, cell: UITableViewCell) -> Bool {
        
        let minTarget = targetMidPoint - acceptableOffset
        let maxTarget = targetMidPoint + acceptableOffset
        
        switch direction {
        case .up:
            let convertedTopCellFrame = tableView.convert(cell.frame, to: view)
            let trackingTopCellYOffset = Int(abs(convertedTopCellFrame.origin.y))
            return (minTarget...maxTarget).contains(trackingTopCellYOffset)
        case .down:
            let convertedBottomCellFrame = tableView.convert(cell.frame, to: view)
            let trackingBottomCellYOffset = Int(tableView.frame.height) - Int(abs(convertedBottomCellFrame.origin.y))
            return (minTarget...maxTarget).contains(trackingBottomCellYOffset)
        case .none:
            return false
        }
    }
}

protocol VPKTableViewVideoPlaybackScrollable: ScrollInteractor {
    var tableView: UITableView { get set }
    static var scrollAcceptableOffset: Int { get }
    func trackVideoViewCellScrolling() //Use with scrollViewDidScroll
    func handleAutoplayInTopVideoCell()
}

extension VPKTableViewVideoPlaybackScrollable where Self: UIViewController {
    
    static var scrollAcceptableOffset: Int {
        return 5
    }
    
    func trackVideoViewCellScrolling() {
        
        let sharedVideoManager = VPKVideoPlaybackManager.shared
        
        //Immediately stop the video player if the user triggers the scroll to top (taps status bar)
        if scrollDidScrollToTop(tableView) {
            sharedVideoManager.isPlayerPlaying() ? sharedVideoManager.stop(): ()
            return
        }
        
        //We only care if the video player is playing and we want to stop it as it scrolls off screen
        if sharedVideoManager.isPlaying {
        
            //Data structure for potential video cell thats currently playing a video
            var playingVideoCellTuple: (indexPath: IndexPath, cell: VPKViewInCellProtocol, direction: ScrollDirection)?
            
            //Determine top or bottom cell in tableview is playing
            if let  topVisibleIndexPath = tableView.indexPathsForVisibleRows?.first,
                let topVideoCell  = tableView.cellForRow(at: topVisibleIndexPath) as? VPKViewInCellProtocol {
                playingVideoCellTuple = (topVisibleIndexPath, topVideoCell, .up)
            } else if let bottomVisibleIndexPath = tableView.indexPathsForVisibleRows?.last,
                let bottomVideoCell = tableView.cellForRow(at: bottomVisibleIndexPath) as? VPKViewInCellProtocol {
                playingVideoCellTuple = (bottomVisibleIndexPath, bottomVideoCell, .down)
            }
            
            guard let cellTuple = playingVideoCellTuple else { return }
            
            //Stop video when it scrolls halfway off screen
            guard let videoView = cellTuple.cell.videoView else { return }
            let targetMidPoint = Int(abs(videoView.frame.height)/2)
            
            //Determine top or bottom based on direction scrolling and actively playing cell
            switch cellTuple {
            case (_, let topVideoCell, .up) where topVideoCell.videoView!.playerLayer != nil && scrollDidHit(targetMidPoint: targetMidPoint, acceptableOffset: Self.scrollAcceptableOffset, direction: .up, tableView: tableView, view: view, cell: (topVideoCell as? UITableViewCell)!):
                
                sharedVideoManager.cleanup()
                                
                
            case (_, let bottomVideoCell, .down) where bottomVideoCell.videoView!.playerLayer != nil && scrollDidHit(targetMidPoint: targetMidPoint, acceptableOffset: Self.scrollAcceptableOffset, direction: .down, tableView: tableView, view: view, cell: bottomVideoCell as! UITableViewCell):
                
                    sharedVideoManager.cleanup()
            default:
                break
            }
        }
    }
    
    func handleAutoplayInTopVideoCell() {
        if(!tableView.isDecelerating && !tableView.isDragging) {
            
            tableView.visibleCells.forEach { (cell) in
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                let cellRect = tableView.rectForRow(at: indexPath)
                let superView = tableView.superview
                
                let convertedRect = tableView.convert(cellRect, to: superView)
                let intersect = tableView.frame.intersection(convertedRect)
                let visibleHeight = intersect.height
                print("VISIBLE HEIGHT = \(visibleHeight)")
                
                if visibleHeight > cellRect.height * 0.6 {
                    //cell is visible more than 60%
                    guard let videoCell = cell as? VPKViewInCellProtocol else { return }
                    videoCell.videoView?.didTapView()
                    print("autoplay cell at \(indexPath.row)")
                }
            }
        }
    }
}


