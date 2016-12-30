//
//  SerializeHelper.m
//  Little Pal
//
//  Created by DimasSup on 03.07.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "SerializeHelper.h"
#import "BaseManagedObjectModel.h"
@implementation SerializeHelper
+(NSArray *)newObjectsFromJSONArray:(NSArray *)jsonArray className:(NSString *)className
{
	NSMutableArray* result = [NSMutableArray new];
	Class class = NSClassFromString(className);
	for (NSDictionary* dict in jsonArray)
	{
		BaseManagedObjectModel* model = [[class alloc] init];
		[model updateWithDictionary:dict];
		[result addObject:model];
	}
	
	return result;
}
+(NSData *)nsDataFromNSObject:(id)object
{
	return [self nsDataFromNSObject:object isJson:NULL];
}
+(NSData *)nsDataFromNSObject:(id)object isJson:(BOOL*)isJson
{
	if(isJson!=NULL)
	{
		*isJson = NO;
	}
	if(!object)
		return nil;
	if([object isKindOfClass:[NSData class]])
	{
		return object;
	}
	if([object isKindOfClass:[NSArray class]])
	{
		if(isJson!=NULL)
		{
			*isJson =YES;
		}
		return [self nsDataFromNSArray:object];

	}
	NSError *error;
    NSDictionary* dictionary  = nil;
    if([object isKindOfClass:[BaseManagedObjectModel class]])
    {
		
        dictionary = [object toDictionary];
    }
    else if([object isKindOfClass:[NSDictionary class]])
    {
		
        dictionary = object;
    }
    else
    {
        return nil;
    }
#if DEBUG && NETWORK_LOG
	NSLog(@"Send object:\n%@",dictionary);
#endif
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
	if(isJson!=NULL)
	{
		*isJson =YES;
	}
    return jsonData;
}
+(NSData *)nsDataFromNSArray:(NSArray *)array
{
	NSMutableArray* jsonArray = [NSMutableArray new];
	for (BaseManagedObjectModel* model in array)
	{
		[jsonArray addObject:[model toDictionary]];
	}
	
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    return jsonData;
}

+(NSString*) toJsonString:(id)obj prettyPrint:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
