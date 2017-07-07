//
//  KaKaoPhotoCollectionCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 5..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

class KaKaoPhotoCollectionCell: BaseCollectionViewCell, PhotoCollectionCellable {
  // MARK: - Constant
  
  public struct Color {
    public static var countLabelTextColor = UIColor(
      red: 155/255,
      green: 155/255,
      blue: 155/255,
      alpha: 1.0)
    
    public static var titleLabelTextColor = UIColor.black
    
    public static var lineViewBGColor = UIColor(
      red: 216/255,
      green: 217/255,
      blue: 216/255,
      alpha: 1.0)
  }
  
  public struct Font {
    public static var titleLabelFont = UIFont.systemFont(ofSize: 16)
    public static var countLabelFont = UIFont.systemFont(ofSize: 12)
  }
  
  public struct Metric {
    public static var thumbnailImageViewLeft = CGFloat(10)
    public static var thumbnailImageViewHeight = CGFloat(54)
    public static var thumbnailImageViewWidth = CGFloat(54)
    
    public static var titleLabelLeft = CGFloat(10)
    public static var titleLabelTop = CGFloat(5)
    
    public static var countLabelTop = CGFloat(5)
    
    public static var lineViewHeight = CGFloat(1)
  }
  
  // MARK: - Properties
  var thumbnailImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  var titleLabel = UILabel().then() {
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
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    viewModel = nil
    thumbnailImageView.image = nil
    disposeBag = DisposeBag()
  }
  
  override func addSubviews() {
    addSubview(thumbnailImageView)
    addSubview(titleLabel)
    addSubview(countLabel)
    addSubview(lineView)
  }
  
  override open func setupConstraints() {
    thumbnailImageView
      .fs_leftAnchor(
        equalTo: leftAnchor,
        constant: Metric.thumbnailImageViewLeft)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_heightAnchor(equalToConstant: Metric.thumbnailImageViewHeight)
      .fs_widthAnchor(equalToConstant: Metric.thumbnailImageViewWidth)
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
  
  open func bind(viewModel: PhotoCollectionCellViewModel) {
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






