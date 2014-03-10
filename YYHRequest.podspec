Pod::Spec.new do |s|
  s.name         = 'YYHRequest'
  s.version      = '0.0.1'
  s.license      = 'MIT'
  s.summary      = 'Simple and lightweight class for loading asynchronous HTTP requests.'
  s.homepage     = 'https://github.com/angelodipaolo/YYHRequest'
  s.author       = { 'Angelo Di Paolo' => 'angelod101@gmail.com' }
  s.social_media_url = 'http://twitter.com/angelodipaolo'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.source       = { :git => 'https://github.com/angelodipaolo/YYHRequest.git', :tag => '0.0.1' }
  s.source_files =  'YYHRequest/Classes/**/*.{h,m}'
end
