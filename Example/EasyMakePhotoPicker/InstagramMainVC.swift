//
//  InstagramMainVC.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 2..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import EasyMakePhotoPicker
import Photos
import RxSwift

class InstagramMainVC: UIViewController {
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scrollView = InstagramImageScrollView()
    view.addSubview(scrollView)
    scrollView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_topAnchor(equalTo: view.topAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_heightAnchor(equalToConstant: view.frame.height * 0.4)
      .fs_endSetup()
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let imageSize = CGSize(
      width: view.frame.width,
      height: view.frame.height * 0.4)
    
    PhotoManager.shared
      .fetchCollections(
        assetCollectionTypes: [.smartAlbumUserLibrary],
        thumbnailImageSize: CGSize(width: 50, height: 50),
        options: fetchOptions)
      .map {
        $0.first!.fetchResult.object(at: 0)
      }
      .flatMap {
        PhotoManager.shared.image(for: $0, size: imageSize)
      }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { image in
        scrollView.display(image: image)
      })
      .disposed(by: disposeBag)
  }
}









