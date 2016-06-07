Pod::Spec.new do |s|
  s.name         = "xcode-ftp-autouploader"
  s.version      = "0.0.4"
  s.summary      = "Script for uploading the latest archive to the given FTP server"
  s.description  = "Nice script to perform automatical upload to the FTP"
  s.homepage     = "https://github.com/sander-kornev/xcode-ftp-autouploader"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Vladimir Rebrov" => "vladimir.rebrov@techs.com.ua" }
  s.source       = { :git => "https://github.com/sander-kornev/xcode-ftp-autouploader.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = '*.{sh}'
  s.requires_arc = true
end
