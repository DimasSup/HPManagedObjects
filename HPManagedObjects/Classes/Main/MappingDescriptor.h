//
//  MappingDescriptor.h
//  Little Pal
//
//  Created by admin on 24.06.14.
//  Copyright (c) 2014 BrillKids. All rights reserved.
//

#import "TypeSelector.h"


typedef  id _Nullable(^MappingDescriptorConverter) ( id _Nullable value);
typedef NSString* _Nullable (^MappingDescriptionClassNameByParametersBlock) ( id _Nullable rootDictionary, id _Nullable value);
@protocol MappingDescriptorConverterProtocol <NSObject>

/**
*/
-(id _Nullable)convert:(id _Nullable)value;
/**
*/
-(id _Nullable)convertBack:(id _Nullable)value;

@end
@interface MappingDescriptor : NSObject
@property(nonatomic,strong,nullable)Class resultPropertyClass;
@property(nonatomic,strong,nullable)NSString* resultPropertyClassName;

-(nullable id)init:(nonnull NSString * )propertyName jsonName:(nullable NSString *)jsonName typeSelectors:(nullable NSArray<TypeSelector*> *)typeSelectors;
-(nullable id)init:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName className:(nullable NSString *)className;
-(nullable id)init:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName;

@property (nonatomic, strong,nonnull) NSString *propertyName;
@property (nonatomic, strong,nullable ) NSString *jsonName;
@property (nonatomic, strong,nullable ) NSString *className;
@property (nonatomic, readonly,nullable) Class realClassFromName;
@property(nonatomic,assign)BOOL canUseRoot;
@property (nonatomic, strong,nullable) NSArray<TypeSelector*> *typeSelectors;
@property (nonatomic, strong,nullable) NSString *columnName;
@property (nonatomic, strong,nullable) NSString *format;
@property (nonatomic) BOOL asString;
@property (nonatomic, copy,nullable) MappingDescriptorConverter convert;
@property (nonatomic, copy,nullable) MappingDescriptorConverter convertBack;
@property (nonatomic, strong,nullable) id<MappingDescriptorConverterProtocol> converter;

@property (nonatomic,copy,nullable) MappingDescriptionClassNameByParametersBlock classNameBlock;

@property (nonatomic,assign)BOOL ignoreNullOrEmptyZero;

@property (nonatomic) BOOL required;
@property (nonatomic, strong,nullable)id defaultValue;

-(nullable id)convertValue:(nullable id)value;
-(nullable id)convertValueBack:(nullable id)value;

+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName className:(nullable NSString *)className;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName columnName:(nullable NSString *)columnName classNameBlock:(nullable MappingDescriptionClassNameByParametersBlock)classNameBlock;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName className:(nullable NSString *)className columnName:(nullable NSString *)columnName asString:(BOOL)asString;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName className:(nullable NSString *)className columnName:(nullable NSString *)columnName asString:(BOOL)asString convert:(nullable MappingDescriptorConverter)convert convertBack:(nullable MappingDescriptorConverter)convertBack;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName className:(nullable NSString *)className columnName:(nullable NSString *)columnName asString:(BOOL)asString converter:(nullable id<MappingDescriptorConverterProtocol>)converter;

+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName typeSelectors:(nullable NSArray<TypeSelector*> *)typeSelectors;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName ignoreEmptyOrZeroValue:(BOOL)ignoreEmptyOrZero;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName columnName:(nullable NSString *)columnName;
+(nonnull id)descriptorBy:(nonnull NSString *)propertyName jsonName:(nullable NSString *)jsonName columnName:(nullable NSString *)columnName format:(nullable NSString *)format;
@end
