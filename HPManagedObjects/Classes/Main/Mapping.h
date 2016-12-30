//
//  Mapping.h
//  Little Pal
//
//  Created by admin on 03.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappingDescriptor.h"

@interface Mapping : NSObject

-(id)init:(NSArray*)mappings idName:(NSString*)idName idPropertyName:(NSString*)idPropertyName tableName:(NSString*)tableName;

/*!
 *  @brief  Should save source dictionary for save unmapped json fields?
 * if yes <b><i>mappedClass</i>.__sourceDictionary</b> will be contain source dictionary;
 */
@property(nonatomic)BOOL saveSource;
@property(nonatomic, strong) NSMutableArray *mapings;
@property(nonatomic, strong) NSString *idName;
@property(nonatomic, strong) NSString *idPropertyName;
@property(nonatomic, strong) NSString *tableName;

@end
