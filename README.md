# EasyMakePhotoPicker

[![Version](https://img.shields.io/cocoapods/v/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![License](https://img.shields.io/cocoapods/l/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![Platform](https://img.shields.io/cocoapods/p/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)

If you need to create your own PhotoPicker, it is not easy to create because you need to implement many of the features (UI, business logic) needed to implement PhotoPicker. So EasyMakePhotoPicker provides an abstraction layer of PhotoPicker. EasyMakePhotoPicker implements all the business logic required for PhotoPicker so you can focus on the UI.

# Demo

EasyMakePhotoPicker makes it easy to implement things like FacebookPhotoPicker.

![alt text](https://github.com/audrl1010/EasyMakePhotoPicker/blob/master/EasyMakePhotoPicker/Assets/FacebookPhotoPicker.gif)
![alt text](https://github.com/audrl1010/EasyMakePhotoPicker/blob/master/EasyMakePhotoPicker/Assets/KakaoPhotoPicker.gif)
![alt text](https://github.com/audrl1010/EasyMakePhotoPicker/blob/master/EasyMakePhotoPicker/Assets/KakaoChatPhotoPicker.gif)

# Three components(PhotosView, PhotoCollectionsView, PhotoManager)

EasyMakePhotoPicker provides three components (PhotosView, PhotoCollectionsView, PhotoManager).

## PhotosView
`PhotosView` is a grid-like view of photos from photoLibrary.
- [x] Custom Layout
- [x] Custom Cell(Camera, Photo, LivePhoto, Video)
- [x] Like Facebook`s PhotoPicker, When you stop scrolling, it runs livePhoto, video. and When LivePhotoCell or VideCell is selected, play.
- [x] Scrolling performance optimization - Automatically cache and destroy photos.
- [x] Selected Order index.
- [x] Multiple selection.
- [x] Camera selection.
- [x] Automatically update the UI When PhotoLibrary changes(such as inserting, deleteing, updating, moving photos).

### Initializer
```swift
init(configure: PhotosViewConfigure, photoAssetCollection: PhotoAssetCollection)
init(configure: PhotosViewConfigure, collectionType: PHAssetCollectionSubtype)
```
### Inputs
```swift
// Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
var selectionDidComplete: PublishSubject<Void>
```

### Outputs
```swift
var photoDidSelected: PublishSubject<PhotoAsset>

// Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var selectedPhotosDidComplete: PublishSubject<[PhotoAsset]>

// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var selectedPhotosCount: PublishSubject<Int>

// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var photoDidDeselected: PublishSubject<PhotoAsset>

// only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true.
var cameraDidClick: PublishSubject<Void>
```

### Public Methods
```swift
func change(photoAssetCollection: PhotoAssetCollection)
```

## PhotosViewConfigure
PhotosView is configured through PhotosViewConfigure.

```swift
protocol PhotosViewConfigure {

  var fetchOptions: PHFetchOptions { get }

  var allowsMultipleSelection: Bool { get }

  var allowsCameraSelection: Bool { get }

  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] { get }

  var messageWhenMaxCountSelectedPhotosIsExceeded: String { get }

  var maxCountSelectedPhotos: Int { get }

  // get item image from PHCachingImageManager
  // based on the UICollectionViewFlowLayout`s itemSize,
  // therefore must set well itemSize in UICollectionViewFlowLayout.
  var layout: UICollectionViewFlowLayout { get }

  var photoCellTypeConverter: PhotoCellTypeConverter { get }

  var livePhotoCellTypeConverter: LivePhotoCellTypeConverter { get }

  var videoCellTypeConverter: VideoCellTypeConverter { get }

  var cameraCellTypeConverter: CameraCellTypeConverter { get }
}
```

```swift
// example
class FacebookPhotosViewConfigure: PhotosViewConfigure {
  var fetchOptions: PHFetchOptions = PHFetchOptions()

  var allowsMultipleSelection: Bool = true

  var allowsCameraSelection: Bool = true

  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] = [.video, .livePhoto]

  var messageWhenMaxCountSelectedPhotosIsExceeded: String = "over!!!"

  var maxCountSelectedPhotos: Int = 15

  var layout: UICollectionViewFlowLayout = FacebookPhotosLayout()

  var cameraCellTypeConverter = CameraCellTypeConverter(type: FacebookCameraCell.self)

  var photoCellTypeConverter = PhotoCellTypeConverter(type: FacebookPhotoCell.self)

  var livePhotoCellTypeConverter = LivePhotoCellTypeConverter(type: FacebookLivePhotoCell.self)

  var videoCellTypeConverter = VideoCellTypeConverter(type: FacebookVideoCell.self)
}
```

### Cell
PhotosViewConfigure provides Cells (PhotoCell, VideoCell, LivePhotoCell, and CameraCell) to be displayed in PhotosView.

- To provide PhotoCell, `UICollectionViewCell` must conform the `PhotoCellable` protocol.
- To provide LivePhotoCell, the `UICollectionViewCell` must conform the `LivePhotoCellable` protocol.
- To provide VideoCell, `UICollectionViewCell` must inherit `VideoCellable` protocol.
- To provide CameraCell, the `UICollectionViewCell` must conform the `CameraCellable` protocol.

> Note: one of the cells must conform `PhotoCellable`, `LivePhotoCellable`, or `VideoCellable`. This is because `PhotosView` is implemented in the `MVVM architecture` and the Protocol determines what kind of `CellViewModel` it is. If cell conform the `PhotoCellable` protocol, cell are provided with `PhotoViewModel`. if the cell conform the `LivePhotoCellable` protocol, cell are provided with `LivePhotoCellViewModel`. if the cell conform the `VideoCellable` protocol, cell are provided with `VideoCellViewModel`. Thanks to the MVVM architecture, you can easily create a UI for the desired cell using the state values of the CellViewModel.


#### Protocols
```swift

protocol PhotoCellable: class {
  var viewModel: PhotoCellViewModel? { get set }
}

protocol LivePhotoCellable: PhotoCellable { }

protocol VideoCellable: PhotoCellable { }

protocol CameraCellable: class { }
```

#### CellViewModels
```swift
class PhotosCellViewModel {
  var image: Variable<UIImage?>
  var isSelect: BehaviorSubject<Bool>
  var selectedOrder: BehaviorSubject<Int>
  ...
}
```

```swift
class LivePhotoCellViewModel: PhotoCellViewModel {
  ...
  var livePhoto: PHLivePhoto?
  var playEvent: PublishSubject<PlayEvent>
  var badgeImage: UIImage
}
```

```swift
class VideoCellViewModel: PhotoCellViewModel {
  ...
  var playerItem: AVPlayerItem?
  var duration: TimeInterval
}
```


```swift
// example
class FacebookPhotoCell: UICollectionViewCell, PhotoCellable {

// MARK: - Properties

  var selectedView = UIView()

  var orderLabel = FacebookNumberLabel()

  var imageView = UIImageView()

  var disposeBag: DisposeBag = DisposeBag()

  var viewModel: PhotoCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }
  
  // MARK: - Set up views
  ...

  func addSubviews() {
    ...
  }

  func setupConstraints() {
    ...
  }

  // MARK: - Bind

  func bind(viewModel: PhotoCellViewModel) {

    viewModel.isSelect
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self, weak viewModel] isSelect in
        guard let `self` = self,
          let `viewModel` = viewModel else { return }
          self.selectedView.isHidden = !isSelect

        if viewModel.configure.allowsMultipleSelection {
          self.orderLabel.isHidden = !isSelect
        }
        else {
          self.orderLabel.isHidden = true
        }
      })
      .disposed(by: disposeBag)

    viewModel.isSelect
      .skip(1)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] isSelect in
        guard let `self` = self else { return }
        if isSelect {
          self.cellAnimationWhenSelectedCell()
        }
        else {
          self.cellAnimationWhenDeselectedCell()
        }
      })
      .disposed(by: disposeBag)

    viewModel.selectedOrder
      .subscribe(onNext: { [weak self] selectedOrder in
        guard let `self` = self else { return }
        self.orderLabel.text = "\(selectedOrder)"
      })
      .disposed(by: disposeBag)

    viewModel.image.asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] image in
        guard let `self` = self else { return }
        self.imageView.image = image
      })
      .disposed(by: disposeBag)
  }
}
```

```swift
class FacebookVideoCell: FacebookPhotoCell, VideoCellable {

