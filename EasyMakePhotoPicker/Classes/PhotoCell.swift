//
//  PhotoCell.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI
import RxSwift

open class PhotoCell: BaseCollectionViewCell {
  
  // MARK: - Constant
  public struct Constant {
    public static var selectedViewBorderWidth = CGFloat(2)
  }
  
  public struct Color {
    public static var selectedViewBorderColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 0/255,
      alpha: 1.0)
  }
  
  public struct Metric {
    public static var orderLabelWidth = CGFloat(30)
    public static var orderLabelHeight = CGFloat(30)
    public static var orderLabelRight = CGFloat(-10)
    public static var orderLabelTop = CGFloat(10)
    
    public static var checkImageViewWidth = CGFloat(30)
    public static var checkImageViewHeight = CGFloat(30)
    public static var checkImageViewRight = CGFloat(-10)
    public static var checkImageViewTop = CGFloat(10)
  }
  
  // MARK: - Properties
  
  open var disposeBag: DisposeBag = DisposeBag()
  
  open var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  open var cellAnimationWhenSelectedCell: () -> () {
    // implementation...
    return { }
  }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  open var cellAnimationWhenDeselectedCell: () -> () {
    // implementation...
    return { }
  }
  
  open var checkView: UIView = CheckImageView()
  
  open var selectedView = UIView().then {
    $0.layer.borderWidth = Constant.selectedViewBorderWidth
    $0.layer.borderColor = Color.selectedViewBorderColor.cgColor
    $0.isHidden = true
  }
  
  open var orderLabel: UILabel = NumberLabel().then {
    $0.isHidden = true
  }
  
  open var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    viewModel = nil
    imageView.image = nil
    orderLabel.text = nil
    orderLabel.isHidden = true
    selectedView.isHidden = true
  }
  
  override open func setupViews() {
    super.setupViews()
    addSubview(imageView)
    addSubview(selectedView)
    addSubview(orderLabel)
    addSubview(checkView)
  }
  
  override open func setupConstraints() {
    super.setupConstraints()
    
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
  
  open func bind(viewModel: PhotoCellViewModel) {
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
    
    viewModel.isSelect
      .skip(1)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self, weak viewModel] isSelect in
        guard let `self` = self,
          let `viewModel` = viewModel else { return }
        if isSelect {
          self.cellAnimationWhenSelectedCell()
        }
        else {
          if viewModel.configure.allowsMultipleSelection {
            self.cellAnimationWhenDeselectedCell()
          }
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








