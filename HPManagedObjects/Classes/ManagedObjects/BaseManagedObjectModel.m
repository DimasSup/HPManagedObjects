//
//  BaseManagedObjectModel.m
//  Little Pal
//
//  Created by admin on 24.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "BaseManagedObjectModel.h"
#import "SerializeHelper.h"
#import <objc/runtime.h>
#import "NSObject+ClassName.h"

static NSMutableDictionary* _BaseManagedObjectMappingsCache = nil;
static NSMutableDictionary* _BaseManagedObjectDateFormattersCache = nil;
@implementation BaseManagedObjectModel
+(Mapping*)getCachedMapping
{
    @synchronized(_BaseManagedObjectMappingsCache)
    {
        NSString* str =[[NSString alloc] initWithCString:class_getName(self) encoding:NSASCIIStringEncoding];
        
        Mapping* m = _BaseManagedObjectMappingsCache[str];
        if(!m)
        {
            m = [self mapping];
            if(m)
                [_BaseManagedObjectMappingsCache setObject:m forKey:str];
            else
            {
                NSLog(@"WTF man! Where is Mapping for %@",[self className]);
            }
        }
        return m;
    }
    
}
+(void)initialize
{
    [super initialize];
    if(!_BaseManagedObjectMappingsCache)
    {
        _BaseManagedObjectMappingsCache = [NSMutableDictionary new];
    }
	if(!_BaseManagedObjectDateFormattersCache)
	{
		_BaseManagedObjectDateFormattersCache = [NSMutableDictionary new];
	}
#if CHECK_MODELS
	BaseManagedObjectModel* b = [[self alloc] init];
	NSDictionary* d = [b toDictionary];
	NSLog(@"Dic: %@",d);
#endif
}


