//
//  FCDynamicPane.h
//
//  Created by Florent Crivello on 3/18/14.
//

#import <Foundation/Foundation.h>

#define TILE_HEIGHT			50
#define TILE_Y				[UIScreen mainScreen].bounds.size.height - TILE_HEIGHT

typedef NS_ENUM(NSUInteger, FCDynamicPaneState) {
	FCDynamicPaneStateActive,
	FCDynamicPaneStateRetracted,
	FCDynamicPaneStateRoot
};

@class FCDynamicPane;

@interface FCDynamicPane : UIViewController {
	@private
	UIViewController *_viewController;
}

@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic) UIView *view;
@property (nonatomic) BOOL swipeEnabled;
@property (nonatomic) FCDynamicPaneState state;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIDynamicBehavior *behavior;
@property (nonatomic) UICollisionBehavior *collisionBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIGravityBehavior *gravityBehavior;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;


-(void)setAnchorPoint:(CGPoint)anchorPoint;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
