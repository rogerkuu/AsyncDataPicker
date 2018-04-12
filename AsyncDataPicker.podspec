Pod::Spec.new do |s|
s.name = 'AsyncDataPicker'
s.version = '0.1.3'
s.license = 'MIT'
s.summary = 'A customizable picker view.'
s.homepage = 'https://github.com/rogerkuu/AsyncDataPicker'
s.authors = { 'Mianji GU' => 'roger.kuu@gmail.com' }
s.source = { :git => "https://github.com/rogerkuu/AsyncDataPicker.git", :tag => "0.1.3"}
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.swift_version = '4.0'
s.source_files = 'AsyncDataPicker/AsyncDataPicker/*.{swift,h}'
s.resource_bundles = { "AsyncDataPickerPod" => "AsyncDataPicker/AsyncDataPicker/*.{xib}" }
end