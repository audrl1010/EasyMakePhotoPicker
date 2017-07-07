# EasyMakePhotoPicker

[![CI Status](http://img.shields.io/travis/audrl1010/EasyMakePhotoPicker.svg?style=flat)](https://travis-ci.org/audrl1010/EasyMakePhotoPicker)
[![Version](https://img.shields.io/cocoapods/v/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![License](https://img.shields.io/cocoapods/l/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![Platform](https://img.shields.io/cocoapods/p/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)

EasyMakePhotoPicker는 PhotoPicker의 추상 레이어 이다.


이미지를 선택할 수 있는 기능이 필요한 앱들은 앱의 특성에 맞게 PhotoPicker를 만들어 사용합니다. 그러나, PhotoPicker를 구현하기 위해 상당한 많은 기능(UI, 비즈니스 로직)을 본인이 구현해야 합니다. EasyMakePhotoPicker는 PhotoPicker에 필요한 모든 비즈니스 로직을 구현하여 제공하므로써, 여러분이 UI에만 집중할 수 있도록 도와줍니다.


![alt text](https://github.com/audrl1010/EasyMakePhotoPicker/blob/master/EasyMakePhotoPicker/Assets/FacebookPhotoPicker.gif)

![alt text](https://github.com/audrl1010/EasyMakePhotoPicker/blob/master/EasyMakePhotoPicker/Assets/KaKaoChatPhotoPicker.gif)


# Providing three components(PhotosView, PhotoCollectionsView, PhotoManager)

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
PhotosView는 PhotosViewConfigure를 통해 구성되어집니다.

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

### Cell 제공
PhotosViewConfigure에 여러분이 보여주고 싶은 Cell(PhotoCell, VideoCell, LivePhotoCell, CameraCell)을 제공하여, PhotosView가 여러분이 보여주고 싶은 Cell을 보여줍니다.

PhotoCell을 제공하기 위해서는 PhotoCellable protocol을 상속받아야 합니다.
LivePhotoCell을 제공하기 위해서는 LivePhotoCellable protocol을 상속받아야 합니다.
VideoCell을 제공하기 위해서는 VideoCellable protocol을 상속받아야 합니다.
CameraCell을 제공하기 위해서는 CameraCellable protocol을 상속받아야 합니다.

Cell을 제공하기 위해, Cell에 따라 PhotoCellable, LivePhotoCellable, VideoCellable중 하나를 상속받아야 합니다. 이유는 PhotosView는 MVVM 아키텍처로 구현되어 있기 때문에 Protocol에 따라 CellViewModel의 종류가 결정되기 때문입니다. PhotoCellable을 준수하는 Cell일 경우 PhotosCellViewModel, LivePhotoCellable을 준수하는 Cell일 경우 LivePhotoCellViewModel, VideoCellable을 준수하는 경우 VideoCellViewModel을 받습니다. MVVM의 아키텍처 덕분에 여러분은 손쉽게 ViewModel의 상태값들을 가지고 원하는 Cell의 UI를 만들 수 있습니다.

### Protocols
```swift
protocol CameraCellable: class { }

protocol PhotoCellable: class {
  var viewModel: PhotoCellViewModel? { get set }
}

protocol LivePhotoCellable: PhotoCellable { }

protocol VideoCellable: PhotoCellable { }
```

### ViewModels
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
    addSubview(imageView)
    addSubview(selectedView)
    addSubview(orderLabel)
  }

  func setupConstraints() {
    imageView
    .fs_leftAnchor(equalTo: leftAnchor)
    .fs_topAnchor(equalTo: topAnchor)
    .fs_rightAnchor(equalTo: rightAnchor)
    .fs_bottomAnchor(equalTo: bottomAnchor)
    .fs_endSetup()

    selectedView
    .fs_leftAnchor(equalTo: leftAnchor)
    .fs_topAnchor(equalTo: topAnchor)
    .fs_rightAnchor(equalTo: rightAnchor)
    .fs_bottomAnchor(equalTo: bottomAnchor)
    .fs_endSetup()

    orderLabel
      .fs_widthAnchor(
        equalToConstant: Metric.orderLabelWidth)
      .fs_heightAnchor(
        equalToConstant: Metric.orderLabelHeight)
      .fs_rightAnchor(
        equalTo: rightAnchor)
      .fs_topAnchor(
        equalTo: topAnchor)
      .fs_endSetup()
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

  override func prepareForReuse() {
    super.prepareForReuse()
    player = nil
    playerView.isHidden = true
  }

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

## Layout 제공
PhotosViewConfigure의 layout(UICollectionViewFlowLayout)을 제공으로, PhotosView는 제공되는 layout을 가지고 cell들을 보여줍니다.

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

## Usage
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


# PhotoCollectionsView

`PhotoCollectionsView` is a view that show a list of albums taken form photoLibrary.

- [x] Custom Cell(PhotoCollection)
- [x] Custom Layout
- [x] Automatically update the UI When PhotoLibrary changes.

## Initializer
```swift
init(frame: CGRect, configure: PhotoCollectionsViewConfigure)
init(configure: PhotoCollectionsViewConfigure)
```

## Inputs
```swift
// force cell selection.
var cellDidSelect: PublishSubject<IndexPath>
```

## Outputs
```swift
var selectedPhotoCollectionWhenCellDidSelect: PublishSubject<(IndexPath, PhotoAssetCollection)>
```

## PhotoCollectionsViewConfigure
PhotoCollectionsView는 PhotoCollectionsViewConfigure를 통해 구성되어집니다.

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

## Layout 제공
PhotoCollectionsViewConfigure의 layout(UICollectionViewFlowLayout)을 제공으로, PhotoCollectionsView는 제공되는 layout을 가지고 cell들을 보여줍니다.

```swift
// example
```

##Usage
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
  
    // MARK: - add view
      ...
    photoCollectionsView
      .fs_topAnchor(
        equalTo: topLayoutGuide.bottomAnchor,
        constant: 10)
      .fs_widthAnchor(equalToConstant: view.frame.width)
      .fs_heightAnchor(equalToConstant: view.frame.height * 0.45)
    .fs_endSetup()
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
pod "EasyMakePhotoPicker"
```

## Author

Myung gi son, audrl1010@naver.com

## License

EasyMakePhotoPicker is available under the MIT license. See the LICENSE file for more info.
