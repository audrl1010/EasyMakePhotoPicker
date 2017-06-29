//
//  PhotoCollectionsView.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//
import UIKit
import Photos
import PhotosUI
import RxSwift

public protocol PhotoCollectionsViewOutput {
  public var output: PhotoCollectionsViewOutput { get }
  
  public var selectedPhotoCollectionWhenCellDidSelect:
    PublishSubject<(IndexPath, PhotoAssetCollection)> { get }
  
  // force cell selection
  public var cellDidSelect: PublishSubject<IndexPath> { get }
}

public class PhotoCollectionsView:
  BaseView,
  PhotoCollectionsViewOutput {
  
  // MARK: - Properties
  public var output: PhotoCollectionsViewOutput { return self }
  
  public var selectedPhotoCollectionWhenCellDidSelect:
    PublishSubject<(IndexPath, PhotoAssetCollection)> {
    return viewModel.outputs.photoCollectionDidSelectWhenCellDidSelect
  }
  
  public var cellDidSelect: PublishSubject<IndexPath> {
    return viewModel.inputs.cellDidSelect
  }
  
  fileprivate var disposeBag = DisposeBag()
  
  fileprivate var viewModel: PhotoCollectionsViewModelType
  
  fileprivate var configure: PhotoCollectionsViewConfigure
  
  public lazy var collectionView: UICollectionView = { [unowned self] in
    let cv = UICollectionView(
      frame: .zero,
      collectionViewLayout: self.configure.layout)
    
    cv.register(self.configure.photoCollectionCellClass,
      forCellWithReuseIdentifier: self.configure.photoCollectionCellClass.cellIdentifier)
    
    cv.backgroundColor = .white
    cv.dataSource = self
    cv.delegate = self
    return cv
  }()
  
  
  public init(frame: CGRect, configure: PhotoCollectionsViewConfigure) {
    self.configure = configure
    viewModel = PhotoCollectionsViewModel(configure: configure)
    super.init(frame: .zero)
    bindViewModel()
  }
  
  public init(configure: PhotoCollectionsViewConfigure) {
    self.configure = configure
    viewModel = PhotoCollectionsViewModel(configure: configure)
    super.init(frame: .zero)
    bindViewModel()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func setupViews() {
    addSubview(collectionView)
  }
  
  override public func setupConstraints() {
    collectionView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
  }
  
  fileprivate func bindViewModel() {
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

extension PhotoCollectionsView: UICollectionViewDataSource {
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
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: self.configure.photoCollectionCellClass.cellIdentifier,
      for: indexPath) as! PhotoCollectionCell
    cell.viewModel = viewModel.cellViewModel(at: indexPath)
    return cell
  }
}

extension PhotoCollectionsView: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.inputs.cellDidSelect.onNext(indexPath)
  }
}




