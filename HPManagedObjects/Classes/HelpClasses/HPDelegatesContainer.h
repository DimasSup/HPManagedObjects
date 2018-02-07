//
//  HPDelegatesContainer.h
//  Pods
//
//  Created by admin on 28.07.16.
//
//

#import <Foundation/Foundation.h>

@interface HPDelegatesContainer<__covariant ObjectType> : NSObject
@property(nonatomic,strong,readonly,nonnull)NSArray<id(^)(void)>* delegates;
-(void)addDelegatesObject:(ObjectType _Nonnull)object;
-(void)removeDelegatesObject:(ObjectType _Nonnull)object;
/*!
 *Enumerate all delegate and call callback each one
 *@note if callback result if YES  - enumerating will break;
 */
-(void)enumarateAllDelegatesWithCallback:(BOOL(^ _Nonnull)(ObjectType  _Nonnull))callback;
@end
