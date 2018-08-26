Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonLanguageTranslatorV3'
  s.version               = '0.33.0'
  s.summary               = 'Client framework for the IBM Watson Language Translator service'
  s.description           = <<-DESC
Translate text from one language to another. Take news from across the globe and present it in your language, 
communicate with your customers in their own language, and more.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/language-translator/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'LanguageTranslator'
  s.ios.deployment_target = '8.0'

  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version.to_s}" }
  s.source_files          = 'Source/LanguageTranslatorV3/**/*.swift'

  s.dependency              'IBMWatsonRestKit', s.version.to_s

end
