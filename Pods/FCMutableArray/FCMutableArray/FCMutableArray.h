//
//  FCMutableArray.h
//
//  Created by Florent Crivello on 12/20/13.
//	Permission is hereby granted to do whatever the fuck you want with this piece of code
//

#import <Foundation/Foundation.h>

/**
 * A composite class behaving as an NSMutableArray, that allows an object to be informed whenever
 * a modification is made to it.
 */
@class FCMutableArray;

@protocol FCMutableArrayDelegate <NSObject>
@optional

// Informs the delegate that an object was added to the array
- (void)object:(id)object wasAddedToArray:(FCMutableArray *)array;

// Informs the delegate that an object was removed from the array
- (void)objectWasRemovedFromArray:(FCMutableArray *)array;

// Informs the delegate that an object will soon be removed from the array
- (void)object:(id)object willBeRemovedFromArray:(FCMutableArray *)array;

// Informs the delegate that the array was modified - either by adding, removing or replacing an object
- (void)arrayWasMutated:(FCMutableArray*)array;

// Asks the delegate if it should add the object to the array
- (BOOL)shouldAddObject:(id)object toArray:(FCMutableArray *)array;

// Asks the delegate if it should remove the object from the array
- (BOOL)shouldRemoveObject:(id)object fromArray:(FCMutableArray *)array;

@end

@interface FCMutableArray : NSMutableArray

// The object acting as the FCMutableArray delegate
@property (weak, nonatomic) id<FCMutableArrayDelegate> delegate;

/**
 * Returns an FCMutableArray
 * @param delegate The object acting as the FCMutableArray delegate
 */
- (FCMutableArray*)initWithDelegate:(id<FCMutableArrayDelegate>)delegate;

- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;
- (id)initWithArray:(NSArray *)array;

@end