  var durationLabel: UILabel = DurationLabel()

  var playerView = PlayerView()

  fileprivate var player: AVPlayer? {
    didSet {
      if let player = player {
        playerView.playerLayer.player = player

        NotificationCenter.default.addObserver(
          forName: .AVPlayerItemDidPlayToEndTime,
          object: player.currentItem,
          queue: nil) { _ in
          DispatchQueue.main.async {
            player.seek(to: kCMTimeZero)
            player.play()
          }
        }
      }
      else {
        playerView.playerLayer.player = nil
        NotificationCenter.default.removeObserver(self)
      }
    }
  }

  var durationBackgroundView = UIView()
  var videoIconImageView = UIImageView(image: #imageLiteral(resourceName: "video"))

  var duration: TimeInterval = 0.0 {
    didSet {
      durationLabel.text = timeFormatted(timeInterval: duration)
    }
  }

  // MARK: - Life Cycle

  override func addSubviews() {
    super.addSubviews()
    ...
  }

  override func setupConstraints() {
    super.setupConstraints()
    ...
  }

  // MARK: - Bind

  override func bind(viewModel: PhotoCellViewModel) {
    super.bind(viewModel: viewModel)
    if let viewModel = viewModel as? VideoCellViewModel {
      duration = viewModel.duration

      viewModel.playEvent.asObserver()
        .subscribe(onNext: { [weak self] playEvent in
          guard let `self` = self else { return }
          switch playEvent {
            case .play: self.play()
            case .stop: self.stop()
          }
        })
        .disposed(by: disposeBag)

      viewModel.isSelect
        .subscribe(onNext: { [weak self] isSelect in
          guard let `self` = self else { return }
          if isSelect {
            self.durationBackgroundView.backgroundColor =
            Color.selectedDurationBackgroundViewBGColor
          }
          else {
            self.durationBackgroundView.backgroundColor =
            Color.deselectedDurationBackgroundViewBGColor
          }
        })
        .disposed(by: disposeBag)
    }
  }

  fileprivate func play() {
    guard let viewModel = viewModel as? VideoCellViewModel,
    let playerItem = viewModel.playerItem else { return }

    self.player = AVPlayer(playerItem: playerItem)

    if let player = player {
      playerView.isHidden = false
      player.play()
    }
  }

  fileprivate func stop() {
    if let player = player {
      player.pause();
      self.player = nil
      playerView.isHidden = true
    }
  }
}
...

```

### Layout
By providing PhotosViewConfigure's layout (UICollectionViewFlowLayout), PhotosView shows the cells with the layout provided.

```swift
  // example
  class FacebookPhotosLayout: UICollectionViewFlowLayout {

