#import "ChineseCharacterRecognitionPlugin.h"
#if __has_include(<chinese_character_recognition/chinese_character_recognition-Swift.h>)
#import <chinese_character_recognition/chinese_character_recognition-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "chinese_character_recognition-Swift.h"
#endif

#import "bindings.h"

@implementation ChineseCharacterRecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChineseCharacterRecognitionPlugin registerWithRegistrar:registrar];
}

+ (void)dummy {
	lookupFFI(NULL, 0, NULL, 0);
}

@end
