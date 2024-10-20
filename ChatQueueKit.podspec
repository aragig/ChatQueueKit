Pod::Spec.new do |s|
  s.name             = 'ChatQueueKit'
  s.version          = '0.0.1'
  s.summary          = 'Table data with queue system for chat framework.'

  s.description      = <<-DESC
  Table data with queue system for chat framework.
  DESC

  s.homepage         = 'https://github.com/aragig/ChatQueueKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Toshihiko Arai' => 'i.officearai@gmail.com' }
  s.source           = { :git => 'https://github.com/aragig/ChatQueueKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  # ソースファイルのパスを修正
  s.source_files = 'ChatQueueKit/*.swift', 'ChatQueueKit/*.h'

  s.swift_version = '5.0'
end
