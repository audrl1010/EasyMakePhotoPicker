//
//  KaKaoPhotoCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 5..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import EasyMakePhotoPicker
import PhotosUI
import RxSwift

class KaKaoPhotoCell: BaseCollectionViewCell, PhotoCellable {
  // MARK: - Constant
  
  struct Constant {
    static let selectedViewBorderWidth = CGFloat(2)
  }
  
  struct Color {
    static let selectedViewBorderColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 0/255,
      alpha: 1.0)
    static let selectedViewBGColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.6)
  }
  
  struct Metric {
    static let orderLabelWidth = CGFloat(30)
    static let orderLabelHeight = CGFloat(30)
    static let orderLabelRight = CGFloat(-10)
    static let orderLabelTop = CGFloat(10)
    
    static let checkImageViewWidth = CGFloat(30)
    static let checkImageViewHeight = CGFloat(30)
    static let checkImageViewRight = CGFloat(-10)
    static let checkImageViewTop = CGFloat(10)
  }
  
  // MARK: - Properties
  
  var checkView = CheckImageView().then {
    $0.isHidden = true
  }
  
  var selectedView = UIView().then {
    $0.layer.borderWidth = Constant.selectedViewBorderWidth
    $0.layer.borderColor = Color.selectedViewBorderColor.cgColor
    $0.backgroundColor = Color.selectedViewBGColor
    $0.isHidden = true
  }
  
  var orderLabel = NumberLabel().then {
    $0.isHidden = true
  }
  
  var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  var disposeBag: DisposeBag = DisposeBag()
  
  var viewModel: PhotoCellViewModel? {
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
    imageView.image = nil
    orderLabel.label.text = nil
    orderLabel.isHidden = true
    selectedView.isHidden = true
  }

  override func addSubviews() {
    addSubview(imageView)
    addSubview(selectedView)
    addSubview(orderLabel)
    addSubview(checkView)
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
        equalToConstant: Metric.orderLabelWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.orderLabelHeight)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: Metric.orderLabelRight)
      .fs_topAnchor(
        equalTo: topAnchor,
        constant: Metric.orderLabelTop)
      .fs_endSetup()
    
    checkView
      .fs_widthAnchor(
        equalToConstant: Metric.checkImageViewWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.checkImageViewHeight)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: Metric.checkImageViewRight)
      .fs_topAnchor(
        equalTo: topAnchor,
        constant: Metric.checkImageViewTop)
      .fs_endSetup()
  }
  
  // MARK: - Bind
  
  func bind(viewModel: PhotoCellViewModel) {
    viewModel.isSelect
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self, weak viewModel] isSelect in
        guard let `self` = self,
          let `viewModel` = viewModel else { return }
        self.selectedView.isHidden = !isSelect
        
        if viewModel.configure.allowsMultipleSelection {
          self.orderLabel.isHidden = !isSelect
          self.checkView.isHidden = isSelect
        }
        else {
          self.orderLabel.isHidden = true
          self.checkView.isHidden = true
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.selectedOrder
      .subscribe(onNext: { [weak self] selectedOrder in
        guard let `self` = self else { return }
        self.orderLabel.number = selectedOrder
      })
      .disposed(by: disposeBag)
    
    viewModel.image.asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] image in
        guard let `self` = self else { return }
        self.imageView.image = image
      })
      .disposed(by: disposeBag)
  }
}
















