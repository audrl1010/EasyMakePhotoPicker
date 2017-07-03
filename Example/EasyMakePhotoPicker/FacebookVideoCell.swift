//
//  FacebookVideoCell.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import EasyMakePhotoPicker

class FacebookVideoCell: VideoCell {
  
  override var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      viewModel.isSelect
        .subscribe(onNext: { [weak self] isSelect in
          guard let `self` = self else { return }
          if isSelect {
            self.durationBackgroundView.backgroundColor = UIColor(
              red: 104/255,
              green: 156/255,
              blue: 255/255,
              alpha: 1.0)
          }
          else {
            self.durationBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
          }
        })
        .disposed(by: disposeBag)
    }
  }
  
  var durationBackgroundView = UIView().then {
    $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
  }
  
  var videoIconImageView = UIImageView(image: #imageLiteral(resourceName: "video"))
  
  override func setupViews() {
    self.orderLabel = FacebookNumberLabel()
    
    super.setupViews()
    
    durationBackgroundView.addSubview(videoIconImageView)
    insertSubview(durationBackgroundView, belowSubview: durationLabel)

    checkView.isHidden = true
    selectedView.layer.borderWidth = 5
    selectedView.layer.borderColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0).cgColor
    orderLabel.clipsToBounds = false
    durationLabel.textAlignment = .right
    durationLabel.backgroundColor = .clear
    checkView.isHidden = true
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
    
    durationBackgroundView
      .fs_heightAnchor(equalToConstant: 26)
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()

    videoIconImageView
      .fs_leftAnchor(
        equalTo: durationBackgroundView.leftAnchor,
        constant: 5)
      .fs_centerYAnchor(equalTo: durationBackgroundView.centerYAnchor)
      .fs_widthAnchor(equalToConstant: 16)
      .fs_heightAnchor(equalToConstant: 16)
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
    
    durationLabel
      .fs_rightAnchor(
        equalTo: durationBackgroundView.rightAnchor,
        constant: -5)
      .fs_centerYAnchor(equalTo: durationBackgroundView.centerYAnchor)
      .fs_endSetup()
    
    playerView
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
