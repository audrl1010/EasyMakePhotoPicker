//
//  PhotoCollectionCellViewModel.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import RxSwift

public class PhotoCollectionCellViewModel {
  public var count = BehaviorSubject<Int>(value: 0)
  public var thumbnail = BehaviorSubject<UIImage?>(value: nil)
  public var title = BehaviorSubject<String>(value: "")
  public var isSelect = Variable<Bool>(false)
}




