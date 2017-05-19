//
//  FeedViewController.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/11/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit
import RxSwift

class FeedViewController: UIViewController {

    private let tableView = UITableView(frame: .zero)
    private let disposeBag = DisposeBag()

    let datasource = Variable([
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4"),
        VPKVideoType.local(pathName: "Elon_Musk", fileType: "mp4")
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    private func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupTableView() {
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.identifier)
        
        datasource.asObservable().bindTo(tableView.rx.items(cellIdentifier: VideoTableViewCell.identifier)) { index, model, cell in
            
            guard let cell = cell as? VideoTableViewCell else { return }
            VPKVideoPlaybackBuilder.vpk_buildModuleFor(model, withPlaceholder: "elon_1", shouldAutoplay: false, shouldReuseInCell: true, playbackBarTheme: ToolBarTheme.transparent(backgroundColor: .orange, foregroundColor: .lightGray, alphaValue: 0.7), completion: { (videoView) in
                cell.videoView = videoView
                cell.layoutIfNeeded()
            })}.addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self)
    }

}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320.0
    }
    
}