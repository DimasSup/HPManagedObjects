//
//  Generic.m
//  Little Reader
//
//  Created by MAC Mini on 30.08.11.
//  Copyright 2011 Brillkids. All rights reserved.
//
#import "Generic.h"
#import "Macroses.h"
static BOOLExt GenericHelper_isRetina = BOOLExtNotDefined;



@implementation GenericHelper
+(u_int32_t)randomSeed
{
	static u_int32_t randomSeed = 0;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		randomSeed = arc4random_uniform(10000);
	});
	return ++randomSeed;
}

+(NSString*)randomStringSeed
{
	return NSStringFormat(@"%i-",[self randomSeed]);
}
+(NSString*)randomString
{
	return NSStringFormat(@"%i-",arc4random_uniform(10000));
}

+(BOOL)isRetina {
	if (GenericHelper_isRetina == BOOLExtNotDefined) {
		GenericHelper_isRetina = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 ? BOOLExtYES : BOOLExtNO;
	}
	return	GenericHelper_isRetina;
}

+(BOOL)is5Ich {
	return [UIScreen mainScreen].bounds.size.height == 568.0;
}

+(NSString *)uniqueIdentifier {
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge NSString *)string;
}

+(NSString*)uniqueIdentifierForMessage
{
	@synchronized (self)
	{
		NSString* value = [[[[@"1-" stringByAppendingString:[self randomStringSeed]] stringByAppendingString:[self randomString]]  stringByAppendingString:[self uniqueIdentifier]] lowercaseString];
		return value;
	}
}

+ (EGenericDeviceType)deviceType {
	BOOL isRetina = [self isRetina];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return isRetina ? EGenericDeviceType_iPhoneRetina : EGenericDeviceType_iPhone;
	}
	else {
		return isRetina ? EGenericDeviceType_iPadRetina : EGenericDeviceType_iPad;
	}
}
@end