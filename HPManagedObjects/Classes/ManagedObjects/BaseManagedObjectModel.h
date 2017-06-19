//
//  BaseManagedObjectModel.h
//  Little Pal
//
//  Created by admin on 24.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappingDescriptor.h"

#import "Mapping.h"

/*!
 *
 *  @brief BaseManagedObjectModel use this class for save to database or send to network. It can serialize/deserialize to JSON and save/load from FMDatabase
 */
@interface BaseManagedObjectModel : NSObject
{
}
/*!
 *  @brief  Source json dictionary if <i>saveSource</i> == <b>YES</b>
 */
@property(nonatomic,copy,nullable)NSDictionary* __sourceDictionary;


/*!
 *  @brief  Update current instance with json dictionary
 *
 *  @param dictionary JSON dictionary
 *
 *  @return always return <i>itself</i>
 */
- (id _Nonnull) updateWithDictionary:(NSDictionary* _Nullable)dictionary;

/*!
 *  @brief  String representation of instance in jsone format
 */
-(NSString * _Nonnull)description;


/*!
 *  @brief  Serialize instance to JSON Dictionary
 *
 *  @return JSON dictionary
 */
-(NSDictionary * _Nonnull)toDictionary;

/*!
 * @brief Serialize selected fields from instance to JSON Dictrionary
 * @return JSON dictionary
 */
-(NSDictionary * _Nonnull)toDictionary:(NSSet* _Nullable)selectedFields;

#pragma mark - static methods
/*!
 *  @remark BaseMangedObjectModel return nil value
 *
 *  @return Mapping instance which containt fields which should serialized
 */
+(Mapping*_Nonnull)mapping;
+(Mapping*_Nonnull)getCachedMapping;
/*!
 *  @brief  If you need create SQLite table for model -  call this.
 *  @remark BaseManagedObjectModel.mapping should have not empty <i>tableName</i>, <i>idName</i>, <i>idPropertyName</i> 
 *  @return string with strings which you can insert in to update request to FBDatabase
 */
+(NSString*_Nonnull)generatDBTableCreateString;

+(NSDate *_Nullable)getDate:(NSString*_Nullable)format value:(id _Nullable)value;
+(NSString*_Nullable)getDateString:(NSString*_Nullable)format value:(id _Nullable)value;
+(NSDateFormatter*_Nonnull)dateFormatterForFormat:(NSString*_Nullable)format;
@end
