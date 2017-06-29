//
//  UICollection+Extension.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 26..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

public enum CellChangeEvent {
  case scrollTo(IndexPath)
  case insert([IndexPath])
  case update([IndexPath])
  case delete([IndexPath])
  case move(from:IndexPath, to: IndexPath)
  case reset
  case begin
  case end
}


extension UICollectionView {
  public func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
    let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
    return allLayoutAttributes.map { $0.indexPath }
  }
}

extension UICollectionView
{
  fileprivate class SettingBatchContext
  {
    typealias BlockToExecuteBatch = () -> Void
    var isToExecuteBatch: Bool = false
    var blocksToExecuteBatch: [BlockToExecuteBatch] = []
  }
  
  fileprivate struct StaticVariables
  {
    static var settingBatchContextKey = "settingBatchContextKey"
  }
  
  fileprivate var settingBatchContext: SettingBatchContext
  {
    if let sbc = objc_getAssociatedObject(self, &StaticVariables.settingBatchContextKey) as? SettingBatchContext
    {
      return sbc
    }
    else
    {
      let sbc: SettingBatchContext = SettingBatchContext()
      objc_setAssociatedObject(self,
                               &StaticVariables.settingBatchContextKey,
                               sbc,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return sbc
    }
  }
  
  public func beginUpdates()
  {
    settingBatchContext.isToExecuteBatch = true
  }
  
  public func endUpdates()
  {
    performBatchUpdates({ [weak self] in
      guard let weakSelf = self else { return }
      weakSelf.settingBatchContext.blocksToExecuteBatch.forEach({ $0() })
      }, completion: { [weak self] (_) in
        guard let weakSelf = self else { return }
        weakSelf.settingBatchContext.isToExecuteBatch = false
        weakSelf.settingBatchContext.blocksToExecuteBatch.removeAll()
    })
  }
  
  public func reload(itemsAt: [IndexPath])
  {
    if settingBatchContext.isToExecuteBatch
    {
      settingBatchContext.blocksToExecuteBatch.append({ [weak self] in
        guard let weakSelf = self else { return }
        weakSelf.reloadItems(at: itemsAt)
      })
    }
    else
    {
      reloadItems(at: itemsAt)
    }
  }
  
  public func insert(itemsAt: [IndexPath])
  {
    if settingBatchContext.isToExecuteBatch
    {
      settingBatchContext.blocksToExecuteBatch.append({ [weak self] in
        guard let weakSelf = self else { return }
        weakSelf.insertItems(at: itemsAt)
      })
    }
    else
    {
      insertItems(at: itemsAt)
    }
  }
  
  public func delete(itemsAt: [IndexPath])
  {
    if settingBatchContext.isToExecuteBatch
    {
      settingBatchContext.blocksToExecuteBatch.append({ [weak self] in
        guard let weakSelf = self else { return }
        weakSelf.deleteItems(at: itemsAt)
      })
    }
    else
    {
      deleteItems(at: itemsAt)
    }
  }
}
