//
//  SerializeHelper.h
//  Little Pal
//
//  Created by DimasSup on 03.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerializeHelper : NSObject
{
	
}


+(NSArray*)newObjectsFromJSONArray:(NSArray*)jsonArray className:(NSString*)className;
+(NSData *)nsDataFromNSObject:(id)object;
+(NSData *)nsDataFromNSObject:(id)object isJson:(BOOL*)isJson;
+(NSData *)nsDataFromNSArray:(NSArray *)array;


+(id)deserialize:(NSData*)data toClass:(NSString*)className error:(NSError **)error;

+(NSString*) toJsonString:(id)obj prettyPrint:(BOOL)prettyPrint;
@end
