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

-(nonnull id)init:(nonnull NSArray*)mappings idName:(nullable NSString*)idName idPropertyName:(nullable NSString* )idPropertyName tableName:(nullable NSString*)tableName;

/*!
 *  @brief  Should save source dictionary for save unmapped json fields?
 * if yes <b><i>mappedClass</i>.__sourceDictionary</b> will be contain source dictionary;
 */
@property(nonatomic)BOOL saveSource;
@property(nonatomic, strong, nullable) NSMutableArray<MappingDescriptor*> *mapings;
@property(nonatomic, strong, nullable) NSString *idName;
@property(nonatomic, strong, nullable) NSString *idPropertyName;
@property(nonatomic, strong, nullable) NSString *tableName;

@end
