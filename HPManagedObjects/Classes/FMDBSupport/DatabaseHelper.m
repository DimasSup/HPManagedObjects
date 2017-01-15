//
//  DatabaseHelper.m
//  Little Pal
//
//  Created by admin on 02.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <objc/runtime.h>
#import "DatabaseHelper.h"
#import "SerializeHelper.h"
#import "BaseManagedObjectModel+FMDB.h"

@implementation DatabaseHelper

+(NSString*)createSelectQuery:(NSString*)where mapping:(Mapping*)mapping
{
    NSMutableString* columns = [NSMutableString new];
    BOOL isFirst = YES;
	
    for (NSUInteger i = 0; i<mapping.mapings.count; i++) {
        MappingDescriptor* descriptor = mapping.mapings[i];
        if(!descriptor.columnName)continue;
        
        if(!isFirst)
        {
            [columns appendString:@", "];
        }
        isFirst = NO;
        [columns appendString:descriptor.columnName];
    }
    
	if (mapping.idPropertyName && mapping.idName) {
        if(!isFirst)
        {
            [columns appendString:@", "];
        }
		[columns appendString:mapping.idName];
	}
	
	NSString* query = [NSString stringWithFormat:@"select %@ from %@",columns, mapping.tableName];
	
	if(where != nil)
    {
        query = [NSString stringWithFormat:@"%@ where %@",query, where];
    }
    return query;
}




+(NSArray*)executeSelect:(NSString*)type db:(FMDatabase*)db where:(NSString*)where{
    Mapping* mapping = [NSClassFromString(type) getCachedMapping];
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet* set = [db executeQuery:[DatabaseHelper createSelectQuery:where mapping:mapping]];
    while ([set next])
	{
        BaseManagedObjectModel* entity = [[NSClassFromString(type) alloc] init] ;
        [entity updateFromDbSet:set];
        [result addObject:entity];
    }
    
    return result;
}

+(void)executeInsertArray:(NSArray*)models db:(FMDatabase*)db{
    for (BaseManagedObjectModel* model in models) {
            [DatabaseHelper executeInsert:model db:db];
    }
}

+(void)executeDelete:(NSInteger)entityId type:(NSString*)type db:(FMDatabase*)db{
    Mapping* mapping = [NSClassFromString(type) getCachedMapping];
    [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=?",mapping.tableName, mapping.idName], @(entityId)];
}

+(void)executeDeleteType:(NSString*)type condition:(NSString*)condition db:(FMDatabase*)db
{
	Mapping* mapping = [NSClassFromString(type) getCachedMapping];
	[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@",mapping.tableName, condition]];
}


+(void)executeUpdate:(BaseManagedObjectModel *)model db:(FMDatabase*)db
{
    Mapping* mapping = [[model class] getCachedMapping];
    NSMutableArray* arguments = [NSMutableArray new];
    NSMutableString* updates = [NSMutableString new];

    for (NSUInteger i = 0; i<mapping.mapings.count; i++) {
        MappingDescriptor* descriptor = mapping.mapings[i];
		if(!descriptor.columnName)
			continue;
		id value = [model valueForKey:descriptor.propertyName];
		if(!value)
			continue;
		if(updates.length>0)
        {
            [updates appendString:@", "];
        }
        if(descriptor.asString)
        {
            [arguments addObject:[value description]];
        }
        else if(descriptor.format && [value isKindOfClass:[NSDate class]])
		{
			[arguments addObject:[BaseManagedObjectModel getDateString:descriptor.format value:value]];
		}
		else
		{
			[arguments addObject:value];
		}
        [updates appendFormat:@"%@=?", descriptor.columnName];


    }
	[arguments addObject:[model valueForKey:mapping.idPropertyName]];
    NSString* query = [NSString stringWithFormat:@"UPDATE %@ SET %@ where %@ = ?",mapping.tableName, updates, mapping.idName];

    [db executeUpdate:query withArgumentsInArray:arguments];
}

+(void)executeUpdate:(BaseManagedObjectModel *)model db:(FMDatabase*)db where:(NSString*)where
{
    Mapping* mapping = [[model class] getCachedMapping];
    NSMutableArray* arguments = [NSMutableArray new];
    NSMutableString* updates = [NSMutableString new];

    for (NSUInteger i = 0; i< mapping.mapings.count; i++) {
        MappingDescriptor* descriptor = mapping.mapings[i];
		if(!descriptor.columnName)
			continue;
		id value = [model valueForKey:descriptor.propertyName];
		if(!value)
			continue;
		if(updates.length>0)
        {
            [updates appendString:@", "];
        }

        if(descriptor.asString)
        {
            [arguments addObject:[DatabaseHelper toJsonString:value]];
        }
        else if(descriptor.format && [value isKindOfClass:[NSDate class]])
		{
			[arguments addObject:[BaseManagedObjectModel getDateString:descriptor.format value:value]];
		}
		else
		{
			[arguments addObject:value];
		}
        [updates appendFormat:@"%@=?", descriptor.columnName];


    }
    NSString* query = [NSString stringWithFormat:@"UPDATE %@ SET %@",mapping.tableName, updates];
    if(where != nil)
    {
        query = [NSString stringWithFormat:@"%@ where %@", query, where];
    }
    [db executeUpdate:query withArgumentsInArray:arguments];
}

+(NSInteger)executeInsert:(BaseManagedObjectModel *)model db:(FMDatabase*)db
{
    NSMutableArray* arguments = [NSMutableArray new];
    NSMutableString* columns = [NSMutableString new];
    NSMutableString* values = [NSMutableString new];
    Mapping* mapping = [[model class] getCachedMapping];

    for (NSUInteger i = 0; i<mapping.mapings.count; i++) {
        MappingDescriptor* descriptor = mapping.mapings[i];

        id value = [model valueForKey:descriptor.propertyName];

        if(!descriptor.columnName) continue;
        if(columns.length)
        {
            [columns appendString:@" ,"];
            [values appendString:@" ,"];
        }
        [values appendString:@"?"];

        if(value)
        {
            if(descriptor.asString)
            {
                [arguments addObject:[DatabaseHelper toJsonString:value]];
            }
            else if(descriptor.format && [value isKindOfClass:[NSDate class]])
			{
				[arguments addObject:[BaseManagedObjectModel getDateString:descriptor.format value:value]];
			}
			else
			{
				[arguments addObject:value];
			}
        }
        else
        {
            [arguments addObject:[NSNull null]];
        }
        [columns appendString:descriptor.columnName];
    }
    NSString* query = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)",mapping.tableName, columns, values];
    [db executeUpdate:query withArgumentsInArray:arguments];

    if(db.lastErrorCode)
    {
        NSLog(@"%@",db.lastError);
        NSLog(@"%@",query);
        NSLog(@"%@",arguments);
    }

    if(mapping.idPropertyName)
    {
        [model setValue:@(db.lastInsertRowId) forKey:mapping.idPropertyName];
    }
    return (NSInteger) db.lastInsertRowId;
}

+(NSString *)toJsonString:(id)model
{
    if ([[model class] isSubclassOfClass:[NSArray class]])
    {
        NSMutableArray * result = [NSMutableArray new];
        for (BaseManagedObjectModel * entity in model)
        {
            [result addObject:entity.toDictionary];
        }
        NSString *string = [SerializeHelper toJsonString:result prettyPrint:NO];
        return string;
    }
    else
    {
        return [model description];
    }
}


@end
