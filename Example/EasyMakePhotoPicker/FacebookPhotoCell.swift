//
//  FacebookPhotoCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 6..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import EasyMakePhotoPicker

class FacebookPhotoCell: BaseCollectionViewCell, PhotoCellable {
  
  // MARK: - Constant
  
  struct Constant {
    static let selectedViewBorderWidth = CGFloat(5)
  }
  
  struct Color {
    static let selectedViewBorderColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0)
  }
  
  struct Metric {
    static let orderLabelWidth = CGFloat(30)
    static let orderLabelHeight = CGFloat(30)
  }
  
  // MARK: - Properties
  
  var selectedView = UIView().then {
    $0.layer.borderWidth = Constant.selectedViewBorderWidth
    $0.layer.borderColor = Color.selectedViewBorderColor.cgColor
    $0.isHidden = true
  }
  
  var orderLabel = FacebookNumberLabel().then {
    $0.clipsToBounds = false
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
    orderLabel.text = nil
    orderLabel.isHidden = true
    selectedView.isHidden = true
  }
  
  override func addSubviews() {
    addSubview(imageView)
    addSubview(selectedView)
    addSubview(orderLabel)
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
        equalTo: rightAnchor)
      .fs_topAnchor(
        equalTo: topAnchor)
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
        }
        else {
          self.orderLabel.isHidden = true
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.isSelect
      .skip(1)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] isSelect in
        guard let `self` = self else { return }
        if isSelect {
          self.cellAnimationWhenSelectedCell()
        }
        else {
          self.cellAnimationWhenDeselectedCell()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.selectedOrder
      .subscribe(onNext: { [weak self] selectedOrder in
        guard let `self` = self else { return }
        self.orderLabel.text = "\(selectedOrder)"
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

// MARK: - Animation

extension FacebookPhotoCell {
  var cellAnimationWhenSelectedCell: () -> () {
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
  
  var cellAnimationWhenDeselectedCell: () -> () {
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


















