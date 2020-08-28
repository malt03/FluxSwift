Pod::Spec.new do |s|
    s.name             = 'FluxSwift'
    s.version          = '0.2.1'
    s.summary          = 'Flux on Swift'
    
    s.description      = <<-DESC
    FluxSwift is a completly typesafe Flux implementation using RxSwift.
    DESC
    
    s.homepage         = 'https://github.com/malt03/FluxSwift'
    s.license          = { type: 'MIT', file: 'LICENSE' }
    s.author           = { 'malt03' => 'malt.koji@gmail.com' }
    s.source           = { git: 'https://github.com/malt03/FluxSwift.git', :tag => s.version.to_s }

    s.swift_version = '5.1.3'

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.10'
    s.tvos.deployment_target = '10.0'
    s.watchos.deployment_target = '4.0'

    s.dependency 'RxSwift', '~> 5.0.1'
    s.dependency 'RxRelay', '~> 5.0.1'

    s.source_files = 'Sources/**/*.swift'
end
