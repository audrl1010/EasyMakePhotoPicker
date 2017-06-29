//
//  LivePhotoCell.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI

public class LivePhotoCell: PhotoCell {
  public struct Metric {
    static let livePhotoBadgeImageViewWidth = CGFloat(20)
    static let livePhotoBadgeImageViewHeight = CGFloat(20)
    static let livePhotoBadgeImageViewRight = CGFloat(-10)
    static let livePhotoBadgeImageViewBottom = CGFloat(-10)
  }
  
  public struct Color {
    static var selectedViewBGC = UIColor(white: 1.0, alpha: 0.0)
  }
  
  override public var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel as? LivePhotoCellViewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  public var livePhotoView = PHLivePhotoView().then {
    $0.isHidden = true
  }
  
  public var livePhotoBadgeImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    livePhotoBadgeImageView.image = nil
    
    livePhotoView.isHidden = true
  }
  
  override public func setupViews() {
    super.setupViews()
    selectedView.backgroundColor = Color.selectedViewBGC
    contentView.insertSubview(livePhotoView, at: 1)
    contentView.addSubview(livePhotoBadgeImageView)
  }
  
  override public func setupConstraints() {
    super.setupConstraints()
    livePhotoBadgeImageView
      .fs_widthAnchor(
        equalToConstant: Metric.livePhotoBadgeImageViewWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.livePhotoBadgeImageViewHeight)
      .fs_rightAnchor(
        equalTo: contentView.rightAnchor,
        constant: Metric.livePhotoBadgeImageViewRight)
      .fs_bottomAnchor(
        equalTo: contentView.bottomAnchor,
        constant: Metric.livePhotoBadgeImageViewBottom)
      .fs_endSetup()
    
    livePhotoView
      .fs_leftAnchor(equalTo: contentView.leftAnchor)
      .fs_topAnchor(equalTo: contentView.topAnchor)
      .fs_rightAnchor(equalTo: contentView.rightAnchor)
      .fs_bottomAnchor(equalTo: contentView.bottomAnchor)
      .fs_endSetup()
  }
  
  public func play() {
    guard let viewModel = viewModel as? LivePhotoCellViewModel,
      let livePhoto = viewModel.livePhoto else { return }
    
    livePhotoView.startPlayback(with: .hint)
    livePhotoView.isHidden = false
    livePhotoView.livePhoto = livePhoto
  }
  
  public func stop() {
    self.livePhotoView.stopPlayback()
    self.livePhotoView.isHidden = true
    self.livePhotoView.livePhoto = nil 
  }
  
  public func bind(viewModel: LivePhotoCellViewModel) {
    livePhotoBadgeImageView.image = viewModel.badgeImage
    
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

