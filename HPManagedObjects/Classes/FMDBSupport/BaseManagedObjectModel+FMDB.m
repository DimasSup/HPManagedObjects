//
//  BaseManagedObjectModel+FMDB.m
//  Little Pal
//
//  Created by admin on 21.06.16.
//  Copyright © 2016 BrillKids. All rights reserved.
//

#import "BaseManagedObjectModel+FMDB.h"
#import "BaseManagedObjectModel_Private.h"
@implementation BaseManagedObjectModel (FMDB)
-(instancetype)updateFromDbSet:(FMResultSet*)resultSet
{
	@autoreleasepool {
		
		
		Class myClass = self.class;
		Mapping* mapping = [myClass getCachedMapping];
		if(mapping.idPropertyName && mapping.idName)
		{
			id value = [resultSet objectForColumn:mapping.idName];
			if(value && value!=[NSNull null])
			{
				[self setValue:value forKey:mapping.idPropertyName];
			}
		}
		NSMutableDictionary* resultSetDict = [[NSMutableDictionary alloc] initWithCapacity:resultSet.columnCount];
		for (NSString* key in resultSet.columnNameToIndexMap)
		{
			id result = [resultSet objectForColumn:key];
			if(result)
				resultSetDict[key] = result;
		}
		for (MappingDescriptor* descriptor in mapping.mapings) {
			if(!descriptor.columnName || !descriptor.propertyName)continue;
			id value = [resultSet objectForColumn:descriptor.columnName];
			if(value && value != [NSNull null])
			{
				if(descriptor.asString)
				{
					
					[myClass preparePropertyDescriptionInfo:descriptor forClass:myClass];
					if ([descriptor.resultPropertyClass isSubclassOfClass:[NSArray class]])
					{
						NSError *error;
						NSArray *array = [NSJSONSerialization JSONObjectWithData:[(NSString*)value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
						
						NSMutableArray *nestedArray = [self getArray:descriptor rootDict:resultSetDict value:array];
						[self setValue:nestedArray forKey:descriptor.propertyName];
						
					}
					else
					{
						NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[(NSString*)value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
						if(descriptor.classNameBlock)
						{
							
							NSString* className = descriptor.classNameBlock(resultSetDict,dic);
							BaseManagedObjectModel *nestedClass = [self getModelFromClassName:className value:dic];
							[self setValue:nestedClass forKey:descriptor.propertyName];
						}
						if(descriptor.className && [descriptor.resultPropertyClassName isEqualToString:descriptor.className])
						{
							BaseManagedObjectModel *nestedClass = [self getModel:descriptor value:dic];
							[self setValue:nestedClass forKey:descriptor.propertyName];
						}
						else if(descriptor.typeSelectors)
						{
							BaseManagedObjectModel *nestedClass = [self getModelByType:descriptor rootDict:resultSetDict value:dic];
							if(nestedClass)
								[self setValue:nestedClass forKey:descriptor.propertyName];
							
						}
						
						
					}
				}
				else if(descriptor.format && value)
				{
					NSDate *dateFromString = [myClass getDate:descriptor.format value:value];
					if(dateFromString)
					{
						[self setValue:dateFromString forKey:descriptor.propertyName];
					}
					else
					{
						[self setValue:[NSDate date] forKeyPath:descriptor.propertyName];
					}
				}
				else
				{
					[self setValue:[descriptor convertValue:value] forKey:descriptor.propertyName];
				}
			}
			
		}
		return self;
	}
}
@end
