//
//  FCMutableArray.m
//
//  Created by Florent Crivello on 12/20/13.
//

#import "FCMutableArray.h"

@interface FCMutableArray () {
    __weak id <FCMutableArrayDelegate> _delegate;
    NSMutableArray *_mutableArray;
}

@property (strong, nonatomic) NSMutableArray *mutableArray;

@end

@implementation FCMutableArray

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
	return [self.mutableArray descriptionWithLocale:locale indent:level];
}

- (FCMutableArray*)initWithDelegate:(id<FCMutableArrayDelegate>)delegate {
	self = [super init];
    if(self){
        _delegate = delegate;
     	_mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)init{
	return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	if (self != nil)
	{
		_mutableArray = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

- (id)initWithArray:(NSArray *)array{
	self = [super init];
	if (self != nil){
		_mutableArray = [array mutableCopy];
	}
	return self;
}

- (BOOL)askDelegateForAdditionOfObject:(id)object {
	if (self.delegate && [self.delegate respondsToSelector:@selector(shouldAddObject:toArray:)]) {
		return [self.delegate shouldAddObject:object toArray:self];
	} else {
		return YES;
	}
}

- (BOOL)askDelegateForRemovalOfObject:(id)object {
	if (self.delegate && [self.delegate respondsToSelector:@selector(shouldRemoveObject:fromArray:)]) {
		return [self.delegate shouldRemoveObject:object fromArray:self];
	} else {
		return YES;
	}
}

- (void)informDelegateOfAdditionOfObject:(id)object {
    if(self.delegate){
		if([self.delegate respondsToSelector:@selector(object:wasAddedToArray:)]){
			[self.delegate object:object wasAddedToArray:self];
		}
		if([self.delegate respondsToSelector:@selector(arrayWasMutated:)]){
			[self.delegate arrayWasMutated:self];
		}
    }
}

- (void)informDelegateOfDeletion {
    if(self.delegate){
		if([self.delegate respondsToSelector:@selector(objectWasRemovedFromArray:)]){
			[self.delegate objectWasRemovedFromArray:self];
		}
		if([self.delegate respondsToSelector:@selector(arrayWasMutated:)]){
			[self.delegate arrayWasMutated:self];
		}
    }
}

- (void)informDelegateOfFutureDeletionOfObject:(id)anObject {
	if(self.delegate){
		if([self.delegate respondsToSelector:@selector(object:willBeRemovedFromArray:)]){
			[self.delegate object:anObject willBeRemovedFromArray:self];
		}
		if([self.delegate respondsToSelector:@selector(arrayWasMutated:)]){
			[self.delegate arrayWasMutated:self];
		}
    }
}

- (void)addObject:(id)anObject {
	if ([self askDelegateForAdditionOfObject:anObject]) {
		[self.mutableArray addObject:anObject];
		[self informDelegateOfAdditionOfObject:anObject];
	}
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
	if ([self askDelegateForAdditionOfObject:anObject]) {
		if(index > self.mutableArray.count){
			[self.mutableArray addObject:anObject];
		} else {
			[self.mutableArray insertObject:anObject atIndex:index];
		}
		[self informDelegateOfAdditionOfObject:anObject];
	}
}

- (void)removeObject:(id)anObject {
	if ([self askDelegateForRemovalOfObject:anObject]) {
		[self informDelegateOfFutureDeletionOfObject:anObject];
		[self.mutableArray removeObject:anObject];
		[self informDelegateOfDeletion];
	}
}

- (void)removeObjectAtIndex:(NSUInteger)index {
	if ([self askDelegateForRemovalOfObject:[self objectAtIndex:index]]) {
		[self informDelegateOfFutureDeletionOfObject:[self objectAtIndex:index]];
		[self.mutableArray removeObjectAtIndex:index];
		[self informDelegateOfDeletion];
	}
}

- (void)removeLastObject {
	if ([self askDelegateForRemovalOfObject:[self lastObject]]) {
		[self informDelegateOfFutureDeletionOfObject:[self lastObject]];
		[self.mutableArray removeLastObject];
		[self informDelegateOfDeletion];
	}
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
	if ([self askDelegateForRemovalOfObject:[self objectAtIndex:index]] && [self askDelegateForAdditionOfObject:anObject]) {
		[self informDelegateOfFutureDeletionOfObject:[self objectAtIndex:index]];
		[self.mutableArray replaceObjectAtIndex:index withObject:anObject];
		[self informDelegateOfDeletion];
		[self informDelegateOfAdditionOfObject:anObject];
	}
}

- (id)objectAtIndex:(NSUInteger)index {
	if(self.mutableArray.count > index){
		return [self.mutableArray objectAtIndex:index];
	}
	return nil;
}

- (NSUInteger)count{
    return self.mutableArray.count;
}

@end
