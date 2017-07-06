//
//  PhotosView.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import RxSwift


public protocol PhotosViewInput {
  var inputs: PhotosViewInput { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectionDidComplete: PublishSubject<Void> { get }
}

public protocol PhotosViewOutput {
  var outputs: PhotosViewOutput { get }

  var photoDidSelected: PublishSubject<PhotoAsset> { get }
  
  // only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true
  var cameraDidClick: PublishSubject<Void> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectedPhotosDidComplete: PublishSubject<[PhotoAsset]> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var selectedPhotosCount: PublishSubject<Int> { get }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  var photoDidDeselected: PublishSubject<PhotoAsset> { get }
}

public class PhotosView: BaseView,
  PhotosViewInput,
  PhotosViewOutput {
  
  public var inputs: PhotosViewInput { return self }
  public var outputs: PhotosViewOutput { return self }
  
  // MARK: - Input
  
  // Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
  public var selectionDidComplete: PublishSubject<Void> {
    return viewModel.inputs.selectionDidComplete
  }
  
  // MARK: - Output
  
  public var photoDidSelected: PublishSubject<PhotoAsset> {
    return viewModel.outputs.photoAssetDidSelected
  }
  
  // Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  public var selectedPhotosDidComplete: PublishSubject<[PhotoAsset]> {
    return viewModel.outputs.selectedPhotoAssetsDidComplete
  }
  
  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  public var selectedPhotosCount: PublishSubject<Int> {
    return viewModel.outputs.selectedPhotosCount
  }

  // only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true
  public var photoDidDeselected: PublishSubject<PhotoAsset> {
    return viewModel.outputs.photoAssetDidDeselected
  }
  
  // only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true
  public var cameraDidClick: PublishSubject<Void> {
    return viewModel.outputs.cameraDidClick
  }
  
  // MARK: - Properties
  
  fileprivate var configure: PhotosViewConfigure
  
  fileprivate var viewModel: PhotosViewModelType
  
  fileprivate var disposeBag = DisposeBag()
  
  fileprivate var previousPreheatRect = CGRect.zero
  
  fileprivate var hasInitialized: Bool = false
  
  public lazy var collectionView: UICollectionView = { [unowned self] in
    let cv = UICollectionView(
      frame: .zero,
      collectionViewLayout: self.configure.layout)
    cv.backgroundColor = .white
    cv.dataSource = self
    cv.delegate = self
    
    cv.register(
      self.configure.photoCellTypeConverter.cellClass,
      forCellWithReuseIdentifier: self.configure.photoCellTypeConverter.cellIdentifier)
    
    cv.register(
      self.configure.cameraCellTypeConverter.cellClass,
      forCellWithReuseIdentifier: self.configure.cameraCellTypeConverter.cellIdentifier)
    
    cv.register(
      self.configure.livePhotoCellTypeConverter.cellClass,
      forCellWithReuseIdentifier: self.configure.livePhotoCellTypeConverter.cellIdentifier)
    
    cv.register(
      self.configure.videoCellTypeConverter.cellClass,
      forCellWithReuseIdentifier: self.configure.videoCellTypeConverter.cellIdentifier)
    
    return cv
  }()

  // MARK: - initializers

  public init(
    configure: PhotosViewConfigure,
    photoAssetCollection: PhotoAssetCollection) {
    self.configure = configure
    viewModel = PhotosViewModel(
      configure: configure,
      photoAssetCollection: photoAssetCollection)
    super.init(frame: .zero)
    commonInit()
  }
  
  public init(
    configure: PhotosViewConfigure,
    collectionType: PHAssetCollectionSubtype) {
    self.configure = configure
    viewModel = PhotosViewModel(
      configure: configure,
      collectionType: collectionType)
    super.init(frame: .zero)
    commonInit()
  }
  
  fileprivate func commonInit() {
    bindViewModel()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  public func change(photoAssetCollection: PhotoAssetCollection) {
    viewModel.inputs.currentPhotoAssetCollectionDidChange
      .onNext(photoAssetCollection)
  }
  
  // MARK: - Life Cycle
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    if !hasInitialized {
      hasInitialized = true
      let scale = UIScreen.main.scale
      viewModel.inputs.photoSizeDidInput.onNext(
        CGSize(width: self.configure.layout.itemSize.width * scale,
               height: self.configure.layout.itemSize.height * scale))
      viewModel.inputs.viewDidLoad.onNext(())
      
      updateCachedRect()
    }
  }
  
  override public func setupViews() {
    addSubview(collectionView)
  }
  
  override public func setupConstraints() {
    collectionView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_endSetup()
  }
  
  // MARK: - Bind viewModel
  
