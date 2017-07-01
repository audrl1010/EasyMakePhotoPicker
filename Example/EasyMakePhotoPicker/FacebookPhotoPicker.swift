//
//  FacebookPhotoPicker.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 26..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

class FacebookPhotoPicker: UINavigationController, FacebookPhotoPickerOutput {
  var output: FacebookPhotoPickerOutput { return self }
  
  var pickerVC = FacebookPhotoPickerVC()

  var cancel: Observable<Void> {
    return pickerVC.output.cancel
  }
  
  var selectionDidComplete: Observable<[PhotoAsset]> {
    return pickerVC.output.selectionDidComplete
  }
  
  var photoDidTake: Observable<PhotoAsset> {
    return pickerVC.output.photoDidTake
  }
  
  override func loadView() {
    super.loadView()
    setViewControllers([pickerVC], animated: false)
  }
}
















