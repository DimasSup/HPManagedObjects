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
- (nonnull instancetype) updateWithDictionary:(nullable NSDictionary*)dictionary;

/*!
 *  @brief  String representation of instance in jsone format
 */
-(nonnull NSString *)description;


/*!
 *  @brief  Serialize instance to JSON Dictionary
 *
 *  @return JSON dictionary
 */
-(nullable NSDictionary *)toDictionary;

/*!
 * @brief Serialize selected fields from instance to JSON Dictrionary
 * @return JSON dictionary
 */
-(nullable NSDictionary *)toDictionary:(NSSet* _Nullable)selectedFields;

#pragma mark - static methods
/*!
 *  @remark BaseMangedObjectModel return empty mapping object.
 *  Always use -getCachedMapping method.
 *
 *  @return Mapping instance which contain fields which should serialized
 */
+(nonnull Mapping*)mapping;

/*!
 * @note if you need get Mapping -  always use this method. it use cache for prevent create new instance of Mapping each object
 * @return Mapping instance which contain fields which should serialized
 */
+(nonnull Mapping*)getCachedMapping;
/*!
 *  @brief  If you need create SQLite table for model -  call this.
 *  @note BaseManagedObjectModel.mapping should have not empty <i>tableName</i>, <i>idName</i>, <i>idPropertyName</i>
 *  @return string with strings which you can insert in to update request to FBDatabase
 */
+(nonnull NSString*)generatDBTableCreateString;

/*!
 * Parse string date representation to NSDate with given format. Used cached formatters for performance.
 * @param format string with format
 * @param value string date representation
 * @result NSDate parsed date. Nil if string can't be parsed.
 */
+(nullable NSDate *)getDate:(nullable  NSString*)format value:(nonnull id)value;
/*!
 * Convert make string from date.
 * @param format string with format
 * @param value NSDate object
 * @result NSString parsed date. Nil if date cont be formatted
 */
+(nullable NSString*)getDateString:(nullable NSString*)format value:(nonnull id)value;
/*!
 * Get cached NSDateFormatter with format
 */
+(nonnull NSDateFormatter*)dateFormatterForFormat:(nullable NSString*)format;
@end
