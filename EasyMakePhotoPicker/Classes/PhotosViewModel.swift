//
//  PhotosViewModel.swift
//  PhotoTest
//
//  Created by myung gi son on 2017. 6. 20..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Photos
import PhotosUI
import RxSwift


public protocol PhotosViewModelInput {

  var photoSizeDidInput: PublishSubject<CGSize> { get }
  
  var viewDidLoad: PublishSubject<Void> { get }
  
  var currentPhotoAssetCollectionDidChange: PublishSubject<PhotoAssetCollection> { get }
  
  var cellDidSelect: PublishSubject<IndexPath> { get }
  
  var displayingCellDidEnd: PublishSubject<IndexPath> { get }
  
  var scrollingDidStop: PublishSubject<[IndexPath]> { get }
  
  var cachedRectDidUpdate:
    PublishSubject<(addedIndexPaths: [IndexPath], removedIndexPaths:[IndexPath])> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectionDidComplete: PublishSubject<Void> { get }
}

public protocol PhotosViewModelOutput {

  var cellDidChange: PublishSubject<CellChangeEvent> { get }
  
  var maxCountSelectedPhotosIsExceeded: PublishSubject<Void> { get }
  
  var videoDidPlay: PublishSubject<PlayEvent> { get }
  
  // only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true
  var cameraDidClick: PublishSubject<Void> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectedPhotoAssetsDidComplete: PublishSubject<[PhotoAsset]> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectedPhotosCount: PublishSubject<Int> { get }
  
  var photoAssetDidSelected: PublishSubject<PhotoAsset> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var photoAssetDidDeselected: PublishSubject<PhotoAsset> { get }
}

public protocol PhotosViewModelType {
  var inputs: PhotosViewModelInput { get }
  var outputs: PhotosViewModelOutput { get }
  
  func numberOfSection() -> Int
  func numberOfItems() -> Int
  func cellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel
}

