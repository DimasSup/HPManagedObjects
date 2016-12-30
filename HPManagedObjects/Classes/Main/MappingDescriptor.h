//
//  MappingDescriptor.h
//  Little Pal
//
//  Created by admin on 24.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "TypeSelector.h"


typedef id(^MappingDescriptorConverter) (id value);
typedef NSString*(^MappingDescriptionClassNameByParametersBlock) (id rootDictionary, id value);
@protocol MappingDescriptorConverterProtocol <NSObject>

/**
*/
-(id)convert:(id)value;
/**
*/
-(id)convertBack:(id)value;

@end
@interface MappingDescriptor : NSObject
@property(nonatomic,strong)Class resultPropertyClass;
@property(nonatomic,strong)NSString* resultPropertyClassName;
-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName typeSelectors:(NSArray *)typeSelectors;
-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className;
-(id)init:(NSString *)propertyName jsonName:(NSString *)jsonName;

@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *jsonName;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, readonly) Class realClassFromName;
@property(nonatomic,assign)BOOL canUseRoot;
@property (nonatomic, strong) NSArray *typeSelectors;
@property (nonatomic, strong) NSString *columnName;
@property (nonatomic, strong) NSString *format;
@property (nonatomic) BOOL asString;
@property (nonatomic, copy) MappingDescriptorConverter convert;
@property (nonatomic, copy) MappingDescriptorConverter convertBack;
@property (nonatomic, strong) id<MappingDescriptorConverterProtocol> converter;

@property (nonatomic,copy) MappingDescriptionClassNameByParametersBlock classNameBlock;

@property (nonatomic,assign)BOOL ignoreNullOrEmptyZero;

@property (nonatomic) BOOL required;
@property (nonatomic, strong)id defaultValue;

-(id)convertValue:(id)value;
-(id)convertValueBack:(id)value;

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName classNameBlock:(MappingDescriptionClassNameByParametersBlock)classNameBlock;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString convert:(MappingDescriptorConverter)convert convertBack:(MappingDescriptorConverter)convertBack;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName className:(NSString *)className columnName:(NSString *)columnName asString:(BOOL)asString converter:(id<MappingDescriptorConverterProtocol>)converter;

+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName typeSelectors:(NSArray *)typeSelectors;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName ignoreEmptyOrZeroValue:(BOOL)ignoreEmptyOrZero;
+(id)descriptorBy:(NSString *)propertyName;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName;
+(id)descriptorBy:(NSString *)propertyName jsonName:(NSString *)jsonName columnName:(NSString *)columnName format:(NSString *)format;
@end
