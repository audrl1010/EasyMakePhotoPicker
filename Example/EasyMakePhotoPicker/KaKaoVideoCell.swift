//
//  KaKaoVideoCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 5..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import PhotosUI
import RxSwift
import EasyMakePhotoPicker

class KaKaoVideoCell: KaKaoPhotoCell, VideoCellable {
  // MARK: - Constant
  
  struct Color {
    static let selectedViewBGC = UIColor(white: 1.0, alpha: 0.0)
  }
  
  struct Metric {
    static let durationLabelLeft = CGFloat(5)
    static let durationLabelTop = CGFloat(5)
  }
  
  var durationLabel: UILabel = DurationLabel()
  
  var playerView = PlayerView().then {
    $0.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    $0.isHidden = true
  }
  
  var duration: TimeInterval = 0.0 {
    didSet {
      durationLabel.text = timeFormatted(timeInterval: duration)
    }
  }
  
  fileprivate var player: AVPlayer? {
    didSet {
      if let player = player {
        playerView.playerLayer.player = player
        
        NotificationCenter.default.addObserver(
          forName: .AVPlayerItemDidPlayToEndTime,
          object: player.currentItem,
          queue: nil) { _ in
            DispatchQueue.main.async {
              player.seek(to: kCMTimeZero)
              player.play()
            }
        }
      }
      else {
        playerView.playerLayer.player = nil
        NotificationCenter.default.removeObserver(self)
      }
    }
  }
  
  // MARK: - Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    player = nil
    playerView.isHidden = true
  }

  override func setupViews() {
    super.setupViews()
    selectedView.backgroundColor = Color.selectedViewBGC
  }
  
  override func addSubviews() {
    super.addSubviews()
    insertSubview(playerView, aboveSubview: imageView)
    addSubview(durationLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    durationLabel
      .fs_leftAnchor(
        equalTo: leftAnchor,
        constant: Metric.durationLabelLeft)
      .fs_topAnchor(
        equalTo: topAnchor,
        constant: Metric.durationLabelTop)
      .fs_endSetup()
    
    playerView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
  
  // MARK: - Bind
  
  override func bind(viewModel: PhotoCellViewModel) {
    super.bind(viewModel: viewModel)
    if let viewModel = viewModel as? VideoCellViewModel {
      duration = viewModel.duration
      
      viewModel.playEvent.asObserver()
        .subscribe(onNext: { [weak self] playEvent in
          guard let `self` = self else { return }
          switch playEvent {
          case .play: self.play()
          case .stop: self.stop()
          }
        })
        .disposed(by: disposeBag)
    }
  }

  fileprivate func play() {
    guard let viewModel = viewModel as? VideoCellViewModel,
      let playerItem = viewModel.playerItem else { return }
    
    self.player = AVPlayer(playerItem: playerItem)
    
    if let player = player {
      playerView.isHidden = false
      player.play()
    }
  }
  
  fileprivate func stop() {
    if let player = player {
      player.pause();
      self.player = nil
      playerView.isHidden = true
    }
  }
  
  fileprivate func timeFormatted(timeInterval: TimeInterval) -> String {
    let seconds = lround(timeInterval)
    var hour = 0
    var minute = (seconds / 60)
    let second = seconds % 60
    if minute > 59 {
      hour = (minute / 60)
      minute = (minute % 60)
      return String(format: "%d:%d:%02d", hour, minute, second)
    }
    else {
      return String(format: "%d:%02d", minute, second)
    }
  }
}




