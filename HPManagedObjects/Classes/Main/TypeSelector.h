//
//  TypeSelector.h
//  Little Pal
//
//  Created by admin on 26.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef BOOL(^TypeSelectorByValueBlock) (id value);


@interface TypeSelector : NSObject

-(id)init:(NSString*)key value:(id)value className:(NSString*)className;
-(id)init:(NSString*)key className:(NSString*)className;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, copy)TypeSelectorByValueBlock byValueBlock;
+(id)selectorBy:(NSString*)key value:(id)value className:(NSString*)className;
+(id)selectorBy:(NSString*)key className:(NSString*)className;
+(id)selectorBy:(NSString*)key byValueBlock:(TypeSelectorByValueBlock)block className:(NSString*)className;

@end
