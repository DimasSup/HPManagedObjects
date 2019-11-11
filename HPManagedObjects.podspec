#
# Be sure to run `pod lib lint HPManagedObjects.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HPManagedObjects'
  s.version          = '1.2.3'
  s.summary          = 'Lib with BaseManagedObjectModel that allow parse json and database'
  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
					 Hi there! Some time ago (maybe 3 years) I wrote this library for our company for make our life little easier with serialize/deserialize server response/request to/from JSON with obj-c models. we improving it all that time. and now I glad share it with obj-c community. https://github.com/DimasSup/HPManagedObjects About it - easy mapping swift/obj-c class, like EasyMapping, but more faster. In synthetic tests: on simulator 1150000 objects (with inheritance, objects in objects) EasyMapping: Serialize 3.5 seconds HPManagedObjects: Serialize 2.5 seconds EasyMapping: Deserialize 6.6 seconds HPManagedObjects: Deserialize 2.7 seconds Why we have more performance? We used cache for mapping models, also we caching some runtime info for property types. I will be happy hear your thinks about this lib and suggestion if you have one
                       DESC

  s.homepage         = 'https://github.com/DimasSup/HPManagedObjects'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GPL-3.0', :file => 'LICENSE' }
  s.author           = { 'DimasSup' => 'dima.teleban@gmail.com' }
  s.source           = { :git => 'https://github.com/DimasSup/HPManagedObjects.git', :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # s.resource_bundles = {
  #   'HPManagedObjects' => ['HPManagedObjects/Assets/*.png']
  # }

  s.subspec 'Main' do |main|
   main.source_files   = 'HPManagedObjects/Classes/{Main,HelpClasses}/**/*'
   main.public_header_files = 'HPManagedObjects/Classes/{Main,HelpClasses}/**/*.h'
  end

  s.subspec 'FMDB' do |fmdb|
   fmdb.source_files   = 'HPManagedObjects/Classes/FMDBSupport/**/*'

   fmdb.public_header_files = 'HPManagedObjects/Classes/FMDBSupport/**/*.h'
   fmdb.dependency 'HPManagedObjects/Main'
   fmdb.dependency 'FMDB'
  end


end
