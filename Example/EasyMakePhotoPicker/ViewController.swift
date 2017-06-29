//
//  ViewController.swift
//  EasyMakePhotoPicker
//
//  Created by audrl1010 on 06/29/2017.
//  Copyright (c) 2017 audrl1010. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

class ViewController: UIViewController {
  var button = UIButton(type: .system).then {
    $0.setTitle("Show FacebookPhotoPicker", for: .normal)
  }
  
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    button.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        let facebookPhotoPicker = FacebookPhotoPicker()
        
        facebookPhotoPicker.output.cancel
          .subscribe(onNext: { print("cancel") })
          .disposed(by: self.disposeBag)
        
        facebookPhotoPicker.output.photoDidTake
          .subscribe(onNext: { photoAsset in
            print("photoAsset: \(photoAsset)")
          })
          .disposed(by: self.disposeBag)
        
        facebookPhotoPicker.output.selectionDidComplete
          .subscribe(onNext: { photoAssets in
            print("photoAssetsCount: \(photoAssets.count)")
            photoAssets.forEach {
              print($0)
            }
          })
          .disposed(by: self.disposeBag)
        
        self.present(
          facebookPhotoPicker,
          animated: true,
          completion: nil)
      })
      .disposed(by: disposeBag)
    
    view.addSubview(button)
    
    button
      .fs_leftAnchor(
        equalTo: view.leftAnchor,
        constant: 30)
      .fs_rightAnchor(
        equalTo: view.rightAnchor,
        constant: -30)
      .fs_heightAnchor(equalToConstant: 50)
      .fs_centerXAnchor(equalTo: view.centerXAnchor)
      .fs_centerYAnchor(equalTo: view.centerYAnchor)
      .fs_endSetup()
  }
}

