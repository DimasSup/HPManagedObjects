//
//  MappingDescriptor.m
//  Little Pal
//
//  Created by admin on 24.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "MappingDescriptor.h"

@implementation MappingDescriptor
@synthesize realClassFromName = _realClassFromName;


-(Class)realClassFromName
{
    if(!_realClassFromName)
    {
        _realClassFromName = NSClassFromString(self.className);
    }
    return _realClassFromName;
}


- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.converter = nil;
	}
	return self;
}
-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className
{
    self = [self init];
    if(self)
    {
        self.propertyName =propertyName;
        self.jsonName=jsonName;
        self.className = className;
    }
    return self;
}

-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName typeSelectors:(NSArray *)typeSelectors
{
    self = [self init:propertyName jsonName:jsonName ignoreEmptyOrZeroValue:NO];
    if(self)
    {
        self.typeSelectors = typeSelectors;
    }
    return self;
}

-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName  columnName:(NSString *)columnName
{
    self = [self init:propertyName jsonName:jsonName ignoreEmptyOrZeroValue:NO];
    if(self)
    {
        self.columnName = columnName;
    }
    return self;
}

-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName
{
    self = [self init:propertyName jsonName:jsonName ignoreEmptyOrZeroValue:NO];
    if(self)
    {
		
    }
    return self;
}


-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName ignoreEmptyOrZeroValue:(BOOL)ignoreEmptyOrZero
{
	self = [self init];
	if(self)
	{
		self.propertyName =propertyName;
		self.jsonName=jsonName;
		self.ignoreNullOrEmptyZero = ignoreEmptyOrZero;
	}
	return self;
}


-(id)convertValue:(id)value
{
	if(self.convert)
	{
		return self.convert(value);
	}
	else if(self.converter)
	{
		return [self.converter convert:value];
	}
	return value;
}

-(id)convertValueBack:(id)value
{
	if(self.convertBack)
	{
		return self.convertBack(value);
	}
	else if(self.converter)
	{
		return [self.converter convertBack:value];
	}
	if(value)
	{
		if(self.ignoreNullOrEmptyZero)
		{
			if([value isKindOfClass:[NSString class]])
			{
				if([value length]==0)
				{
					value = nil;
				}
			}
			else if([value isKindOfClass:[NSNumber class]])
			{
				if([value doubleValue]==0)
				{
					value = nil;
				}
			}
		}
	}
	return value;
}

#pragma mark - static

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className{
    return [[MappingDescriptor alloc]init:propertyName jsonName:jsonName className:className];
}

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName classNameBlock:(MappingDescriptionClassNameByParametersBlock)classNameBlock
{
	MappingDescriptor *descriptor = [[MappingDescriptor alloc]init:propertyName jsonName:jsonName className:nil];
	descriptor.columnName = columnName;
	descriptor.classNameBlock = classNameBlock;
	return descriptor;
}

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName typeSelectors:(NSArray *)typeSelectors
{
    return [[MappingDescriptor alloc]init:propertyName jsonName:jsonName typeSelectors:typeSelectors];
}
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName{
    return [[MappingDescriptor alloc]init:propertyName jsonName:jsonName columnName:columnName];
}
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName{
    return [[MappingDescriptor alloc]init:propertyName jsonName:jsonName];
}
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName ignoreEmptyOrZeroValue:(BOOL)ignoreEmptyOrZero
{
	return [[MappingDescriptor alloc] init:propertyName jsonName:jsonName ignoreEmptyOrZeroValue:ignoreEmptyOrZero];
}
+(id)descriptorBy:(NSString *)propertyName{
    return [[MappingDescriptor alloc]init:propertyName jsonName:propertyName];
}

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString
{
    MappingDescriptor *descriptor = [[MappingDescriptor alloc]init:propertyName jsonName:jsonName className:className];
    descriptor.columnName = columnName;
    descriptor.asString = asString;
    return descriptor;
}
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString convert:(MappingDescriptorConverter)convert convertBack:(MappingDescriptorConverter)convertBack
{
	MappingDescriptor* descriptor = [self descriptorBy:propertyName jsonName:jsonName className:className columnName:columnName asString:asString];
	descriptor.convert = convert;
	descriptor.convertBack = convertBack;
	return descriptor;
}
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString converter:(id<MappingDescriptorConverterProtocol>)converter
{
	MappingDescriptor* descriptor = [self descriptorBy:propertyName jsonName:jsonName className:className columnName:columnName asString:asString];
	descriptor.converter = converter;
	return descriptor;
}

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName format:(NSString *)format{
    MappingDescriptor *descriptor = [[MappingDescriptor alloc]init:propertyName jsonName:jsonName columnName:columnName];
    descriptor.format = format;
    return descriptor;
}
@end
