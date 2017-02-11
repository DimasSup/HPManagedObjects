//
//  Macroses.h
//  Pods
//
//  Created by admin on 01.07.16.
//
//

#ifndef Macroses_h
#define Macroses_h

#define THOROW_NOT_IMPLEMENT @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@: Should implement in extension:[%@ %@]",[NSBundle mainBundle].bundleIdentifier,[[self class]className], NSStringFromSelector(_cmd)] userInfo:nil];

#define THOROW_NOT_IMPLEMENT_MESSAGE(message) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@: %@\n Should implement in extension:[%@ %@]",[NSBundle mainBundle].bundleIdentifier,message,[[self class]className], NSStringFromSelector(_cmd)] userInfo:nil];

#define NSStringFormat(format, ...) [NSString stringWithFormat:format,## __VA_ARGS__]

#endif /* Macroses_h */
