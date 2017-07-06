//
//  KaKaoPhotoPicker.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 3..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

class KaKaoPhotoPicker: UINavigationController, KaKaoPhotoPickerOutput {
  
  var output: KaKaoPhotoPickerOutput { return self }
  
  var cancel: Observable<Void> {
    return pickerVC.output.cancel
  }
  
  var selectionDidComplete: Observable<[PhotoAsset]> {
    return pickerVC.output.selectionDidComplete
  }
  
  var photoDidTake: Observable<PhotoAsset> {
    return pickerVC.output.photoDidTake
  }
  
  fileprivate var pickerVC = KaKaoPhotoPickerVC()
  
  fileprivate var permissionVC = kaKaoPermissionVC()
  
  var disposeBag = DisposeBag()
  
  override func loadView() {
    super.loadView()
    
    let authorized = PhotoManager.shared.checkPhotoLibraryPermission().publish()
    // if access has been previously granted
    // on a first run of the app, the user taps OK in the alert box:
    // ---- true ----> .completed
    // on any subsequent run of the app if access has been previously granted:
    // ---- true ----> .completed
    authorized
      .skipWhile { $0 == false }
      .take(1)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.setViewControllers([self.pickerVC], animated: false)
      })
      .disposed(by: disposeBag)
    
    // if the user doesn`t grant access
    // on the first run of the app, the user taps on Don`t Grant in  the access alert box
    // ---- false ----> false ----> .completed
    // on any subsequent run if the user has previously denied access
    // ---- false ----> false ----> .completed
    authorized
      .skip(1)
      .filter { $0 == false }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.setViewControllers([self.permissionVC], animated: false)
      })
      .disposed(by: disposeBag)
    
    authorized
      .connect()
      .disposed(by: disposeBag)
  }
}

