//
//  FacebookPermissionVC.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FacebookPermissionVC: BaseVC {
  struct Constant {
    static let titleLabelText = "Please Allow Photo Access"
    static let contentLabelText = "This allows you to share photos from your library and save photos to your camera roll."
    static let enumerationOneLabelText = "1. Tap Privacy"
    static let enumerationSecondLabelText = "2. Switch Photos On"
    static let allowAccessButtonText = "Allow Access"
  }
  
  struct Color {
    static let containerViewBGColor = UIColor.white
    static let titleLabelColor = UIColor(
      red: 114/255,
      green: 116/255,
      blue: 130/255,
      alpha: 1.0)
    static let contentLabelColor = UIColor(
      red: 114/255,
      green: 116/255,
      blue: 130/255,
      alpha: 1.0)
    static let enumerationOneLabelColor = UIColor(
      red: 114/255,
      green: 116/255,
      blue: 130/255,
      alpha: 1.0)
    static let enumerationSecondLabelColor = UIColor(
      red: 114/255,
      green: 116/255,
      blue: 130/255,
      alpha: 1.0)
  }
  
  struct Font {
    static let titleLabelFont = UIFont.boldSystemFont(ofSize: 18)
    static let contentLabelFont = UIFont.systemFont(ofSize: 14)
    static let enumerationOneLabelFont = UIFont.boldSystemFont(ofSize: 16)
    static let enumerationSecondLabelFont = UIFont.boldSystemFont(ofSize: 16)
    static let allowAccessButtonFont = UIFont.boldSystemFont(ofSize: 16)
  }
  
  struct Metric {
    static let containerViewLeft = CGFloat(25)
    static let containerViewTop = CGFloat(100)
    static let containerViewRight = CGFloat(-25)
    static let containerViewBottom = CGFloat(50)
    
    static let titleLabelTop = CGFloat(5)
    
    static let contentLabelTop = CGFloat(10)
    
    static let enumerationOneLabelLabelTop = CGFloat(20)
    
    static let enumerationSecondLabelTop = CGFloat(10)
    
    static let allowAccessButtonTop = CGFloat(35)
  }
  
  var containerView = UIView().then {
    $0.backgroundColor = Color.containerViewBGColor
  }
  
  var titleLabel = UILabel().then {
    $0.textColor = Color.titleLabelColor
    $0.font = Font.titleLabelFont
    $0.textAlignment = .center
    $0.text = Constant.titleLabelText
  }
  
  var contentLabel = UILabel().then {
    $0.textColor = Color.contentLabelColor
    $0.font = Font.contentLabelFont
    $0.text = Constant.contentLabelText
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  var enumerationOneLabel = UILabel().then {
    $0.textColor = Color.enumerationOneLabelColor
    $0.font = Font.enumerationOneLabelFont
    $0.text = Constant.enumerationOneLabelText
  }
  
  var enumerationSecondLabel = UILabel().then {
    $0.textColor = Color.enumerationSecondLabelColor
    $0.font = Font.enumerationSecondLabelFont
    $0.text = Constant.enumerationSecondLabelText
  }
  
  var allowAccessButton = UIButton(type: .system).then {
    $0.setTitle(Constant.allowAccessButtonText, for: .normal)
    $0.titleLabel?.font = Font.allowAccessButtonFont
  }
  
  var doneButton = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil)
  
  var disposeBag = DisposeBag()
  
  override func setupViews() {
    navigationItem.rightBarButtonItem = doneButton
    view.backgroundColor = .white
    view.addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(contentLabel)
    containerView.addSubview(enumerationOneLabel)
    containerView.addSubview(enumerationSecondLabel)
    containerView.addSubview(allowAccessButton)
    bind()
  }
  
  override func setupConstraints() {
    containerView
      .fs_leftAnchor(
        equalTo: view.leftAnchor,
        constant: Metric.containerViewLeft)
      .fs_topAnchor(
        equalTo: topLayoutGuide.bottomAnchor,
        constant: Metric.containerViewTop)
      .fs_rightAnchor(
        equalTo: view.rightAnchor,
        constant: Metric.containerViewRight)
      .fs_bottomAnchor(
        equalTo: view.bottomAnchor,
        constant: Metric.containerViewBottom)
      .fs_endSetup()
    
    titleLabel
      .fs_topAnchor(
        equalTo: containerView.topAnchor,
        constant: Metric.titleLabelTop)
      .fs_centerXAnchor(equalTo: containerView.centerXAnchor)
      .fs_endSetup()
    
    contentLabel
      .fs_topAnchor(
        equalTo: titleLabel.bottomAnchor,
        constant: Metric.contentLabelTop)
      .fs_leftAnchor(equalTo: containerView.leftAnchor)
      .fs_rightAnchor(equalTo: containerView.rightAnchor)
      .fs_endSetup()
    
    enumerationOneLabel
      .fs_topAnchor(
        equalTo: contentLabel.bottomAnchor,
        constant: Metric.enumerationOneLabelLabelTop)
      .fs_centerXAnchor(equalTo: containerView.centerXAnchor)
      .fs_endSetup()
    
    enumerationSecondLabel
      .fs_topAnchor(
        equalTo: enumerationOneLabel.bottomAnchor,
        constant: Metric.enumerationSecondLabelTop)
      .fs_centerXAnchor(equalTo: containerView.centerXAnchor)
      .fs_endSetup()
    
    allowAccessButton
      .fs_topAnchor(
        equalTo: enumerationSecondLabel.bottomAnchor,
        constant: Metric.allowAccessButtonTop)
      .fs_centerXAnchor(equalTo: containerView.centerXAnchor)
      .fs_endSetup()
  }
  
  func bind() {
    doneButton.rx.tap
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    allowAccessButton.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: {
        UIApplication.shared
          .openURL(URL(string: UIApplication.openSettingsURLString)!)
      })
      .disposed(by: disposeBag)
  }
}
