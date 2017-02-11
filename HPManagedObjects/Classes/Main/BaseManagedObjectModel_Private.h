//
//  BaseManagedObjectModel_Private.h
//  Little Pal
//
//  Created by admin on 21.06.16.
//  Copyright © 2016 BrillKids. All rights reserved.
//


@interface BaseManagedObjectModel ()
+(void)preparePropertyDescriptionInfo:(MappingDescriptor*)description forClass:(Class)class;
- (NSMutableArray *)getArray:(MappingDescriptor *)descriptor rootDict:(NSDictionary*)rootDict value:(id)value;
- (BaseManagedObjectModel *)getModelFromClassName:(NSString *)className value:(id)value;
- (BaseManagedObjectModel *)getModel:(MappingDescriptor *)descriptor value:(id)value;
- (BaseManagedObjectModel *)getModelByType:(MappingDescriptor *)descriptor rootDict:(id)rootDict value:(id)value;
- (BaseManagedObjectModel *)getModelByType:(MappingDescriptor *)descriptor value:(id)value;
@end

