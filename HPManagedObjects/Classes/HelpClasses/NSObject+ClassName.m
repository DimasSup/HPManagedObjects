//
//  NSObject+ClassName.m
//  Little Pal
//
//  Created by admin on 07.09.15.
//  Copyright (c) 2015 BrillKids. All rights reserved.
//

#import "NSObject+ClassName.h"
@implementation NSObject (ClassName)
+(NSString *)className
{
	return NSStringFromClass([self class]);
}

@end
