#
# Be sure to run `pod lib lint UNDanielBasicTool_Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UNDanielBasicTool_Swift'
  s.version          = '0.1.6'
  s.summary          = 'UNDanielBasicTool is a useful Tool contains a lot of functions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    This is a Basic Tool I used for different Swift App Developing.
                       DESC

  s.homepage         = 'https://github.com/TIEmerald/UNDanielBasicTool_Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'niyejunze.j@gmail.com' => 'niyejunze.j@gmail.com' }
  s.source           = { :git => 'https://github.com/TIEmerald/UNDanielBasicTool_Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'UNDanielBasicTool_Swift/Classes/**/*'

  # s.resource_bundles = {
  #   'UNDanielBasicTool_Swift' => ['UNDanielBasicTool_Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
end
