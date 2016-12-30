//
//  Mapping.m
//  Little Pal
//
//  Created by admin on 03.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "Mapping.h"

@implementation Mapping

-(id)init:(NSArray*)mappings idName:(NSString*)idName idPropertyName:(NSString*)idPropertyName tableName:(NSString*)tableName
{
    self = [super init];
    if(self)
    {
		_mapings = [[NSMutableArray alloc] initWithArray:mappings];
        self.idName = idName;
        self.idPropertyName = idPropertyName;
        self.tableName = tableName;
    }
    return self;
}

@end