class PhotosViewModel:
  PhotosViewModelType,
  PhotosViewModelInput,
  PhotosViewModelOutput {
  
  open var inputs: PhotosViewModelInput { return self }
  open var outputs: PhotosViewModelOutput { return self }
  
  // MARK: - Input
  
  open var viewDidLoad = PublishSubject<Void>()
  
  open var photoSizeDidInput = PublishSubject<CGSize>()
  
  open var currentPhotoAssetCollectionDidChange = PublishSubject<PhotoAssetCollection>()
  
  open var cellDidSelect = PublishSubject<IndexPath>()
  
  open var displayingCellDidEnd = PublishSubject<IndexPath>()
  
  open var scrollingDidStop = PublishSubject<[IndexPath]>()
  
  open var cachedRectDidUpdate =
    PublishSubject<(addedIndexPaths: [IndexPath], removedIndexPaths: [IndexPath])>()
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  open var selectionDidComplete = PublishSubject<Void>()
  
  // MARK: - Output
  
  open var cellDidChange = PublishSubject<CellChangeEvent>()
  
  open var maxCountSelectedPhotosIsExceeded = PublishSubject<Void>()
  
  open var videoDidPlay = PublishSubject<PlayEvent>()
  
  open var photoAssetDidSelected = PublishSubject<PhotoAsset>()

  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  open var photoAssetDidDeselected = PublishSubject<PhotoAsset>()
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  open var selectedPhotoAssetsDidComplete = PublishSubject<[PhotoAsset]>()
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  open var selectedPhotosCount = PublishSubject<Int>()
  
  // only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true
  open var cameraDidClick = PublishSubject<Void>()
  
  // MARK: - Properties
  
  open var photoSize: CGSize = CGSize(width: 1280, height: 720)

  fileprivate var configure: PhotosViewConfigure

  fileprivate var photoManager: PhotoManager = PhotoManager.shared

  fileprivate var currentPhotoAssetCollection: PhotoAssetCollection?
  
  fileprivate var currentCollectionType: PHAssetCollectionSubtype?
  
  fileprivate var currentPlayingCellViewModel: PhotoCellViewModel?
  
  fileprivate var currentSelectedCellViewModelToUseSingleSelection: PhotoCellViewModel?
  
  // key: PhotoAsset`s localIdentifier
  fileprivate var cellViewModels: [String: PhotoCellViewModel] = [:]
  
  fileprivate var disposeBag = DisposeBag()
  
  deinit {
    self.photoManager.stopCachingForAllAssets()
  }
  
  // use photoAssetCollection or collectionType.
  public init(
    configure: PhotosViewConfigure,
    photoAssetCollection: PhotoAssetCollection) {
    self.configure = configure
    self.currentPhotoAssetCollection = photoAssetCollection
    setupViewModel()
  }
 
  public init(
    configure: PhotosViewConfigure,
    collectionType: PHAssetCollectionSubtype) {
    self.configure = configure
    self.currentCollectionType = collectionType
    setupViewModel()
  }
  
  fileprivate func setupViewModel() {
    inputs.viewDidLoad
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        // fetch collections setted assetCollectionTypes in photoManager
        if let currentCollectionType = self.currentCollectionType {
          self.photoManager
            .fetchCollections(
              assetCollectionTypes: [currentCollectionType],
              thumbnailImageSize: self.photoSize,
              options: self.configure.fetchOptions)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] photoAssetCollections in
              guard let `self` = self else { return }
              if let photoAssetCollection = photoAssetCollections.first {
                self.currentPhotoAssetCollection = photoAssetCollection
                self.outputs.cellDidChange.onNext(.reset)
              }
            })
            .disposed(by: self.disposeBag)
        }
        else {
          // load currentPhotoAssetCollection
          self.outputs.cellDidChange.onNext(.reset)
        }
      })
      .disposed(by: disposeBag)
    
    inputs.photoSizeDidInput
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] photoSize in
        guard let `self` = self else { return }
        self.photoSize = photoSize
      })
      .disposed(by: disposeBag)
    
    inputs.currentPhotoAssetCollectionDidChange
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] photoAssetCollection in
        guard let `self` = self else { return }
        if let currentPlayingCellViewModel = self.currentPlayingCellViewModel {
          self.stop(photoCellViewModel: currentPlayingCellViewModel)
          self.currentPlayingCellViewModel = nil
        }
        self.currentPhotoAssetCollection = photoAssetCollection
        self.currentCollectionType = nil
        self.currentSelectedCellViewModelToUseSingleSelection = nil
        self.cellViewModels.removeAll()
        self.outputs.cellDidChange.onNext(.reset)
      })
      .disposed(by: disposeBag)
    
    inputs.displayingCellDidEnd
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] indexPath in
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection,
          let currentPlayingCellViewModel = self.currentPlayingCellViewModel else {
            return
        }
        
        // except camera indexPath
        if self.configure.allowsCameraSelection && indexPath.item == 0 {
          return
        }
        
        let asset = currentPhotoAssetCollection.fetchResult.object(
          at: indexPath.item - (self.configure.allowsCameraSelection ? 1 : 0))
        
        if let disappearedCellViewModel = self.cellViewModels[asset.localIdentifier],
          currentPlayingCellViewModel.photoAsset.localIdentifier ==
            disappearedCellViewModel.photoAsset.localIdentifier {
          self.stop(photoCellViewModel: currentPlayingCellViewModel)
          self.currentPlayingCellViewModel = nil
        }
      })
      .disposed(by: disposeBag)
    
    inputs.scrollingDidStop
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] currentVisibleIndexPaths in
        
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection,
          self.currentPlayingCellViewModel == nil else { return }
        
        // except camera indexPath
        let visibleIndexPaths: [IndexPath] =
          self.configure.allowsCameraSelection ?
            currentVisibleIndexPaths.filter { $0.item != 0 } : currentVisibleIndexPaths
        
        let visiblePhotoAssets: [PhotoAsset] = visibleIndexPaths
          .sorted { $0.0.item < $0.1.item }
          .map { indexPath -> IndexPath in
            var indexPath = indexPath
            indexPath.item = indexPath.item - (self.configure.allowsCameraSelection ? 1 : 0)
            return indexPath
          }
          .map {
            currentPhotoAssetCollection.fetchResult.object(at: $0.item)
          }
          .map { PhotoAsset(asset: $0) }
        
        let visibleVideoPhotoAssets = visiblePhotoAssets.filter {
          self.configure.allowsPlayTypes.contains($0.type)
          }
        
        let visibleVideoCellViewModels = visibleVideoPhotoAssets
          .flatMap {
            self.cellViewModels[$0.localIdentifier]
          }
        
        let visibleSelectedVideoCellViewModels: [PhotoCellViewModel] = visibleVideoCellViewModels
          .filter {
            $0.photoAsset.isSelected
          }
          .sorted {
            $0.0.photoAsset.selectedOrder < $0.1.photoAsset.selectedOrder
          }
        
        if let lastSelectedVideoCellViewModel = visibleSelectedVideoCellViewModels.last {
          self.play(photoCellViewModel: lastSelectedVideoCellViewModel)
          self.currentPlayingCellViewModel = lastSelectedVideoCellViewModel
        }
        else if let firstVideoCellViewModel = visibleVideoCellViewModels.first {
          self.play(photoCellViewModel: firstVideoCellViewModel)
          self.currentPlayingCellViewModel = firstVideoCellViewModel
        }
      })
      .disposed(by: disposeBag)
    
    inputs.selectionDidComplete
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        // only allows multipleSelection
        if self.configure.allowsMultipleSelection {
          let selectedPhotoAssets = self.cellViewModels
            .filter { $0.value.photoAsset.isSelected }
            .map { $0.value.photoAsset }
            .sorted { $0.0.selectedOrder < $0.1.selectedOrder }
          
          self.outputs.selectedPhotoAssetsDidComplete.onNext(selectedPhotoAssets)
        }
      })
      .disposed(by: disposeBag)
    
    inputs.cellDidSelect
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] indexPath in
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection else {
            return
        }
        // cameraCell
        if self.configure.allowsCameraSelection && indexPath.item == 0 {
          self.cameraDidClick.onNext(())
        }
        else {
          let selectedAsset =
            currentPhotoAssetCollection.fetchResult.object(
              at: indexPath.item - (self.configure.allowsCameraSelection ? 1 : 0))
          
          if let selectedCellViewModel = self.cellViewModels[selectedAsset.localIdentifier] {
            // allows multiple selection
            if self.configure.allowsMultipleSelection {
              // select
              if selectedCellViewModel.photoAsset.isSelected == false {
                let selectedCellViewModels = self.cellViewModels
                  .map { $0.value }
                  .filter { $0.photoAsset.isSelected }
                  .sorted {
                    $0.0.photoAsset.selectedOrder < $0.1.photoAsset.selectedOrder
                  }
                
                guard selectedCellViewModels.count < self.configure.maxCountSelectedPhotos else {
                  self.outputs.maxCountSelectedPhotosIsExceeded.onNext()
                  return
                }
                selectedCellViewModel.selectedOrder.onNext(selectedCellViewModels.count + 1)
                selectedCellViewModel.isSelect.onNext(true)
                self.photoAssetDidSelected.onNext(selectedCellViewModel.photoAsset)
                self.selectedPhotosCount.onNext(selectedCellViewModels.count + 1)
                
                // have playing cell? && is allowed play type?
                if let currentPlayingCellViewModel = self.currentPlayingCellViewModel,
                  self.configure.allowsPlayTypes.contains(selectedCellViewModel.photoAsset.type) {
                  // playing cell != selected cell
                  if currentPlayingCellViewModel.photoAsset.localIdentifier !=
                    selectedCellViewModel.photoAsset.localIdentifier {
                    // stop playing cell and play selected cell
                    self.stop(photoCellViewModel: currentPlayingCellViewModel)
                    self.play(photoCellViewModel: selectedCellViewModel)
                    self.currentPlayingCellViewModel = selectedCellViewModel
                  }
                }
                // keep running playing cell
              }
              else {
                // deselect
                selectedCellViewModel.isSelect.onNext(false)
                self.photoAssetDidDeselected.onNext(selectedCellViewModel.photoAsset)
                
                let selectedCellViewModels = self.cellViewModels
                  .map { $0.value }
                  .filter {
                    $0.photoAsset.isSelected
                  }
                  .sorted {
                    $0.0.photoAsset.selectedOrder < $0.1.photoAsset.selectedOrder
                  }
                
                var offset = 0
                selectedCellViewModels
                  .forEach {
                    $0.selectedOrder.onNext(offset + 1)
                    offset += 1
                  }
                
                self.selectedPhotosCount.onNext(selectedCellViewModels.count)
              }
            }
            else {
              // allows single selection
              if let currentSelectedCellViewModelToUseSingleSelection =
                self.currentSelectedCellViewModelToUseSingleSelection {
                // current selected cellViewModel != new selected cellViewModel
                // => current selected cellViewModel
                if !(currentSelectedCellViewModelToUseSingleSelection.photoAsset.localIdentifier ==
                  selectedCellViewModel.photoAsset.localIdentifier) {
                  //  current selected cellViewModel`s selection = false
                  currentSelectedCellViewModelToUseSingleSelection.isSelect.onNext(false)
                  
                  // new selected cellViewModel`s selection = true
                  selectedCellViewModel.isSelect.onNext(true)
                  
                  // current selected cellViewModel = new selected cellViewModel
                  self.currentSelectedCellViewModelToUseSingleSelection = selectedCellViewModel
                }
              }
              else {
                selectedCellViewModel.isSelect.onNext(true)
                // self.current selected cellViewModel = new selected cellViewModel
                // because current selected cellViewModel == nil
                self.currentSelectedCellViewModelToUseSingleSelection = selectedCellViewModel
              }
              
              self.photoAssetDidSelected.onNext(selectedCellViewModel.photoAsset)
              
              // have playing cell? && is allowed play type?
              if let currentPlayingCellViewModel = self.currentPlayingCellViewModel,
                self.configure.allowsPlayTypes.contains(selectedCellViewModel.photoAsset.type) {
                // playing cell != selected cell
                if currentPlayingCellViewModel.photoAsset.localIdentifier !=
                  selectedCellViewModel.photoAsset.localIdentifier {
                  // stop playing cell and play selected cell
                  self.stop(photoCellViewModel: currentPlayingCellViewModel)
                  self.play(photoCellViewModel: selectedCellViewModel)
                  self.currentPlayingCellViewModel = selectedCellViewModel
                }
              }
              // keep running playing cell
            }
          }
        }
      })
      .disposed(by: disposeBag)
    
    photoManager.photoLibraryChangeEvent
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] changeInstance in
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection else {
            return
        }

        if let changes = changeInstance.changeDetails(for: currentPhotoAssetCollection.fetchResult) {
          
          // update fetchResult
          self.currentPhotoAssetCollection?.fetchResult = changes.fetchResultAfterChanges

          // if have playing cell, stop playing cell.
          if let currentPlayingCellViewModel = self.currentPlayingCellViewModel {
            self.stop(photoCellViewModel: currentPlayingCellViewModel)
            self.currentPlayingCellViewModel = nil
          }
          
          if changes.hasIncrementalChanges {
            if let removed = changes.removedIndexes {
              let removedAssets = removed
                .map { changes.fetchResultBeforeChanges.object(at: $0) }
              
              // delete currentSelectedCellViewModelToUseSingleSelection
              if self.configure.allowsMultipleSelection,
                let currentSelectedCellViewModelToUseSingleSelection =
                self.currentSelectedCellViewModelToUseSingleSelection {
                
                if removedAssets.contains(where: {
                  currentSelectedCellViewModelToUseSingleSelection.photoAsset.localIdentifier
                    == $0.localIdentifier}) {
                  self.currentSelectedCellViewModelToUseSingleSelection = nil
                }
              }
              // delete cellViewModels
              removedAssets
                .map {
                  $0.localIdentifier
                }
                .forEach {
                  self.cellViewModels.removeValue(forKey: $0)
                }
            }
            if let inserted = changes.insertedIndexes {
              // create cellViewModels
              inserted
                .map {
                  PhotoAsset(asset: changes.fetchResultAfterChanges.object(at: $0))
                }
                .forEach { [weak self] photoAsset in
                  guard let `self` = self else { return }
                  
                  let cellViewModel = self.createCellViewModel(with: photoAsset)
                  self.cellViewModels[photoAsset.localIdentifier] = cellViewModel
                }
            }
            if let changed = changes.changedIndexes {
              // reload cellViewModels
              changed
                .forEach { [weak self] index in
                  guard let `self` = self else { return }
                  let oldAsset = changes.fetchResultBeforeChanges.object(at: index)
                  let newAsset = changes.fetchResultAfterChanges.object(at: index)
                  var newPhotoAsset = PhotoAsset(asset: newAsset)
                  
                  if let oldPhotoAsset = self.cellViewModels[oldAsset.localIdentifier]?.photoAsset {
                    newPhotoAsset.isSelected = oldPhotoAsset.isSelected
                    newPhotoAsset.selectedOrder = oldPhotoAsset.selectedOrder
                    self.cellViewModels.removeValue(forKey: oldPhotoAsset.localIdentifier)
                    self.cellViewModels.updateValue(
                      self.createCellViewModel(with: newPhotoAsset),
                      forKey: newPhotoAsset.localIdentifier)
                  }
                }
            }
          }
          self.cellDidChange.onNext(.reset)
            
          // only allows multipleSelection
          if self.configure.allowsMultipleSelection {
            let selectedCellViewModels = self.cellViewModels
              .map { $0.value }
              .filter { $0.photoAsset.isSelected }
              .sorted {
                $0.0.photoAsset.selectedOrder < $0.1.photoAsset.selectedOrder
              }
            
            var offset = 0
            selectedCellViewModels
              .forEach {
                $0.selectedOrder.onNext(offset + 1)
                offset += 1
              }
            self.selectedPhotosCount.onNext(selectedCellViewModels.count)
          }
          
          self.photoManager.stopCachingForAllAssets()
        }
      })
      .disposed(by: disposeBag)
    
    inputs.cachedRectDidUpdate
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (addedIndexPaths, removedIndexPaths) in
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection else {
            return
        }
        
        var addedIndexPaths = addedIndexPaths
        var removedIndexPaths = removedIndexPaths
        
        // except cameraIndexPath
        if self.configure.allowsCameraSelection {
          addedIndexPaths = addedIndexPaths.filter { $0.item != 0 }
          removedIndexPaths = removedIndexPaths.filter { $0.item != 0 }
        }
        
        let addedAssets = addedIndexPaths
          .map {
            currentPhotoAssetCollection.fetchResult.object(
              at: $0.item - (self.configure.allowsCameraSelection ? 1 : 0))
          }
        
        let removedAssets = removedIndexPaths
          .map {
            currentPhotoAssetCollection.fetchResult.object(
              at: $0.item - (self.configure.allowsCameraSelection ? 1 : 0))
          }
        
        self.photoManager.startCaching(
          assets: addedAssets,
          targetSize: self.photoSize,
          contentMode: .aspectFill,
          options: nil)
        
        self.photoManager.stopCaching(
          assets: removedAssets,
          targetSize: self.photoSize,
          contentMode: .aspectFill,
          options: nil)
      })
      .disposed(by: disposeBag)
  }
  
  open func numberOfSection() -> Int {
    return 1
  }
  
  open func numberOfItems() -> Int {
    guard let currentPhotoAssetCollection = currentPhotoAssetCollection else {
      return 0
    }
    
    return currentPhotoAssetCollection.fetchResult.count +
      (self.configure.allowsCameraSelection ? 1 : 0)
  }
  
  open func cellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel {
    
    guard let currentPhotoAssetCollection = currentPhotoAssetCollection else {
      return PhotoCellViewModel(
        photoAsset: PhotoAsset(asset: PHAsset()), configure: configure)
    }
    
    if self.configure.allowsCameraSelection == true, indexPath.item == 0 {
      return self.createCellViewModel(with: PhotoAsset(asset: PHAsset()))
    }
    else {
      let currentPhotoAsset = PhotoAsset(
        asset: currentPhotoAssetCollection.fetchResult.object(
          at: indexPath.item - (self.configure.allowsCameraSelection ? 1 : 0)))
      
      if let cellViewModel = cellViewModels[currentPhotoAsset.localIdentifier] {
        return cellViewModel
      }
      else {
        let cellViewModel = self.createCellViewModel(with: currentPhotoAsset)
        
        cellViewModels[currentPhotoAsset.localIdentifier] = cellViewModel
        
        return cellViewModel
      }
    }
  }
  
}

