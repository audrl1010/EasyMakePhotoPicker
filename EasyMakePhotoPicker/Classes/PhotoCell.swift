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

public class PhotoCell: BaseCollectionViewCell {
  
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
  
  public var disposeBag: DisposeBag = DisposeBag()
  
  public var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  public var cellAnimationWhenSelectedCell: () -> () {
    // implementation...
    return { }
  }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  public var cellAnimationWhenDeselectedCell: () -> () {
    // implementation...
    return { }
  }
  
  public var checkView: UIView = CheckImageView()
  
  public var selectedView = UIView().then {
    $0.layer.borderWidth = Constant.selectedViewBorderWidth
    $0.layer.borderColor = Color.selectedViewBorderColor.cgColor
    $0.isHidden = true
  }
  
  public var orderLabel: UILabel = NumberLabel().then {
    $0.isHidden = true
  }
  
  public var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    viewModel = nil
    imageView.image = nil
    orderLabel.text = nil
    orderLabel.isHidden = true
    selectedView.isHidden = true
  }
  
  override public func setupViews() {
    super.setupViews()
    contentView.addSubview(imageView)
    contentView.addSubview(selectedView)
    contentView.addSubview(orderLabel)
    contentView.addSubview(checkView)
  }
  
  override public func setupConstraints() {
    super.setupConstraints()
    
    imageView
      .fs_leftAnchor(equalTo: contentView.leftAnchor)
      .fs_topAnchor(equalTo: contentView.topAnchor)
      .fs_rightAnchor(equalTo: contentView.rightAnchor)
      .fs_bottomAnchor(equalTo: contentView.bottomAnchor)
      .fs_endSetup()
    
    selectedView
      .fs_leftAnchor(equalTo: contentView.leftAnchor)
      .fs_topAnchor(equalTo: contentView.topAnchor)
      .fs_rightAnchor(equalTo: contentView.rightAnchor)
      .fs_bottomAnchor(equalTo: contentView.bottomAnchor)
      .fs_endSetup()
    
    orderLabel
      .fs_widthAnchor(
        equalToConstant: Metric.orderLabelWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.orderLabelHeight)
      .fs_rightAnchor(
        equalTo: contentView.rightAnchor,
        constant: Metric.orderLabelRight)
      .fs_topAnchor(
        equalTo: contentView.topAnchor,
        constant: Metric.orderLabelTop)
      .fs_endSetup()
    
    checkView
      .fs_widthAnchor(
        equalToConstant: Metric.checkImageViewWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.checkImageViewHeight)
      .fs_rightAnchor(
        equalTo: contentView.rightAnchor,
        constant: Metric.checkImageViewRight)
      .fs_topAnchor(
        equalTo: contentView.topAnchor,
        constant: Metric.checkImageViewTop)
      .fs_endSetup()
  }
  
  public func bind(viewModel: PhotoCellViewModel) {
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








