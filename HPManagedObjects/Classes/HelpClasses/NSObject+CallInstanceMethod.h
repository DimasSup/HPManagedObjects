//
//  NSObject+CallInstanceMethod.h
//  Pods
//
//  Created by admin on 26.07.16.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (CallInstanceMethod)
+(void)callInstanceMethod:(SEL)selector inInstance:(NSObject*)instance;
@end