// MARK: - Create CellViewModel

extension PhotosViewModel {
  fileprivate func createCellViewModel(with photoAsset: PhotoAsset) -> PhotoCellViewModel {
    var cellViewModel: PhotoCellViewModel
    
    switch photoAsset.type {
    case .photo:
      cellViewModel = PhotoCellViewModel(
        photoAsset: photoAsset,
        configure: configure)
      
    case .livePhoto:
      cellViewModel = LivePhotoCellViewModel(
        photoAsset: photoAsset,
        configure: configure)
      
    case .video:
      cellViewModel = VideoCellViewModel(
        photoAsset: photoAsset,
        configure: configure)
      
    case .camera:
      cellViewModel = CameraCellViewModel(
        photoAsset: photoAsset,
        configure: configure)
    }
    
    if photoAsset.type != .camera {
      photoManager.image(
        for: photoAsset.asset,
        size: photoSize)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak cellViewModel] image in
          guard let `cellViewModel` = cellViewModel else { return }
          cellViewModel.image.value = image
        })
        .disposed(by: disposeBag)
    }
    
    return cellViewModel
  }
}


// MARK: - Play && Stop (Video or LivePhoto)

public enum PlayEvent {
  case stop
  case play
}

extension PhotosViewModel {
  fileprivate func stop(photoCellViewModel: PhotoCellViewModel) {
    if let photoCellViewModel = photoCellViewModel as? VideoCellViewModel {
      photoCellViewModel.playEvent.onNext(.stop)
    }
    else if let photoCellViewModel = photoCellViewModel as? LivePhotoCellViewModel {
      photoCellViewModel.playEvent.onNext(.stop)
    }
  }
  