static const char *getPropertyType(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	//    printf("attributes=%s\n", attributes);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
			 if you want a list of what will be returned for these primitives, search online for
			 "objective-c" "Property Attribute Description Examples"
			 apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
			 */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
			
			NSString* string = [NSString stringWithCString:attribute encoding:NSASCIIStringEncoding];
			NSString* sString = [string substringWithRange:NSMakeRange(3, string.length - 4)];
			return [sString cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}



- (id)updateWithDictionary:(id)dictionary
{
	@autoreleasepool {
		
		
		if(!dictionary)
			return self;
		if([dictionary isKindOfClass:[NSNull class]])
		{
			return self;
		}
		
		if([dictionary isKindOfClass:[NSString class]])
		{
			dictionary = [NSJSONSerialization JSONObjectWithData:[(NSString*)dictionary dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
		}
		if(![dictionary isKindOfClass:[NSDictionary class]])
			return self;
		
		Class myClass = self.class;
		
		Mapping* mapping = [myClass getCachedMapping];
		if(mapping.saveSource)
			self.__sourceDictionary = dictionary;
		for (MappingDescriptor* descriptor in mapping.mapings)
		{
			[myClass preparePropertyDescriptionInfo:descriptor forClass:myClass];
			
			if(!descriptor.jsonName)
				continue;
			
			
			id value = [dictionary objectForKey:descriptor.jsonName];
			
			// FIXME: !value
			
			if(value == [NSNull null])
			{
				continue;
			}
			
			if ([descriptor.resultPropertyClass isSubclassOfClass:[NSArray class]])
			{
				NSMutableArray *nestedArray = [self getArray:descriptor rootDict:dictionary value:value];
				[self setValue:nestedArray forKey:descriptor.propertyName];
			}
			else if(descriptor.classNameBlock)
			{
				NSString* className = descriptor.classNameBlock(dictionary,value);
				BaseManagedObjectModel *nestedClass = [self getModelFromClassName:className value:value];
				[self setValue:nestedClass forKey:descriptor.propertyName];
			}
			else if(descriptor.className && [descriptor.resultPropertyClassName isEqualToString:descriptor.className])
			{
				BaseManagedObjectModel *nestedClass = [self getModel:descriptor value:value];
				[self setValue:nestedClass forKey:descriptor.propertyName];
			}
			else if(descriptor.typeSelectors)
			{
				BaseManagedObjectModel *nestedClass = [self getModelByType:descriptor rootDict:dictionary value:value];
				if(nestedClass)
					[self setValue:nestedClass forKey:descriptor.propertyName];
				
			}
			else if([descriptor.resultPropertyClass isSubclassOfClass:[NSDictionary class]])
			{
				
				NSMutableDictionary* nestedDictionary = [NSMutableDictionary new];
				if(descriptor.canUseRoot &&(!value && ![value isKindOfClass:[NSNull class]] && (descriptor.className.length || descriptor.typeSelectors.count)))
				{
					value = dictionary;
				}
				else
				if(!value || [value isKindOfClass:[NSNull class]])
				{
					nestedDictionary = nil;
					value = nil;
				}
				if(descriptor.asString && [value isKindOfClass:[NSString class]])
				{
					value = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
				}
				for (id key in value)
				{
					id obj = value[key];
					
					if(descriptor.typeSelectors)
					{
						BaseManagedObjectModel* nestedClass = [self getModelByType:descriptor rootDict:value value:obj];
						if(nestedClass)
						{
							nestedDictionary[key] = nestedClass;
						}
					}
					else if(descriptor.classNameBlock)
					{
						NSString* className = descriptor.classNameBlock(value,obj);
						BaseManagedObjectModel *nestedClass = [self getModelFromClassName:className value:obj];
						[self setValue:nestedClass forKey:descriptor.propertyName];
					}
					else if(descriptor.className)
					{
						BaseManagedObjectModel* nestedClass = [[descriptor.realClassFromName alloc] init];
						[nestedClass updateWithDictionary:obj];
						nestedDictionary[key] = nestedClass;
					}
					else
					{
						nestedDictionary[key] = obj;
					}
				}
				if(nestedDictionary)
					[self setValue:nestedDictionary forKey:descriptor.propertyName];
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
			else if(value)
			{
				[self setValue:[descriptor convertValue:value] forKey:descriptor.propertyName];
				
			}
		}
		return self;
	}
}

- (BaseManagedObjectModel *)getModelFromClassName:(NSString *)className value:(id)value
{
	BaseManagedObjectModel* nestedClass = [[NSClassFromString(className) alloc] init];
	[nestedClass updateWithDictionary:value];
	return nestedClass;
}

- (BaseManagedObjectModel *)getModel:(MappingDescriptor *)descriptor value:(id)value {
    BaseManagedObjectModel* nestedClass = [[descriptor.realClassFromName alloc] init];
    [nestedClass updateWithDictionary:value];
    return nestedClass;
}

- (BaseManagedObjectModel *)getModelByType:(MappingDescriptor *)descriptor rootDict:(id)rootDict value:(id)value {
	BaseManagedObjectModel* nestedClass = nil;
	
	for (TypeSelector* selector in descriptor.typeSelectors)
	{
		BOOL byThis = NO;
		id checkmark = nil;
		if([selector.key hasSuffix:@"."])
		{
			checkmark =  rootDict[[selector.key substringFromIndex:1]];
		}
		else if(selector.key.length)
		{
			if([value isKindOfClass:[NSString class]])
			{
				value = [NSJSONSerialization JSONObjectWithData:[(NSString*)value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

			}
			checkmark = value[selector.key];
		}
		else
		{
			byThis = YES;
		}
		
		if(selector.byValueBlock)
		{
			byThis = selector.byValueBlock(checkmark);
		}
		else if(checkmark)
		{
			if(!selector.value ||  [selector.value isEqual:checkmark])
			{
				byThis = YES;
			}
			
		}
		
		if(byThis)
		{
			
			nestedClass = [[NSClassFromString(selector.className) alloc] init];
			[nestedClass updateWithDictionary:value];
			
			break;
		}
	}
	return nestedClass;
}


- (BaseManagedObjectModel *)getModelByType:(MappingDescriptor *)descriptor value:(id)value {
    BaseManagedObjectModel* nestedClass = nil;
    NSDictionary* nesterdJson = value;
    for (TypeSelector* selector in descriptor.typeSelectors) {
                if([nesterdJson objectForKey:selector.key])
                {
                    nestedClass = [[NSClassFromString(selector.className) alloc] init];
                    [nestedClass updateWithDictionary:nesterdJson];

                    break;
                }
            }
    return nestedClass;
}



- (NSMutableArray *)getArray:(MappingDescriptor *)descriptor rootDict:(NSDictionary*)rootDict value:(id)value {
	NSArray* array = value;
	
    NSMutableArray* nestedArray = [NSMutableArray new];
    for (id obj in array)
    {
        if(descriptor.typeSelectors)
        {
            
            BaseManagedObjectModel* nestedClass = [self getModelByType:descriptor rootDict:rootDict value:obj];
            if(nestedClass)
                [nestedArray addObject:nestedClass];
            
            
        }
        else if(descriptor.classNameBlock)
        {
            
            NSString* className = descriptor.classNameBlock(rootDict,obj);
            BaseManagedObjectModel *nestedClass = [self getModelFromClassName:className value:obj];
            [self setValue:nestedClass forKey:descriptor.propertyName];
        }
        else if(descriptor.className)
        {
            BaseManagedObjectModel* nestedClass = [[descriptor.realClassFromName alloc] init];
            [nestedClass updateWithDictionary:obj];
            [nestedArray addObject:nestedClass];
        }
        else
        {
            [nestedArray addObject:obj];
        }
    }
    
    return nestedArray;
}

- (NSMutableArray *)getArray:(MappingDescriptor *)descriptor value:(id)value {
	NSArray* array = value;
	
	NSMutableArray* nestedArray = [NSMutableArray new];
	
	for (id obj in array)
	{
		if(descriptor.typeSelectors)
		{
			for (TypeSelector* selector in descriptor.typeSelectors) {
				if([obj objectForKey:selector.key])
				{
					BaseManagedObjectModel* nestedClass = [[NSClassFromString(selector.className) alloc] init];
					[nestedClass updateWithDictionary:obj];
					[nestedArray addObject:nestedClass];
					break;
				}
			}
		}
		else if(descriptor.className)
		{
			BaseManagedObjectModel* nestedClass = [[descriptor.realClassFromName alloc] init];
			[nestedClass updateWithDictionary:obj];
			[nestedArray addObject:nestedClass];
		}
		else
		{
			[nestedArray addObject:obj];
		}
            }
    return nestedArray;
}


-(NSDictionary *)toDictionary
{
    Class myClass = self.class;
	Mapping* mapping = [myClass getCachedMapping];
	NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithDictionary:self.__sourceDictionary?:@{}];
	for (MappingDescriptor* descriptor in mapping.mapings) {
		if (!descriptor.jsonName
#if !CHECK_MODELS
			|| !descriptor.propertyName
#endif
			)
		{
			continue;
		}
		id value = nil;
#if CHECK_MODELS
		value =	[self valueForKey:descriptor.propertyName];
#else
		@try {
			value =	[self valueForKey:descriptor.propertyName];
		}
		@catch (NSException *exception) {
			
		}
#endif
		
		
		if (!value)
		{
			continue;
		}
		if([value isKindOfClass:[BaseManagedObjectModel class]])
		{
			NSDictionary* dic = [value toDictionary];
			if(descriptor.asString){
                NSString* serilizedProperty = [SerializeHelper toJsonString:dic prettyPrint:NO];
                [result setObject:serilizedProperty forKey:descriptor.jsonName];
            }
            else{
                [result setObject:dic forKey:descriptor.jsonName];
            }
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray* array = [NSMutableArray new];
            
            for (id obj in value)
            {
                if([obj isKindOfClass:[BaseManagedObjectModel class]])
                {
                    [array addObject:[obj toDictionary]];
                }
                else
                {
                    [array addObject:obj];
                }
            }
            [result setObject:array forKey:descriptor.jsonName];
        }
		else if([value isKindOfClass:[NSDictionary class]])
		{
			NSMutableDictionary* dict = [NSMutableDictionary new];
			for (id key in value)
			{
				id subValue = value[key];
				if([subValue isKindOfClass:[BaseManagedObjectModel class]])
				{
					dict[key] = [subValue toDictionary];
				}
				else
				{
					dict[key] = subValue;
				}
			}
			if(dict.count)
			{
				[result setObject:dict forKey:descriptor.jsonName];
			}
        }
        else if([value isKindOfClass:[NSDate class]])
        {
            
            NSString *stringFromDate = [myClass getDateString:descriptor.format value:value];
			
			if(stringFromDate)
			{
				[result setObject:stringFromDate forKey:descriptor.jsonName];
			}
        }
        else if(value)
		{
			value = [descriptor convertValueBack:value];
			if(value)
			{
				
				[result setObject:value forKey:descriptor.jsonName];
			}
        }
    }
    return result;
}

-(NSString *)description
{
    NSString* resString = [SerializeHelper toJsonString:[self toDictionary] prettyPrint:YES];
    return resString;
}

#pragma mark -
+(Mapping*)mapping
{
    return [[Mapping alloc] init:nil idName:nil idPropertyName:nil tableName:nil];
}

/*
 CREATE TABLE "TMessage" ("_id" INTEGER PRIMARY KEY  NOT NULL ,"message_id" INTEGER NOT NULL  DEFAULT (-1) ,"user_id" INTEGER NOT NULL ,"chat_id" INTEGER NOT NULL ,"text" TEXT NOT NULL  DEFAULT ('') ,"data" TEXT NOT NULL  DEFAULT ('') ,"type1" INTEGER NOT NULL  DEFAULT (0) ,"type2" INTEGER NOT NULL  DEFAULT (0) ,"type3" INTEGER NOT NULL  DEFAULT (0) ,"record_date" DATETIME NOT NULL  DEFAULT (CURRENT_TIMESTAMP) , "date" TEXT NOT NULL  DEFAULT '', "role" INTEGER NOT NULL DEFAULT -1,"status" INTEGER NOT NULL DEFAULT(0), "state" INTEGER NOT NULL  DEFAULT 0,"visible_id" INTEGER NOT NULL  DEFAULT (0), "version" INTEGER NOT NULL  DEFAULT (0));
 */

+(NSString *)generatDBTableCreateString
{
    
    Class myClass = self.class;
    
    Mapping* mapping = [myClass getCachedMapping];
    NSMutableString* requestString = [NSMutableString new];
    
    if(mapping && mapping.tableName.length && mapping.idName.length && mapping.idPropertyName.length)
    {
        Class idKeyClass = [self getClassForPrperty:mapping.idPropertyName forClass:myClass outClassName:nil];
        NSArray* types = [[NSArray alloc] initWithObjects:@"INTEGER",@"TEXT",@"DATETIME", nil];
        NSString* tempString = [[NSString alloc] initWithFormat:@"create table \"%@\" ( \"%@\" %@ PRIMARY KEY NOT NULL%%@);",mapping.tableName,mapping.idName,types[[self databaseClassType:idKeyClass]]];

        NSMutableString* other = [NSMutableString new];
        
        for (MappingDescriptor* description in mapping.mapings)
        {
            if(!description.columnName.length)
                continue;
            Class class = [self getClassForPrperty:description.propertyName forClass:myClass outClassName:nil];
            [other appendFormat:@", \"%@\" %@ %@ %@",description.columnName,types[[self databaseClassType:class]],description.required?@"NOT NULL":@"",description.defaultValue?[NSString stringWithFormat:@"DEFAULT ('%@')", description.defaultValue]:@""];
            
            
        }

        [requestString appendFormat:tempString,other];
    }
    
    return requestString;
}

+(void)preparePropertyDescriptionInfo:(MappingDescriptor*)description forClass:(Class)class
{
    if(!description.resultPropertyClass)
    {
        objc_property_t theProperty = class_getProperty(class, [description.propertyName UTF8String]);
        const char * propertyType = getPropertyType(theProperty);
        NSString* className =[NSString stringWithCString:propertyType encoding:NSASCIIStringEncoding];
        if(className.length)
        {
            description.resultPropertyClassName = className;
            description.resultPropertyClass = NSClassFromString(className)?:[NSNull class];
        }
    }

}

+(Class)getClassForPrperty:(NSString*)propertyName forClass:(Class)class outClassName:(NSString**)outClassName
{
    objc_property_t theProperty = class_getProperty(class, [propertyName UTF8String]);
    const char * propertyType = getPropertyType(theProperty);
    NSString* className =[NSString stringWithCString:propertyType encoding:NSASCIIStringEncoding];
    if(outClassName!=nil)
    {
        *outClassName = className;
    }
    return NSClassFromString(className);
}
+(int)databaseClassType:(Class)class
{
    int classType = 0;//0 - integer (NUMERIC),1 - TEXT,2 - DATETIME
    if([class isSubclassOfClass:[NSString class]]||
       [class isSubclassOfClass:[BaseManagedObjectModel class]]||
       [class isSubclassOfClass:[NSData class]]||
       [class isSubclassOfClass:[NSArray class]]||
       [class isSubclassOfClass:[NSDictionary class]])
    {
        classType = 1;
    }
    else if([class isSubclassOfClass:[NSDate class]])
    {
        classType = 2;
    }
    return classType;
   
}

+(NSDate *)getDate:(NSString*)format value:(id)value
{
    return [[self dateFormatterForFormat:format] dateFromString:value];
}
+(NSString*)getDateString:(NSString*)format value:(id)value
{
    return [[self dateFormatterForFormat:format] stringFromDate:value];
}
+(NSDateFormatter*)dateFormatterForFormat:(NSString*)format
{
    if(!format)
    {
        format = @"";
    }
    NSDateFormatter* dateFormatter = _BaseManagedObjectDateFormattersCache[format];
    if(!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.calendar = [[NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        if(format.length)
            [dateFormatter setDateFormat:format];
        _BaseManagedObjectDateFormattersCache[format] = dateFormatter;
        
    }
    return dateFormatter;
}

#pragma mark -

#pragma mark -

@end
