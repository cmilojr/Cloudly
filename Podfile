# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
install! 'cocoapods', :deterministic_uuids => false
target 'cloudly' do
  # Comment the next line if you don't want to use dynamic frameworks
  
  use_frameworks!

  #Amplify
  pod 'Amplify'
  pod 'AmplifyPlugins/AWSCognitoAuthPlugin'
  pod 'AmplifyPlugins/AWSAPIPlugin'
  
  #Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  
  #CheckBox
  pod 'BEMCheckBox'
  
  #SideMenu
  pod 'SideMenu'
  
  target 'cloudlyTests' do
    pod 'Firebase'
  end
end