  fileprivate func play(photoCellViewModel: PhotoCellViewModel) {
    if let photoCellViewModel = photoCellViewModel as? VideoCellViewModel {
      photoManager.video(
        for: photoCellViewModel.photoAsset.asset,
        size: photoSize)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak photoCellViewModel] videoDownloadEvent in
          guard let `photoCellViewModel` = photoCellViewModel else { return }
          
          switch videoDownloadEvent {
          case .progress(_,_): break
          case .complete(let playerItem, _):
            photoCellViewModel.photoAsset.playerItem = playerItem
            photoCellViewModel.playEvent.onNext(.play)
          }
        })
        .disposed(by: disposeBag)
    }
    else if let photoCellViewModel = photoCellViewModel as? LivePhotoCellViewModel {
      photoManager.livePhoto(
        for: photoCellViewModel.photoAsset.asset,
        size: photoSize)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak photoCellViewModel] livePhotoDownloadEvent in
          guard let `photoCellViewModel` = photoCellViewModel else { return }
          
          switch livePhotoDownloadEvent {
          case .progress(_, _): break
          case .complete(let livePhoto, _):
            photoCellViewModel.photoAsset.livePhoto = livePhoto
            photoCellViewModel.playEvent.onNext(.play)
          }
        })
        .disposed(by: disposeBag)
    }
  }
}
