//
//  PhotoCollectionCellViewModel.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import RxSwift

open class PhotoCollectionCellViewModel {
  open var count = BehaviorSubject<Int>(value: 0)
  open var thumbnail = BehaviorSubject<UIImage?>(value: nil)
  open var title = BehaviorSubject<String>(value: "")
  open var isSelect = Variable<Bool>(false)
}