  // MARK: - Constant

  fileprivate struct Constant {
    static let padding = CGFloat(5)
    static let numberOfColumns = CGFloat(3)
  }

  override var itemSize: CGSize {
    set { }

    get {
      guard let collectionView = collectionView else { return .zero }
      let collectionViewWidth = (collectionView.bounds.width)

      let columnWidth = (collectionViewWidth -
      Constant.padding * (Constant.numberOfColumns - 1)) / Constant.numberOfColumns
      return CGSize(width: columnWidth, height: columnWidth)
    }
  }

  override init() {
    super.init()
    setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }

  func setupLayout() {
    minimumLineSpacing = Constant.padding
    minimumInteritemSpacing = Constant.padding
  }
}
```

### Usage
```swift
class FacebookPhotoPickerVC: UIViewController {
  
  ...

  var photosViewConfigure = FacebookPhotosViewConfigure()
  
  lazy var photosView: PhotosView = { [unowned] self
    let pv = PhotosView(
      configure: self.photosViewConfigure,
      collectionType: .smartAlbumUserLibrary)
    return pv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: - add view
    ...

    // MARK: - bind
    ...

    doneButton.rx.tap
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.photosView.selectionDidComplete.onNext()
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

    photosView.selectedPhotosDidComplete
      .subscribe(onNext: { [weak self] photoAssets in
        guard let `self` = self else { return }
        self.selectedPhotoAssetsDidComplete.onNext(photoAssets)
      })
      .disposed(by: disposeBag)

    photosView.outputs.cameraDidClick
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        self.showCamera()
      })
      .disposed(by: disposeBag)
    ...
  }

  ....
}
```


## PhotoCollectionsView

`PhotoCollectionsView` is a view that show a list of albums from photoLibrary.

- [x] Custom Cell(PhotoCollection)
- [x] Custom Layout
- [x] Automatically update the UI When PhotoLibrary changes.

### Initializer
```swift
init(frame: CGRect, configure: PhotoCollectionsViewConfigure)
init(configure: PhotoCollectionsViewConfigure)
```

### Inputs
```swift
// force cell selection.
var cellDidSelect: PublishSubject<IndexPath>
```

### Outputs
```swift
var selectedPhotoCollectionWhenCellDidSelect: PublishSubject<(IndexPath, PhotoAssetCollection)>
```

## PhotoCollectionsViewConfigure
PhotoCollectionsView is configured through PhotoCollectionsViewConfigure.

```swift
protocol PhotoCollectionsViewConfigure {

