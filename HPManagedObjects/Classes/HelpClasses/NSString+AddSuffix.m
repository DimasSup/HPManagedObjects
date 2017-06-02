//
//  NSString+AddSuffix.m
//  Little Pal
//
//  Created by admin on 24.03.17.
//  Copyright © 2017 BrillKids. All rights reserved.
//

#import "NSString+AddSuffix.h"

@implementation NSString (AddSuffix)
-(NSString *)stringByAddingSuffix:(NSString *)suffix{
	return [[[self stringByDeletingPathExtension] stringByAppendingString:suffix?:@""] stringByAppendingPathExtension:[self pathExtension]];
}
@end
