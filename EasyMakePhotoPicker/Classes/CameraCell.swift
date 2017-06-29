//
//  CameraCell.swift
//  PhotoTest
//
//  Created by myung gi son on 2017. 6. 20..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI
import RxSwift

public class CameraCell: PhotoCell {
  
  public var cameraIcon: UIImage {
    return #imageLiteral(resourceName: "camera")
  }
  
  public var bgColor: UIColor {
    return .white
  }
  
  override public func setupViews() {
    super.setupViews()
    checkView.isHidden = true
  }
  
  override public func layoutSubviews() {
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
}











