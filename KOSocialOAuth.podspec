#
# Be sure to run `pod lib lint KOSocialOAuth.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KOSocialOAuth"
  s.version          = "0.1.0"
  s.summary          = "OAuth to Vk, Instagram and LinkedIn"
  s.description      = "KOSocialOAuth provides you simple way to connect to vk, instagram and linkedIn"
  s.homepage         = "https://github.com/kohtenko/KOSocialOAuth"
  s.license          = 'MIT'
  s.author           = { "okohtenko" => "kohtenko@gmail.com" }
  s.source           = { :git => "https://github.com/kohtenko/KOSocialOAuth.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
end
