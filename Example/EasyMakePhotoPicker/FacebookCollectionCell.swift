//
//  FacebookCollectionCell.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import EasyMakePhotoPicker

class FacebookCollectionCell: PhotoCollectionCell {
  var checkView: UIView = CheckImageView().then {
    $0.backgroundColor = .white
    $0.lineWidth = 2.5
    $0.checkColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0)
    $0.isHidden = true
  }
  
  override var viewModel: PhotoCollectionCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      // If there is a previously selected cell,
      // the selected cell is deselected.
      viewModel.isSelect.asObservable()
        .subscribe(onNext: { [weak self] isSelect in
          guard let`self` = self else { return }
          if isSelect {
            self.checkView.isHidden = false
          }
          else {
            self.checkView.isHidden = true
          }
        })
        .disposed(by: disposeBag)
    }
  }
  
  override func setupViews() {
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    super.setupViews()
    addSubview(checkView)
  }
  
  override func setupConstraints() {
    checkView
      .fs_widthAnchor(equalToConstant: 30)
      .fs_heightAnchor(equalToConstant: 30)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: -15)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_endSetup()
    
    // PhotoCollectionsViewConfigure` photoThumbnailSize and
    // the size of the thumbnailImageView must be the same.
    thumbnailImageView
      .fs_leftAnchor(
        equalTo: leftAnchor,
        constant: 10)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_heightAnchor(equalToConstant: 54)
      .fs_widthAnchor(equalToConstant: 54)
      .fs_endSetup()
    
    titleLabel
      .fs_leftAnchor(
        equalTo: thumbnailImageView.rightAnchor,
        constant: 10)
      .fs_topAnchor(
        equalTo: thumbnailImageView.topAnchor,
        constant: Metric.titleLabelTop)
      .fs_endSetup()
    
    countLabel
      .fs_leftAnchor(
        equalTo: titleLabel.leftAnchor)
      .fs_topAnchor(
        equalTo: titleLabel.bottomAnchor,
        constant: Metric.countLabelTop)
      .fs_endSetup()
    
    lineView
      .fs_leftAnchor(equalTo: thumbnailImageView.leftAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_heightAnchor(equalToConstant: Metric.lineViewHeight)
      .fs_endSetup()
  }
}
