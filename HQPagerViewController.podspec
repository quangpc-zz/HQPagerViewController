Pod::Spec.new do |s|
  s.name             = "HQPagerViewController"
  s.version          = "1.0"
  s.summary          = "Pager ViewController for iOS 9 and above with beautiful menu view"
  s.homepage         = "https://github.com/quangpc/HQPagerViewController"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = "quangpc"
  s.source           = { git: "https://github.com/quangpc/HQPagerViewController.git", tag: s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.ios.source_files = 'HQPagerViewController/Sources/**/*'
  s.ios.frameworks = 'UIKit', 'Foundation'
end