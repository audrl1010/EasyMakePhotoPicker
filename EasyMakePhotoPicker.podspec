#
# Be sure to run `pod lib lint EasyMakePhotoPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyMakePhotoPicker'
  s.version          = '0.1.2'
  s.summary          = 'EasyPhotoPicker makes it easy to create your own PhotoPicker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
If you need to create your own PhotoPicker, it is not easy to create because you need to implement many of the features (UI, business logic) needed to implement PhotoPicker. So EasyMakePhotoPicker provides an abstraction layer of PhotoPicker. EasyMakePhotoPicker implements all the business logic required for PhotoPicker so you can focus on the UI.
    DESC

  s.homepage         = 'https://github.com/audrl1010/EasyMakePhotoPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Myung gi son' => 'audrl1010@naver.com' }
  s.source           = { :git => 'https://github.com/audrl1010/EasyMakePhotoPicker.git', :tag => s.version.to_s }

  s.platform = :ios, '9.1'
  s.ios.deployment_target = '9.1'

  s.source_files = 'EasyMakePhotoPicker/Classes/**/*'
  
  # s.resource_bundles = {
  #  'EasyMakePhotoPicker' => ['EasyMakePhotoPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Photos', 'PhotosUI'
  s.dependency 'RxSwift', '>= 4.0'
  s.dependency 'RxCocoa', '>= 4.0'
end
