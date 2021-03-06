//
//  NSObject+CallInstanceMethod.m
//  Pods
//
//  Created by admin on 26.07.16.
//
//

#import "NSObject+CallInstanceMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (CallInstanceMethod)

+(void)callInstanceMethod:(SEL)selector inInstance:(NSObject*)instance
{
	struct objc_super b = {
		.receiver = instance,
		.super_class = [self class],
	};
	((void (*)(struct objc_super *, SEL)) objc_msgSendSuper)(&b,selector);
}
@end
