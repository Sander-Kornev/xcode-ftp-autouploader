Pod::Spec.new do |s|
  s.name         = "xcode-ftp-autouploader"
  s.version      = "0.0.1-alpha"
  s.summary      = ""
  s.description  = ""
  s.homepage     = "https://github.com/vlrebrov/xcode-ftp-autouploader"
  s.license      = ''
  s.author       = { "Vladimir Rebrov" => "vladimir.rebrov@techs.com.ua" }
  s.source       = { :git => "https://github.com/vlrebrov/xcode-ftp-autouploader.git", :tag => "0.0.1-alpha" }

  s.source_files = '*.sh'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
end