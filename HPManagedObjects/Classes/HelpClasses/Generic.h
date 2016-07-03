//
//  Generic.h
//  Little Reader
//
//  Created by MAC Mini on 30.08.11.
//  Copyright 2011 Brillkids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, EGenericDeviceType){
	EGenericDeviceType_All = 0,
	EGenericDeviceType_iPhone = 1,
	EGenericDeviceType_iPhoneRetina = 2,
	EGenericDeviceType_iPad = 4,
	EGenericDeviceType_iPadRetina = 8,
};


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

typedef enum {
    BOOLExtNO = 0,
    BOOLExtYES = 1,
    BOOLExtNotDefined = -1,
} BOOLExt;

@interface GenericHelper : NSObject

+ (BOOL)isRetina;
+ (BOOL)is5Ich;
+ (NSString*)uniqueIdentifier;
+ (NSString*)uniqueIdentifierForMessage;
+ (EGenericDeviceType)deviceType;

@end
