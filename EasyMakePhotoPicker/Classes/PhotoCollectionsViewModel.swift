//
//  PhotoCollectionsViewModel.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import RxSwift
import Photos

public protocol PhotoCollectionsViewModelOutput {
  var cellDidChange: PublishSubject<CellChangeEvent> { get }
  var photoCollectionDidSelectWhenCellDidSelect: PublishSubject<(IndexPath, PhotoAssetCollection)> { get }
}

public protocol PhotoCollectionsViewModelInput {
  var cellDidSelect: PublishSubject<IndexPath> { get }
}

public protocol PhotoCollectionsViewModelType {
  var outputs: PhotoCollectionsViewModelOutput { get }
  var inputs: PhotoCollectionsViewModelInput { get }
  
  func numberOfSection() -> Int
  func numberOfItems() -> Int
  func cellViewModel(at indexPath: IndexPath) -> PhotoCollectionCellViewModel
}

open class PhotoCollectionsViewModel:
  PhotoCollectionsViewModelOutput,
  PhotoCollectionsViewModelInput,
  PhotoCollectionsViewModelType {
  
  open var outputs: PhotoCollectionsViewModelOutput { return self }
  open var inputs: PhotoCollectionsViewModelInput { return self }
  
  // MARK: - Input
  open var cellDidSelect = PublishSubject<IndexPath>()
  
  // MARK: - Output
  
  open var photoCollectionDidSelectWhenCellDidSelect = PublishSubject<(IndexPath, PhotoAssetCollection)>()
  
  open var cellDidChange = PublishSubject<CellChangeEvent>()
  
  fileprivate var disposeBag: DisposeBag = DisposeBag()
  
  fileprivate var photoManager: PhotoManager = PhotoManager.shared
  
  fileprivate var photoAssetCollections: [PhotoAssetCollection] = []
  
  fileprivate var cellViewModels: [IndexPath: PhotoCollectionCellViewModel] = [:]
  
  fileprivate var currentSelectedViewModel: PhotoCollectionCellViewModel?
  
  fileprivate var configure: PhotoCollectionsViewConfigure
  
  public init(configure: PhotoCollectionsViewConfigure) {
    self.configure = configure
    bindViewModel()
  }
  
  fileprivate func bindViewModel() {
    let thumbnailSize = CGSize(
      width: self.configure.photoCollectionThumbnailSize.width * UIScreen.main.scale,
      height: self.configure.photoCollectionThumbnailSize.height * UIScreen.main.scale)
    
    photoManager.fetchCollections(
      assetCollectionTypes: self.configure.showsCollectionTypes,
      thumbnailImageSize: thumbnailSize,
      options: self.configure.fetchOptions)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] photoAssetCollections in
        guard let `self` = self else { return }
        self.photoAssetCollections = photoAssetCollections
        self.cellDidChange.onNext(.reset)
      })
      .disposed(by: disposeBag)
    
    photoManager.photoLibraryChangeEvent
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { changeInstance in
        self.photoAssetCollections
          .enumerated()
          .forEach { [weak self] offset, photoAssetCollection in
            guard let `self` = self else { return }
            
            if let changes = changeInstance
              .changeDetails(for: photoAssetCollection.assetCollection) {
              
              // have deleted photoAssetCollection?
              if changes.objectWasDeleted {
                self.photoAssetCollections.remove(at: offset)
                self.cellViewModels.removeValue(forKey: IndexPath(item: offset, section: 0))
                self.cellDidChange.onNext(.delete([IndexPath(item: offset, section: 0)]))
                return
              }
              
              // have changed photoAssetCollection?
              if let objectAfterChange = changes.objectAfterChanges as? PHAssetCollection {
                
                // To update collection`s title commonly
                self.photoAssetCollections[offset].assetCollection = objectAfterChange
              }
            }
            
            if let changes = changeInstance
              .changeDetails(for: photoAssetCollection.fetchResult) {
              
              // To update collection`s count, update fetchResult.
              self.photoAssetCollections[offset].fetchResult = changes.fetchResultAfterChanges
              
              if let cellViewModel = self.cellViewModels[IndexPath(item: offset, section: 0)] {
                cellViewModel.count.onNext(changes.fetchResultAfterChanges.count)
              }
              
              // To update collection`s latest thumbnail, update photoAssetCollection`s thumbnail.
              if changes.hasIncrementalChanges {
                if let removed = changes.removedIndexes, removed.count > 0 {
                  
                  let removedIndexs = removed.map { Int($0) }
                  
                  // if latest photoAsset is changed,
                  // update changed latest photoAsset`s image
                  // photoAssetCollection thumbnail.
                  if removedIndexs.contains(changes.fetchResultBeforeChanges.count - 1) {
                    // last photoAsset in already updated photoAssetCollection is latest asset.
                    if let latestAsset = self.photoAssetCollections[offset].assetsInFetchResult.last {
                      self.photoManager.image(
                        for: latestAsset,
                        size: thumbnailSize)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] image in
                          guard let `self` = self else { return }
                          self.photoAssetCollections[offset].thumbnail = image
                          if let cellViewModel = self.cellViewModels[IndexPath(item: offset, section: 0)] {
                            cellViewModel.thumbnail.onNext(image)
                          }
                        })
                        .disposed(by: self.disposeBag)
                    }
                  }
                }
                if let inserted = changes.insertedIndexes, inserted.count > 0 {
                  if let latestAsset = self.photoAssetCollections[offset].assetsInFetchResult.last {
                    self.photoManager.image(
                      for: latestAsset,
                      size: thumbnailSize)
                      .observeOn(MainScheduler.instance)
                      .subscribe(onNext: { [weak self] image in
                        guard let `self` = self else { return }
                        self.photoAssetCollections[offset].thumbnail = image
                        if let cellViewModel = self.cellViewModels[IndexPath(item: offset, section: 0)] {
                          cellViewModel.thumbnail.onNext(image)
                        }
                      })
                      .disposed(by: self.disposeBag)
                  }
                }
                if let changed = changes.changedIndexes, changed.count > 0 {
                  
                  let changedIndexs = changed.map { Int($0) }
                  
                  // if latest photoAsset is changed,
                  // update changed latest photoAsset`s image
                  // photoAssetCollection thumbnail.
                  if changedIndexs.contains(changes.fetchResultAfterChanges.count - 1) {
                    if let latestAsset = self.photoAssetCollections[offset].assetsInFetchResult.last {
                      self.photoManager.image(
                        for: latestAsset,
                        size: thumbnailSize)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] image in
                          guard let `self` = self else { return }
                          self.photoAssetCollections[offset].thumbnail = image
                          if let cellViewModel = self.cellViewModels[IndexPath(item: offset, section: 0)] {
                            cellViewModel.thumbnail.onNext(image)
                          }
                        })
                        .disposed(by: self.disposeBag)
                    }
                  }
                }
              }
            }
        }
      })
      .disposed(by: disposeBag)
    
    inputs.cellDidSelect
      .subscribe(onNext: { [weak self] indexPath in
        guard let `self` = self else { return }
        
        if let selectedCellViewModel = self.cellViewModels[indexPath] {
          let oldSelectedCellViewModel = self.cellViewModels
            .map {
              $0.value
            }
            .filter {
              $0.isSelect.value == true
            }
            .first
          
          if let oldSelectedCellViewModel = oldSelectedCellViewModel {
            oldSelectedCellViewModel.isSelect.value = false
          }
          
          selectedCellViewModel.isSelect.value = true
        }
        
        self.photoCollectionDidSelectWhenCellDidSelect
          .onNext((indexPath, self.photoAssetCollections[indexPath.item]))
      })
      .disposed(by: disposeBag)
  }
  
  open func numberOfSection() -> Int {
    return 1
  }
  
  open func numberOfItems() -> Int {
    return photoAssetCollections.count
  }
  
  // To sort photos in the latest order, calculates by inverting the index of the fetchResult.
  fileprivate func assetAtInvertedIndex(
    with originalIndex: Int,
    in fetchResult: PHFetchResult<PHAsset>) -> PHAsset {
    return fetchResult[fetchResult.count - originalIndex - 1]
  }
  
  open func cellViewModel(at indexPath: IndexPath) -> PhotoCollectionCellViewModel {
    if let cellViewModel = cellViewModels[indexPath] {
      return cellViewModel
    }
    else {
      let cellViewModel = PhotoCollectionCellViewModel()
      let photoAssetCollection = photoAssetCollections[indexPath.item]
      cellViewModel.count.onNext(photoAssetCollection.count)
      cellViewModel.title.onNext(photoAssetCollection.title)
      cellViewModel.thumbnail.onNext(photoAssetCollection.thumbnail)
      cellViewModels[indexPath] = cellViewModel
      
      return cellViewModel
    }
  }
}
