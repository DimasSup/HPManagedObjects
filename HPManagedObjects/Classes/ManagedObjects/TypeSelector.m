//
//  TypeSelector.m
//  Little Pal
//
//  Created by admin on 26.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "TypeSelector.h"

@implementation TypeSelector

-(id)init:(NSString*)key value:(id)value className:(NSString*)className
{
    self = [super init];
    if(self)
    {
        self.key=key;
        self.value=value;
        self.className=className;
		self.byValueBlock = nil;
    }
    return self;
}
-(id)init:(NSString*)key className:(NSString*)className{
    self = [super init];
    if(self)
    {
        self.key=key;
        self.className=className;
		self.byValueBlock = nil;
    }
    return self;
}
/**
 Blalb
 @param key sdsdsd
 @param value sdfdf
 @result  sss
 
 */
+(id)selectorBy:(NSString*)key value:(id)value className:(NSString*)className{
    return [[TypeSelector alloc]init:key value:value className:className];
}
+(id)selectorBy:(NSString*)key className:(NSString*)className{
    return [[TypeSelector alloc]init:key className:className];
}
+(id)selectorBy:(NSString *)key byValueBlock:(TypeSelectorByValueBlock)block className:(NSString *)className
{
	TypeSelector* selector = [self selectorBy:key className:className];
	selector.byValueBlock = block;
	return selector;
}


@end
