//
//  FacebookVideoCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 6..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import EasyMakePhotoPicker

class FacebookVideoCell: FacebookPhotoCell, VideoCellable {
  
  // MARK: - Constant
  
  struct Color {
    static let selectedDurationBackgroundViewBGColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0)
    static let deselectedDurationBackgroundViewBGColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.6)
  }
  
  struct Metric {
    static let durationBackgroundViewHeight = CGFloat(26)
    
    static let videoIconImageViewWidth = CGFloat(16)
    static let videoIconImageViewHeight = CGFloat(16)
    static let videoIconImageViewLeft = CGFloat(5)
    
    static let durationLabelRight = CGFloat(-5)
  }
  
  var durationLabel: UILabel = DurationLabel().then {
    $0.textAlignment = .right
    $0.backgroundColor = .clear
  }
  
  var playerView = PlayerView().then {
    $0.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    $0.isHidden = true
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
              player.seek(to: CMTime.zero)
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
  
  var durationBackgroundView = UIView().then {
    $0.backgroundColor = Color.deselectedDurationBackgroundViewBGColor
  }
  
  var videoIconImageView = UIImageView(image: #imageLiteral(resourceName: "video"))
  
  var duration: TimeInterval = 0.0 {
    didSet {
      durationLabel.text = timeFormatted(timeInterval: duration)
    }
  }
  
  // MARK: - Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    player = nil
    playerView.isHidden = true
  }
  
  override func addSubviews() {
    super.addSubviews()
    insertSubview(playerView, aboveSubview: imageView)
    addSubview(durationLabel)
    durationBackgroundView.addSubview(videoIconImageView)
    insertSubview(durationBackgroundView, belowSubview: durationLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    durationBackgroundView
      .fs_heightAnchor(equalToConstant: Metric.durationBackgroundViewHeight)
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
    
    videoIconImageView
      .fs_leftAnchor(
        equalTo: durationBackgroundView.leftAnchor,
        constant: Metric.videoIconImageViewLeft)
      .fs_centerYAnchor(equalTo: durationBackgroundView.centerYAnchor)
      .fs_widthAnchor(equalToConstant: Metric.videoIconImageViewWidth)
      .fs_heightAnchor(equalToConstant: Metric.videoIconImageViewHeight)
      .fs_endSetup()
    
    durationLabel
      .fs_rightAnchor(
        equalTo: durationBackgroundView.rightAnchor,
        constant: Metric.durationLabelRight)
      .fs_centerYAnchor(equalTo: durationBackgroundView.centerYAnchor)
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
      
      viewModel.isSelect
        .subscribe(onNext: { [weak self] isSelect in
          guard let `self` = self else { return }
          if isSelect {
            self.durationBackgroundView.backgroundColor =
              Color.selectedDurationBackgroundViewBGColor
          }
          else {
            self.durationBackgroundView.backgroundColor =
              Color.deselectedDurationBackgroundViewBGColor
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






