//
//  PhotoCellViewModel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import RxSwift

public class PhotoCellViewModel {
  
  public var photoAsset: PhotoAsset
  
  public var image = Variable<UIImage?>(nil)
  public var isSelect = BehaviorSubject<Bool>(value: false)
  public var selectedOrder = BehaviorSubject<Int>(value: 0)
  public var configure: PhotosViewConfigure
  
  public var disposeBag = DisposeBag()
  
  public init(
    photoAsset: PhotoAsset,
    configure: PhotosViewConfigure) {
    self.photoAsset = photoAsset
    self.configure = configure
    
    isSelect.onNext(photoAsset.isSelected)
    selectedOrder.onNext(photoAsset.selectedOrder)
    
    // update photoAsset`s isSelected property
    isSelect
      .subscribe(onNext: { [weak self] isSelect in
        guard let `self` = self else { return }
        self.photoAsset.isSelected = isSelect
      })
      .disposed(by: disposeBag)
    
    // update photoAsset`s selectedOrder property
    selectedOrder
      .subscribe(onNext: { [weak self] selectedOrder in
        guard let `self` = self else { return }
        self.photoAsset.selectedOrder = selectedOrder
      })
      .disposed(by: disposeBag)
  }
}











