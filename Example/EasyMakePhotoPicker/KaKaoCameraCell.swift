//
//  KaKaoCameraCell.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 5..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import RxSwift
import Photos
import PhotosUI
import EasyMakePhotoPicker

class KaKaoCameraCell: BaseCollectionViewCell, CameraCellable {
  
  var cameraIcon: UIImage {
    return #imageLiteral(resourceName: "camera")
  }
  
  var bgColor: UIColor {
    return .white
  }
  
  var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.image = centerAtRect(
      image: cameraIcon,
      rect: frame,
      bgColor: bgColor)
  }
  
  fileprivate func centerAtRect(
    image: UIImage?,
    rect: CGRect,
    bgColor: UIColor) -> UIImage? {
    guard let image = image else { return nil }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
    bgColor.setFill()
    UIRectFill( CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
    
    image.draw(in:
      CGRect(
        x:rect.size.width/2 - image.size.width/2,
        y:rect.size.height/2 - image.size.height/2,
        width: image.size.width,
        height: image.size.height))
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }
  
  override func addSubviews() {
    addSubview(imageView)
  }
  
  override func setupConstraints() {
    imageView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
}

