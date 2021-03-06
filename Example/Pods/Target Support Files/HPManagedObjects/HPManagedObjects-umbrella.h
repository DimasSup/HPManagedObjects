#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BaseManagedObjectModel+FMDB.h"
#import "DatabaseHelper.h"
#import "Generic.h"
#import "HPDelegatesContainer.h"
#import "Macroses.h"
#import "NSObject+CallInstanceMethod.h"
#import "NSObject+ClassName.h"
#import "NSString+NSString_MD5.h"
#import "BaseManagedObjectModel.h"
#import "BaseManagedObjectModel_Private.h"
#import "Mapping.h"
#import "MappingDescriptor.h"
#import "SerializeHelper.h"
#import "TypeSelector.h"

FOUNDATION_EXPORT double HPManagedObjectsVersionNumber;
FOUNDATION_EXPORT const unsigned char HPManagedObjectsVersionString[];

