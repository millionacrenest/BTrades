# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'buildingTrades' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for buildingTrades
  pod 'Firebase/Messaging'
  pod 'FirebaseInstanceID'
  pod 'SwiftyJSON'
  pod 'JSONHelper'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'PDFReader', '~> 2.4.0'
  pod 'SDWebImage', '~> 4.0'
  pod 'TTTAttributedLabel'
  pod 'Firebase/Storage'
  pod 'YouTubePlayer'  
  pod 'PhotoEditorSDK'
  pod 'iOSPhotoEditor'
  pod 'Alamofire'

  target 'buildingTradesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'buildingTradesUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-buildingTrades/Pods-buildingTrades-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
end
