//
//  MainVC.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 3..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

class MainVC: UIViewController {
  var basicPhotoPickerButton = UIButton(type: .system).then {
    $0.setTitle("Show Basic PhotoPicker", for: .normal)
  }
  
  var facebookPhotoPickerButton = UIButton(type: .system).then {
    $0.setTitle("Show FacebookPhotoPicker", for: .normal)
  }
  
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    basicPhotoPickerButton.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        let photoPicker = PhotoPicker()
        
        photoPicker.output.cancel
          .subscribe(onNext: { print("cancel") })
          .disposed(by: self.disposeBag)
        
        photoPicker.output.photoDidTake
          .subscribe(onNext: { photoAsset in
            print("photoAsset: \(photoAsset)")
          })
          .disposed(by: self.disposeBag)
        
        photoPicker.output.selectionDidComplete
          .subscribe(onNext: { photoAssets in
            print("photoAssetsCount: \(photoAssets.count)")
            photoAssets.forEach {
              print($0)
            }
          })
          .disposed(by: self.disposeBag)
        
        self.present(
          photoPicker,
          animated: true,
          completion: nil)
      })
      .disposed(by: disposeBag)
    
    facebookPhotoPickerButton.rx.controlEvent(.touchUpInside)
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
    
    
    view.addSubview(basicPhotoPickerButton)
    view.addSubview(facebookPhotoPickerButton)
    
    basicPhotoPickerButton
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
    
    facebookPhotoPickerButton
      .fs_topAnchor(
        equalTo: basicPhotoPickerButton.bottomAnchor,
        constant: 20)
      .fs_leftAnchor(
        equalTo: view.leftAnchor,
        constant: 30)
      .fs_rightAnchor(
        equalTo: view.rightAnchor,
        constant: -30)
      .fs_heightAnchor(equalToConstant: 50)
      .fs_endSetup()
    
  }
}



