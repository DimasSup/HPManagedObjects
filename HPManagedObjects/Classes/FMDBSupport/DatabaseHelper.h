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


+(NSArray* _Nonnull)executeSelect:(NSString*_Nonnull)type db:(FMDatabase* _Nonnull)db where:(NSString*_Nullable)where;
+(void)executeUpdate:(BaseManagedObjectModel*_Nonnull)model db:(FMDatabase*_Nonnull)db where:(NSString* _Nonnull)where;
+(void)executeUpdate:(BaseManagedObjectModel*_Nonnull)model db:(FMDatabase*_Nonnull)db;
+(NSInteger)executeInsert:(BaseManagedObjectModel*_Nonnull)model db:(FMDatabase*_Nonnull)db;
+(NSInteger)executeInsert:(BaseManagedObjectModel*_Nonnull)model db:(FMDatabase*_Nonnull)db forced:(BOOL)forced;
+(void)executeDelete:(NSInteger)entityId type:(NSString*_Nonnull)type db:(FMDatabase*_Nonnull)db;
+(void)executeInsertArray:(NSArray*_Nonnull)models db:(FMDatabase*_Nonnull)db;
+(void)executeInsertArray:(NSArray*_Nonnull)models db:(FMDatabase*_Nonnull)db forced:(BOOL)forced;
+(void)executeDeleteType:(NSString*_Nonnull)type condition:(NSString*_Nonnull)condition db:(FMDatabase*_Nonnull)db;

@end
