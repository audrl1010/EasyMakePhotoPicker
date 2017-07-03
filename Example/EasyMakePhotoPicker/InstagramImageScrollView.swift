//
//  InstagramImageScrollView.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 1..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class InstagramImageScrollView: BaseView {
  
  var imageView = UIImageView()
  
  var straightenGridImageView = UIImageView().then {
    $0.image = #imageLiteral(resourceName: "straighten-grid")
  }
  
  lazy var scrollView: UIScrollView = { [unowned self] in
    let scv = UIScrollView()
    scv.clipsToBounds = false
    scv.showsVerticalScrollIndicator = false
    scv.showsHorizontalScrollIndicator = false
    scv.alwaysBounceVertical = true
    scv.alwaysBounceHorizontal = true
    scv.bouncesZoom = true
    scv.decelerationRate = UIScrollViewDecelerationRateFast
    scv.scrollsToTop = false
    scv.minimumZoomScale = 2.0
    scv.maximumZoomScale = 0.8
    scv.delegate = self
    return scv
  }()
  
  override func setupViews() {
    backgroundColor = .red
    
    scrollView.addSubview(imageView)
    imageView.addSubview(straightenGridImageView)
    addSubview(scrollView)
  }
  
  override func setupConstraints() {
    straightenGridImageView
      .fs_leftAnchor(equalTo: imageView.leftAnchor)
      .fs_topAnchor(equalTo: imageView.topAnchor)
      .fs_rightAnchor(equalTo: imageView.rightAnchor)
      .fs_bottomAnchor(equalTo: imageView.bottomAnchor)
      .fs_endSetup()
    
    scrollView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    initializeContentSizeIfNeeded()
  }
  
  func display(image: UIImage) {
    imageView.image = image
    imageView.frame.size = image.size
  }
  
  func initializeContentSizeIfNeeded() {
    
  }
  
  func centerScrollView() {
    let scrollViewSize = scrollView.bounds.size
    let imageSize = imageView.frame.size
    
    let horizontalSpace =
    imageSize.width < scrollViewSize.width ?
      (scrollViewSize.width - imageSize.width) / 2 : 0
    
    scrollView.contentInset = UIEdgeInsets(
      top: 0,
      left: horizontalSpace,
      bottom: 0,
      right: horizontalSpace)
  }
}


extension InstagramImageScrollView: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}





