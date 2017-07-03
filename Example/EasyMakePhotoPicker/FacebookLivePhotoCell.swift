//
//  FacebookLivePhotoCell.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import EasyMakePhotoPicker

class FacebookLivePhotoCell: LivePhotoCell {
  override func setupViews() {
    self.orderLabel = FacebookNumberLabel()
    
    super.setupViews()
    
    self.checkView.isHidden = true
    self.selectedView.layer.borderWidth = 5
    self.selectedView.layer.borderColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0).cgColor
    self.orderLabel.clipsToBounds = false
    self.checkView.isHidden = true
  }
  
  override func setupConstraints() {
    
    imageView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
    
    selectedView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
    
    orderLabel
      .fs_widthAnchor(
        equalToConstant: 30)
      .fs_heightAnchor(
        equalToConstant: 30)
      .fs_rightAnchor(
        equalTo: rightAnchor)
      .fs_topAnchor(
        equalTo: topAnchor)
      .fs_endSetup()
    
    livePhotoBadgeImageView
      .fs_widthAnchor(
        equalToConstant: 20)
      .fs_heightAnchor(
        equalToConstant: 20)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: -10)
      .fs_bottomAnchor(
        equalTo: bottomAnchor,
        constant: -10)
      .fs_endSetup()
    
    livePhotoView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
  
  override var cellAnimationWhenSelectedCell: () -> () {
    return {
      UIView.SpringAnimator(duration: 0.3)
        .options(.curveEaseOut)
        .velocity(0.0)
        .damping(0.5)
        .beforeAnimations { [weak self] in
          guard let `self` = self else { return }
          self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        .animate()
    }
  }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  override var cellAnimationWhenDeselectedCell: () -> () {
    return {
      UIView.SpringAnimator(duration: 0.3)
        .options(.curveEaseOut)
        .velocity(0.0)
        .damping(0.5)
        .beforeAnimations { [weak self] in
          guard let `self` = self else { return }
          self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        .animate()
    }
  }
}
