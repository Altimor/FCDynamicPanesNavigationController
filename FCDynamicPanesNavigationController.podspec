Pod::Spec.new do |s|
  s.name     = 'FCDynamicPanesNavigationController'
  s.version  = '1.0'
  s.license  = 'GPL-3'
  s.summary  = ''
  s.homepage = 'https://github.com/Altimor/FCDynamicPanesNavigationController'
  s.author   = { 'Florent Crivello' => 'florent@indri.fr' }

  s.source   = { :git => 'https://github.com/Altimor/FCDynamicPanesNavigationController.git', :tag => '1.0' }

  s.description = ''

  s.platform = :ios, '7.0'

  s.ios.source_files = 'FCDynamicPanesNavigationController/*.{h,m}'
  spec.dependency 'FCMutableArray'
  s.requires_arc = true
end