  var fetchOptions: PHFetchOptions { get }

  // to show collection types.
  var showsCollectionTypes: [PHAssetCollectionSubtype] { get }

  // If you create a custom PhotoCollectionCell, size of thumbnailImageView in PhotoCollectionCell and
  // photoCollectionThumbnailSize must be the same
  // because get photo collection thumbnail image from PHCachingImageManager
  // based on the 'photoCollectionThumbnailSize'
  var photoCollectionThumbnailSize: CGSize { get }

  var layout: UICollectionViewFlowLayout { get }

  var photoCollectionCellTypeConverter: PhotoCollectionCellTypeConverter { get }
}
```

```swift
// example
struct FacebookPhotoCollectionsViewConfigure: PhotoCollectionsViewConfigure {
  var fetchOptions = PHFetchOptions()

  // to show collection types.
  var showsCollectionTypes: [PHAssetCollectionSubtype] = [
    .smartAlbumUserLibrary,
    .smartAlbumGeneric,
    .smartAlbumFavorites,
    .smartAlbumRecentlyAdded,
    .smartAlbumVideos,
    .smartAlbumPanoramas,
    .smartAlbumBursts,
    .smartAlbumScreenshots
  ]

  var photoCollectionThumbnailSize = CGSize(width: 54, height: 54)

  var layout: UICollectionViewFlowLayout = FacebookPhotoCollectionsLayout()

  var photoCollectionCellTypeConverter =
    PhotoCollectionCellTypeConverter(type: FacebookPhotoCollectionCell.self)
}
```


### Cell

`PhotoCollectionsViewConfigure` provides Cell(PhotoCollectionCell) to be displayed in `PhotoCollectionsView`.

- To provide PhotoCollectionCell, `UICollectionViewCell` must inherit `PhotoCollectionCellable` protocol.


> Note: cell must conform `PhotoCollectionCellable`. This is because `PhotoCollectionsView` is implemented in the `MVVM architecture` and the Protocol determines what kind of `CellViewModel` it is. Thanks to the MVVM architecture, you can easily create a UI for the desired cell using the state values of the CellViewModel.


#### Protocol
```swift
protocol PhotoCollectionCellable {
  var viewModel: PhotoCollectionCellViewModel? { get set }
}
```

#### ViewModel
```swift
class PhotoCollectionCellViewModel {
  var count: BehaviorSubject<Int>
  var thumbnail = BehaviorSubject<UIImage?>
  var title: BehaviorSubject<String>
  var isSelect: Variable<Bool>
}
```

```swift
// example
class FacebookPhotoCollectionCell: BaseCollectionViewCell, PhotoCollectionCellable {

  var checkView: UIView = CheckImageView()
  var thumbnailImageView = UIImageView()

  var titleLabel = UILabel()

  var countLabel = UILabel()

  var lineView = UIView()

  var disposeBag = DisposeBag()

