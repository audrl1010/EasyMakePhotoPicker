//
//  VideoCell.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI

public class VideoCell: PhotoCell {
  
  public struct Color {
    static let selectedViewBGC = UIColor(white: 1.0, alpha: 0.0)
  }
  
  public struct Metric {
    static let durationLabelLeft = CGFloat(5)
    static let durationLabelTop = CGFloat(5)
  }

  override public var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel as? VideoCellViewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  public var durationLabel = DurationLabel()
  
  public var playerView = PlayerView().then {
    $0.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    $0.isHidden = true
  }
  
  public var player: AVPlayer? {
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

  public var duration: TimeInterval = 0.0 {
    didSet {
      durationLabel.text = timeFormatted(timeInterval: duration)
    }
  }
  
  override public func setupViews() {
    super.setupViews()
    selectedView.backgroundColor = Color.selectedViewBGC
    contentView.insertSubview(playerView, at: 1)
    contentView.addSubview(durationLabel)
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    
    player = nil
    playerView.isHidden = true
  }
  
  override public func setupConstraints() {
    super.setupConstraints()

    durationLabel
      .fs_leftAnchor(
        equalTo: contentView.leftAnchor,
        constant: Metric.durationLabelLeft)
      .fs_topAnchor(
        equalTo: contentView.topAnchor,
        constant: Metric.durationLabelTop)
      .fs_endSetup()
    
    playerView
      .fs_leftAnchor(equalTo: contentView.leftAnchor)
      .fs_topAnchor(equalTo: contentView.topAnchor)
      .fs_rightAnchor(equalTo: contentView.rightAnchor)
      .fs_bottomAnchor(equalTo: contentView.bottomAnchor)
      .fs_endSetup()
  }
  
  public func bind(viewModel: VideoCellViewModel) {
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
  
  public func play() {
    guard let viewModel = viewModel as? VideoCellViewModel,
      let playerItem = viewModel.playerItem else { return }
    
    self.player = AVPlayer(playerItem: playerItem)
    
    if let player = player {
      playerView.isHidden = false
      player.play()
    }
  }
  
  public func stop() {
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


public class PlayerView: UIView {
  
  public var player: AVPlayer? {
    get { return playerLayer.player }
    set { playerLayer.player = newValue }
  }
  
  public var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  
  override public static var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}






