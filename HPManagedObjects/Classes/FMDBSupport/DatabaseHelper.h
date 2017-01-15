//
//  DatabaseHelper.h
//  Little Pal
//
//  Created by admin on 02.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseManagedObjectModel.h"
@import FMDB;


@interface DatabaseHelper : NSObject

+(NSArray*)executeSelect:(NSString*)type db:(FMDatabase*)db where:(NSString*)where;
+(void)executeUpdate:(BaseManagedObjectModel*)model db:(FMDatabase*)db where:(NSString*)where;
+(void)executeUpdate:(BaseManagedObjectModel*)model db:(FMDatabase*)db;
+(NSInteger)executeInsert:(BaseManagedObjectModel*)model db:(FMDatabase*)db;
+(void)executeDelete:(NSInteger)entityId type:(NSString*)type db:(FMDatabase*)db;
+(void)executeInsertArray:(NSArray*)models db:(FMDatabase*)db;
+(void)executeDeleteType:(NSString*)type condition:(NSString*)condition db:(FMDatabase*)db;

@end
