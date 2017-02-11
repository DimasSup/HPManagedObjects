# HPManagedObjects

[![CI Status](http://img.shields.io/travis/DimasSup/HPManagedObjects.svg?style=flat)](https://travis-ci.org/DimasSup/HPManagedObjects)
[![Version](https://img.shields.io/cocoapods/v/HPManagedObjects.svg?style=flat)](http://cocoapods.org/pods/HPManagedObjects)
[![License](https://img.shields.io/cocoapods/l/HPManagedObjects.svg?style=flat)](http://cocoapods.org/pods/HPManagedObjects)
[![Platform](https://img.shields.io/cocoapods/p/HPManagedObjects.svg?style=flat)](http://cocoapods.org/pods/HPManagedObjects)

Swift 3.0/Obj-C supported

### Under the hood
Simple Obj-c iOS JSON  library. Help you make your classes support serializing/deserializing.

## Known Swift limitations:
- Swift Enums not working now.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
Import HPManagedObjects in to your file

```obj-c

@interface BaseOtherJsonClassObject : BaseManagedObjectModel
@property(nonatomic,strong,nullable)NSString* baseIdentifier;
@property(nonatomic,assign)int objectType;//0 - OtherJsonClassObject, 1 - SecondOtherJsonClassObject, 2 - ThirdOtherJsonClassObject
@end
@implementation BaseOtherJsonClassObject
+(Mapping *)mapping
{
	Mapping* mapping = [super mapping];
	
	MappingDescriptor* descriptor = [MappingDescriptor descriptorBy:@"baseIdentifier" jsonName:@"base_id"];
	[mapping.mapings addObject:descriptor];
	
	descriptor = [MappingDescriptor descriptorBy:@"objectType" jsonName:@"type"];
	[mapping.mapings addObject:descriptor];
	
	
	return mapping;
}
@end

@interface OtherJsonClassObject : BaseOtherJsonClassObject
@property(nonatomic,strong,nullable)NSString* anySomeProperty;
@end
@implementation OtherJsonClassObject
+(Mapping *)mapping
{
	Mapping* mapping = [super mapping];
	
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"anySomeProperty"]];
	
	return mapping;
}
@end
@interface SecondOtherJsonClassObject : BaseOtherJsonClassObject
@property(nonatomic,assign)int secondProperty;
@end
@implementation SecondOtherJsonClassObject
+(Mapping *)mapping
{
	Mapping* mapping = [super mapping];
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"secondProperty"]];
	return mapping;
}
@end
@interface ThirdOtherJsonClassObject : BaseOtherJsonClassObject
@property(nonatomic,strong)id anyValue;
@end
@implementation ThirdOtherJsonClassObject
+(Mapping *)mapping
{
	Mapping* mapping = [super mapping];
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"anyValue"]];
	
	return mapping;
}
@end



@interface SimpleJSONObject: BaseManagedObjectModel{
}
@property(nonatomic,strong,nullable)NSString* textValue;
@property(nonatomic,assign)long objectId;
@property(nonatomic,strong,nullable)NSArray<NSString*>* stringValues;
@property(nonatomic,strong,nullable)NSDictionary<NSString*,id>* anyValues;
@property(nonatomic,strong,nullable)OtherJsonClassObject* otherObject;
@property(nonatomic,strong,nullable)NSArray<BaseOtherJsonClassObject*>* otherObjectsArray;
@property(nonatomic,strong,nullable)NSArray<BaseOtherJsonClassObject*>* otherObjectsWitBlockSelectorArray;

@property(nonatomic,strong,nullable)NSDate* creationDate;
@property(nonatomic,assign)CGPoint point;
@end

@implementation SimpleJSONObject
+(Mapping *)mapping
{
	Mapping* mapping = [super mapping];
	
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"textValue" jsonName:@"text"]];
	
	//JSON name same as text field name
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"objectId"]];
	
	//No need specified array of items, it recognizes array and dictionary
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"stringValues" jsonName:@"vals"]];
	
	//No need specified array of items, it recognizes array and dictionary
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"anyValues" jsonName:@"vals_map"]];
	
	//Serialize OtherJsonClassObject to dictionary, deserialize dictionary to OtherJsonClassObject
	[mapping.mapings addObject:[MappingDescriptor descriptorBy:@"otherObject" jsonName:@"subclass" className:@"OtherJsonClassObject"]];
	
	
	
	NSArray<TypeSelector*>* typeSelectors = @[
							   //if object in array containt field "base_id" object will be deserialize to 'OtherJsonClassObject'
							   [TypeSelector selectorBy:@"anyValue" className:@"ThirdOtherJsonClassObject"],
							   //If object in array contain field 'type' and it is equal to '1' then object will be deserialize to 'SecondOtherJsonClassObject'
							   [TypeSelector selectorBy:@"type" value:@(1) className:@"SecondOtherJsonClassObject"],
							   //Make custom check for json property value, if block return YES - use OtherJsonClassObject as object type
							   [TypeSelector selectorBy:@"type" byValueBlock:^BOOL(id value) {
								   NSNumber* numb = value;
								   if([numb intValue] == 0)
								   {
									   return YES;
								   }
								   return NO;
								   
							   } className:@"OtherJsonClassObject"],
							   //If any type selector does not match -  use 'self' if you want use class as default
							   [TypeSelector selectorBy:@"self" className:@"BaseOtherJsonClassObject"],
							   ];
	
	MappingDescriptor* descriptor = [MappingDescriptor descriptorBy:@"otherObjectsArray"
														   jsonName:@"objc_array"
													  typeSelectors:typeSelectors];
	[mapping.mapings addObject:descriptor];
	
	
	
	
	descriptor = [MappingDescriptor descriptorBy:@"otherObjectsWitBlockSelectorArray"
										jsonName:@"objc_array_v2" columnName:nil classNameBlock:^NSString *(id rootDictionary, id value) {
											if([value isKindOfClass:[NSDictionary class]])
											{
												int type =  [[(NSDictionary*)value valueForKey:@"type"] intValue];
												if(type == 0)
												{
													return @"OtherJsonClassObject";
												}
												else if(type == 1)
												{
													return @"SecondOtherJsonClassObject";
												}
												else if(type == 2)
												{
													return @"ThirdOtherJsonClassObject";
												}
											}
											return @"BaseOtherJsonClassObject";
											
										}];
	[mapping.mapings addObject:descriptor];
	
	
	return mapping;
}
@end

```

## Requirements

## Installation

HPManagedObjects is available through 'DSPods'(link 'https://github.com/DimasSup/DSPods'). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/DimasSup/DSPods.git'

pod "HPManagedObjects"
```

## Author

DimasSup, dima.teleban@gmail.com

## License

HPManagedObjects is available under the MIT license. See the LICENSE file for more info.
