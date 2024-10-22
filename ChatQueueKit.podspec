Pod::Spec.new do |s|
  s.name             = 'ChatQueueKit'
  s.version          = '0.0.1'
  s.summary          = 'A chat framework that manages table data with an efficient queue system.'

  s.description      = <<-DESC
  ChatQueueKit is a lightweight framework designed for chat applications that require efficient handling of table data. It utilizes a queue system to optimize the management of frequently updated data, ensuring smooth and responsive table views even under heavy loads. The framework is ideal for real-time chat scenarios where performance and ease of use are critical.
  DESC

  s.homepage         = 'https://github.com/aragig/ChatQueueKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Toshihiko Arai' => 'i.officearai@gmail.com' }
  s.source           = { :git => 'https://github.com/aragig/ChatQueueKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'ChatQueueKit/*.swift', 'ChatQueueKit/*.h'
  s.swift_version = '5.0'
end