  fileprivate func bindViewModel() {
    viewModel.outputs.maxCountSelectedPhotosIsExceeded
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        UIAlertController.show(title: "", message: self.configure.messageWhenMaxCountSelectedPhotosIsExceeded)
      })
      .disposed(by: disposeBag)
    
    viewModel.outputs.cellDidChange
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] changeEvent in
        guard let `self` = self else { return }
        switch changeEvent {
        case .begin:
          self.collectionView.beginUpdates()
        case .end:
          self.collectionView.endUpdates()
        case .reset:
          self.collectionView.reloadData()
        case .insert(let indexPaths):
          self.collectionView.insert(itemsAt: indexPaths)
        case .update(let indexPaths):
          self.collectionView.reload(
            itemsAt: self.collectionView.indexPathsForVisibleItems
              .filter { indexPaths.contains($0) })
        case .delete(let indexPaths):
          self.collectionView.delete(itemsAt: indexPaths)
        case .move(let from, let to):
          self.collectionView.moveItem(at: from, to: to)
        case .scrollTo(let indexPath):
          self.collectionView.scrollToItem(
            at: indexPath,
            at: .top,
            animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - UICollectionViewDataSource
extension PhotosView: UICollectionViewDataSource {
  public func numberOfSections(
    in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSection()
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cellViewModel = viewModel.cellViewModel(at: indexPath)
    
    let cell: UICollectionViewCell
    
    if cellViewModel is VideoCellViewModel {
      let videoCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: configure.videoCellTypeConverter.cellIdentifier,
        for: indexPath) as! VideoCellable
      videoCell.viewModel = cellViewModel
      cell = videoCell as! UICollectionViewCell
    }
    else if cellViewModel is LivePhotoCellViewModel {
      let livePhotoCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: configure.livePhotoCellTypeConverter.cellIdentifier,
        for: indexPath) as! LivePhotoCellable
      livePhotoCell.viewModel = cellViewModel
      cell = livePhotoCell as! UICollectionViewCell
    }
    else if cellViewModel is CameraCellViewModel {
      cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: configure.cameraCellTypeConverter.cellIdentifier,
        for: indexPath)
    }
    else {
      let photoCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: configure.photoCellTypeConverter.cellIdentifier,
        for: indexPath) as! PhotoCellable
      photoCell.viewModel = cellViewModel
      cell = photoCell as! UICollectionViewCell
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension PhotosView: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
    viewModel.inputs.cellDidSelect.onNext(indexPath)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath) {
    viewModel.inputs.displayingCellDidEnd.onNext(indexPath)
  }
}

// MARK: - UIScrollViewDelegate
extension PhotosView {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateCachedRect()
  }
  
  public func scrollViewDidEndDragging(
    _ scrollView: UIScrollView,
    willDecelerate decelerate: Bool) {
    if !decelerate {
      viewModel.inputs.scrollingDidStop.onNext(
        collectionView.indexPathsForVisibleItems)
    }
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    viewModel.inputs.scrollingDidStop.onNext(
      collectionView.indexPathsForVisibleItems)
  }
}

// MARK: - Cache Rect
extension PhotosView {
  
  fileprivate func updateCachedRect() {
    let visibleRect = CGRect(
      origin: collectionView.contentOffset,
      size: collectionView.bounds.size)
    
    var preheatRect: CGRect
    var delta: CGFloat
    
    if configure.layout.scrollDirection == .horizontal {
      preheatRect = visibleRect.insetBy(
        dx: -0.5 * visibleRect.width,
        dy: 0)
      delta = abs(preheatRect.midX - previousPreheatRect.midX)
      guard delta > bounds.width / 3 else { return }
    }
    else {
      preheatRect = visibleRect.insetBy(
        dx: 0,
        dy: -0.5 * visibleRect.height)
      delta = abs(preheatRect.midY - previousPreheatRect.midY)
      guard delta > bounds.height / 3 else { return }
    }
    
    let (addedRects, removedRects) =
      differencesBetweenRects(previousPreheatRect, preheatRect)
    
    viewModel.inputs.cachedRectDidUpdate.onNext(
      (addedRects.flatMap { [unowned self] rect in
        self.collectionView.indexPathsForElements(in: rect)
        },
       removedRects.flatMap { [unowned self] rect in
        self.collectionView.indexPathsForElements(in: rect)
      }))
    
    previousPreheatRect = preheatRect
  }
  
  fileprivate func differencesBetweenRects(
    _ old: CGRect,
    _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
    if old.intersects(new) {
      var added = [CGRect]()
      if new.maxY > old.maxY {
        added += [CGRect(x: new.origin.x, y: old.maxY,
                         width: new.width, height: new.maxY - old.maxY)]
      }
      if old.minY > new.minY {
        added += [CGRect(x: new.origin.x, y: new.minY,
                         width: new.width, height: old.minY - new.minY)]
      }
      var removed = [CGRect]()
      if new.maxY < old.maxY {
        removed += [CGRect(x: new.origin.x, y: new.maxY,
                           width: new.width, height: old.maxY - new.maxY)]
      }
      if old.minY < new.minY {
        removed += [CGRect(x: new.origin.x, y: old.minY,
                           width: new.width, height: new.minY - old.minY)]
      }
      return (added, removed)
    }
    else {
      return ([new], [old])
    }
  }
}





















