//
//  FacebookLivePhotoCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 6..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import RxSwift
import EasyMakePhotoPicker

class FacebookLivePhotoCell: FacebookPhotoCell, LivePhotoCellable {
  struct Metric {
    static let livePhotoBadgeImageViewWidth = CGFloat(20)
    static let livePhotoBadgeImageViewHeight = CGFloat(20)
    static let livePhotoBadgeImageViewRight = CGFloat(-10)
    static let livePhotoBadgeImageViewBottom = CGFloat(-10)
  }
  
  lazy var livePhotoView: PHLivePhotoView = { [unowned self] in
    let lpv = PHLivePhotoView()
    lpv.delegate = self
    lpv.isHidden = true
    return lpv
  }()
  
  var livePhotoBadgeImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    livePhotoBadgeImageView.image = nil
    livePhotoView.isHidden = true
  }
  
  override func addSubviews() {
    super.addSubviews()
    insertSubview(livePhotoView, aboveSubview: imageView)
    addSubview(livePhotoBadgeImageView)
  }
  
  override func setupConstraints() {
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
  
  // MARK: - Bind
  
  override func bind(viewModel: PhotoCellViewModel) {
    super.bind(viewModel: viewModel)
    if let viewModel = viewModel as? LivePhotoCellViewModel {
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
  
  fileprivate func play() {
    guard let viewModel = viewModel as? LivePhotoCellViewModel,
      let livePhoto = viewModel.livePhoto else { return }
    
    livePhotoView.startPlayback(with: .hint)
    livePhotoView.isHidden = false
    livePhotoView.livePhoto = livePhoto
  }
  
  fileprivate func stop() {
    self.livePhotoView.stopPlayback()
    self.livePhotoView.isHidden = true
    self.livePhotoView.livePhoto = nil
  }
}

// MARK: - PHLivePhotoViewDelegate
extension FacebookLivePhotoCell: PHLivePhotoViewDelegate {
  public func livePhotoView(
    _ livePhotoView: PHLivePhotoView,
    willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
  }
  
  public func livePhotoView(
    _ livePhotoView: PHLivePhotoView,
    didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
    livePhotoView.startPlayback(with: .hint)
  }
}










