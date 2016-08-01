//
//  HPDelegatesContainer.m
//  Pods
//
//  Created by admin on 28.07.16.
//
//

#import "HPDelegatesContainer.h"

@interface HPDelegatesContainer()
{
	__block NSMutableArray<id(^)()>* _delegates;
}
@end

@implementation HPDelegatesContainer
@synthesize delegates = _delegates;

- (instancetype)init
{
	self = [super init];
	if (self) {
		_delegates = [NSMutableArray new];
	}
	return self;
}

-(void)addDelegatesObject:(id)object
{
	@synchronized (_delegates)
	{
		[self removeDelegatesObject:object];
		__weak id weakObj = object;
		[_delegates addObject:^id(){
			return weakObj;
		}];
	}
}
-(void)removeDelegatesObject:(id)object
{
	@synchronized (_delegates)
	{
		for (int i = 0; i<_delegates.count; i++)
		{
			id(^tmp)() = _delegates[i];
			id delegate = tmp();
			if(delegate==object)
			{
				[_delegates removeObjectAtIndex:i];
				i--;
			}
		}
	}
}

-(void)enumarateAllDelegatesWithCallback:(BOOL(^)(id))callback
{
	@synchronized (_delegates)
	{
		BOOL isStop = NO;
		for (int i = 0; i<_delegates.count; i++)
		{
			id(^tmp)() = _delegates[i];
			id delegate = tmp();
			if(delegate)
			{
				if(!isStop)
				{
					isStop = callback(delegate);
				}
			}
			else
			{
				[_delegates removeObjectAtIndex:i];
				i--;
			}
		}
	}
}

@end