  var viewModel: PhotoCollectionCellViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bind(viewModel: viewModel)
    }
  }

  // MARK: - Life Cycle

  override func setupViews() {
    ...
  }

  override func setupConstraints() {
    ...
  }

  // MARK: - Bind
  func bind(viewModel: PhotoCollectionCellViewModel) {
      viewModel.isSelect.asObservable()
        .subscribe(onNext: { [weak self] isSelect in
          guard let`self` = self else { return }
          if isSelect {
            self.checkView.isHidden = false
          }
          else {
            self.checkView.isHidden = true
          }
        })
        .disposed(by: disposeBag)
      
      viewModel.count
        .subscribe(onNext: { [weak self] count in
          guard let `self` = self else { return }
          self.countLabel.text = "\(count)"
        })
        .disposed(by: disposeBag)

      viewModel.thumbnail
        .subscribe(onNext: { [weak self] thumbnail in
          guard let `self` = self else { return }
          self.thumbnailImageView.image = thumbnail
        })
        .disposed(by: disposeBag)

      viewModel.title
        .subscribe(onNext: { [weak self] title in
          guard let `self` = self else { return }
          self.titleLabel.text = title
        })
        .disposed(by: disposeBag)
  }
}
```

### Layout

By providing PhotoCollectionsViewConfigure's layout (UICollectionViewFlowLayout), PhotoCollectionsView shows the cells with the layout provided.

```swift
// example
class FacebookPhotoCollectionsLayout: UICollectionViewFlowLayout {
  override var itemSize: CGSize {
    set { }

    get {
      guard let collectionView = collectionView else { return .zero }
      return CGSize(width: collectionView.frame.width, height: 80)
    }
  }

  override init() {
    super.init()
    setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }

  func setupLayout() {
    minimumInteritemSpacing = 0
    minimumLineSpacing = 0
    scrollDirection = .vertical
  }
}
```

### Usage

```swift
class FacebookPhotoPickerVC: UIViewController {
  ...

  var photoCollectionsViewConfigure = FacebookPhotoCollectionsViewConfigure()
  
  lazy var photoCollectionsView: PhotoCollectionsView = { [unowned] self
    let pv = PhotoCollectionsView(
    configure: self.photoCollectionsViewConfigure)
    return pv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    // MARK: - set up views
      ...

    // MARK: - bind
      ...
    photoCollectionsView.selectedPhotoCollectionWhenCellDidSelect
      .subscribe(onNext: { [weak self] (selectedIndexPath, selectedPhotoAssetCollection) in
        guard let `self` = self else { return }
          ...
        self.photosView.change(photoAssetCollection: selectedPhotoAssetCollection)
      })
      .disposed(by: disposeBag)
  ....
}
```

# PhotoManager

`PhotoManager` is a wrapper class for PhotoCacheImageManager, it provides the functions of `PhotoCacheImageManager`(fetch photos, fetch albums, cache...etc) as Observable.

```swift
func startCaching(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)

func stopCaching(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)

func stopCachingForAllAssets()

func cancel(imageRequest requestID: PHImageRequestID)

func photoLibraryDidChange(_ changeInstance: PHChange)

func performChanges(changeBlock: @escaping () -> Void) -> Observable<PerformChangesEvent>

func fetchCollections(assetCollectionTypes: [PHAssetCollectionSubtype], thumbnailImageSize: CGSize, options: PHFetchOptions? = nil) -> Observable<[PhotoAssetCollection]>

func image(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280), options: PHImageRequestOptions? = nil) -> Observable<UIImage>

func livePhoto(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<LivePhotoDownloadEvent>

func video(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<VideoDownloadEvent>

func cloudImage(for asset: PHAsset, size: CGSize = PHImageManagerMaximumSize) -> Observable<CloudPhotoDownLoadEvent>

func fullResolutionImage(for asset: PHAsset) -> Observable<UIImage>

func checkPhotoLibraryPermission() -> Observable<Bool>

func checkCameraPermission() -> Observable<Bool>
```

## Requirements
iOS 9.1

## Installation

EasyMakePhotoPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '9.1'
pod "EasyMakePhotoPicker"
```

## Author

Myung gi son, audrl1010@naver.com

## License

EasyMakePhotoPicker is available under the MIT license. See the LICENSE file for more info.
