//
//  LivePhotoCell.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI

open class LivePhotoCell: PhotoCell {
  public struct Metric {
    public static let livePhotoBadgeImageViewWidth = CGFloat(20)
    public static let livePhotoBadgeImageViewHeight = CGFloat(20)
    public static let livePhotoBadgeImageViewRight = CGFloat(-10)
    public static let livePhotoBadgeImageViewBottom = CGFloat(-10)
  }
  
  public struct Color {
    public static var selectedViewBGC = UIColor(white: 1.0, alpha: 0.0)
  }
  
  override open var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel as? LivePhotoCellViewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  open var livePhotoView = PHLivePhotoView().then {
    $0.isHidden = true
  }
  
  open var livePhotoBadgeImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    livePhotoBadgeImageView.image = nil
    livePhotoView.isHidden = true
  }
  
  override open func setupViews() {
    super.setupViews()
    selectedView.backgroundColor = Color.selectedViewBGC
    insertSubview(livePhotoView, aboveSubview: imageView)
    addSubview(livePhotoBadgeImageView)
  }
  
  override open func setupConstraints() {
    super.setupConstraints()
    livePhotoBadgeImageView
      .fs_widthAnchor(
        equalToConstant: Metric.livePhotoBadgeImageViewWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.livePhotoBadgeImageViewHeight)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: Metric.livePhotoBadgeImageViewRight)
      .fs_bottomAnchor(
        equalTo: bottomAnchor,
        constant: Metric.livePhotoBadgeImageViewBottom)
      .fs_endSetup()
    
    livePhotoView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
  
  open func play() {
    guard let viewModel = viewModel as? LivePhotoCellViewModel,
      let livePhoto = viewModel.livePhoto else { return }
    
    livePhotoView.startPlayback(with: .hint)
    livePhotoView.isHidden = false
    livePhotoView.livePhoto = livePhoto
  }
  
  open func stop() {
    self.livePhotoView.stopPlayback()
    self.livePhotoView.isHidden = true
    self.livePhotoView.livePhoto = nil 
  }
  
  open func bind(viewModel: LivePhotoCellViewModel) {
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

