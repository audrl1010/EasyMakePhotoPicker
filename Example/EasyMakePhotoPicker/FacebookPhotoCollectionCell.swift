//
//  FacebookPhotoCollectionCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import EasyMakePhotoPicker
import RxSwift

class FacebookPhotoCollectionCell: BaseCollectionViewCell, PhotoCollectionCellable {
  
  // MARK: - Constant
  
  struct Constant {
    static let checkViewLineWidth = CGFloat(2.5)
  }
  
  struct Color {
    static let checkViewBGColor = UIColor.white
    static let checkViewCheckColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0)
    
    static var countLabelTextColor = UIColor(
      red: 155/255,
      green: 155/255,
      blue: 155/255,
      alpha: 1.0)
    
    static var titleLabelTextColor = UIColor.black
    
    static var lineViewBGColor = UIColor(
      red: 216/255,
      green: 217/255,
      blue: 216/255,
      alpha: 1.0)
  }
  
  struct Font {
    static var titleLabelFont = UIFont.systemFont(ofSize: 16)
    static var countLabelFont = UIFont.systemFont(ofSize: 12)
  }
  
  struct Metric {
    
    static let checkViewWidth = CGFloat(30)
    static let checkViewHeight = CGFloat(30)
    static let checkViewRight = CGFloat(-15)

    // Note: PhotoCollectionsViewConfigure` photoThumbnailSize and
    // the size of the thumbnailImageView must be the same. !!!!!
    static var thumbnailImageViewHeight = CGFloat(54)
    static var thumbnailImageViewWidth = CGFloat(54)
    static var thumbnailImageViewLeft = CGFloat(10)
    
    static var titleLabelLeft = CGFloat(10)
    static var titleLabelTop = CGFloat(5)
    
    static var countLabelTop = CGFloat(5)
    
    static var lineViewHeight = CGFloat(1)
  }
  
  var checkView: UIView = CheckImageView().then {
    $0.backgroundColor = Color.checkViewBGColor
    $0.lineWidth = Constant.checkViewLineWidth
    $0.checkColor = Color.checkViewCheckColor
    $0.isHidden = true
  }
  
  var thumbnailImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  var titleLabel = UILabel().then() {
    $0.font = Font.titleLabelFont
    $0.textColor = Color.titleLabelTextColor
    $0.font = Font.titleLabelFont
  }
  
  var countLabel = UILabel().then() {
    $0.textColor = Color.countLabelTextColor
    $0.font = Font.countLabelFont
  }
  
  var lineView = UIView().then {
    $0.backgroundColor = Color.lineViewBGColor
  }
  
  var disposeBag = DisposeBag()
  
  var viewModel: PhotoCollectionCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  // MARK: - Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    viewModel = nil
    thumbnailImageView.image = nil
    checkView.isHidden = true
  }
  
  override func setupViews() {
    addSubview(checkView)
    addSubview(thumbnailImageView)
    addSubview(titleLabel)
    addSubview(countLabel)
    addSubview(lineView)
  }
  
  override func setupConstraints() {
    checkView
      .fs_widthAnchor(equalToConstant: Metric.checkViewWidth)
      .fs_heightAnchor(equalToConstant: Metric.checkViewHeight)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: Metric.checkViewRight)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_endSetup()
    
    // PhotoCollectionsViewConfigure` photoThumbnailSize and
    // the size of the thumbnailImageView must be the same.
    thumbnailImageView
      .fs_leftAnchor(
        equalTo: leftAnchor,
        constant: Metric.thumbnailImageViewLeft)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_widthAnchor(equalToConstant: Metric.thumbnailImageViewWidth)
      .fs_heightAnchor(equalToConstant: Metric.thumbnailImageViewHeight)
      .fs_endSetup()
    
    titleLabel
      .fs_leftAnchor(
        equalTo: thumbnailImageView.rightAnchor,
        constant: Metric.titleLabelLeft)
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
  
  func bind(viewModel: PhotoCollectionCellViewModel) {
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
    viewModel.count
      .subscribe(onNext: { [weak self] count in
        guard let `self` = self else { return }
        self.countLabel.text = "\(count)"
      })
      .disposed(by: disposeBag)
    
    viewModel.thumbnail
      .subscribe(onNext: { [weak self] thumbnail in
        guard let `self` = self else { return }
        self.thumbnailImageView.image = thumbnail
      })
      .disposed(by: disposeBag)
    
    viewModel.title
      .subscribe(onNext: { [weak self] title in
        guard let `self` = self else { return }
        self.titleLabel.text = title
      })
      .disposed(by: disposeBag)
  }
}




