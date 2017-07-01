//
//  PhotoCollectionCell.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import RxSwift

open class PhotoCollectionCell: BaseCollectionViewCell {
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
  
  open var disposeBag = DisposeBag()
  
  open var viewModel: PhotoCollectionCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  open var thumbnailImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  open var titleLabel = UILabel().then() {
    $0.textColor = Color.titleLabelTextColor
    $0.font = Font.titleLabelFont
  }
  
  open var countLabel = UILabel().then() {
    $0.textColor = Color.countLabelTextColor
    $0.font = Font.countLabelFont
  }
  
  open var lineView = UIView().then {
    $0.backgroundColor = Color.lineViewBGColor
  }
  
  // MARK: - Life Cycle
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    viewModel = nil
    thumbnailImageView.image = nil
    disposeBag = DisposeBag()
  }
  
  override open func setupViews() {
    super.setupViews()
    contentView.addSubview(thumbnailImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)
    contentView.addSubview(lineView)
  }
  
  override open func setupConstraints() {
    super.setupConstraints()
    
    thumbnailImageView
      .fs_leftAnchor(
        equalTo: contentView.leftAnchor,
        constant: Metric.thumbnailImageViewLeft)
      .fs_centerYAnchor(equalTo: contentView.centerYAnchor)
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
      .fs_rightAnchor(equalTo: contentView.rightAnchor)
      .fs_bottomAnchor(equalTo: contentView.bottomAnchor)
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
