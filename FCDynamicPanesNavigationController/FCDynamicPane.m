//
//  FCDynamicPane.m
//
//  Created by Florent Crivello on 3/18/14.
//

#import "FCDynamicPane.h"

@interface FCDynamicPane ()

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation FCDynamicPane

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
	self = [self init];
	if (!self) {
		return nil;
	}
	_viewController = viewController;
	return self;
}

- (void)tapHandle:(UITapGestureRecognizer *)gesture {
	if (self.state != FCDynamicPaneStateActive) {
		[self.pushBehavior setPushDirection:CGVectorMake(0, -500)];
		self.pushBehavior.active = YES;
	}
}

- (void)panHandle:(UIPanGestureRecognizer *)gesture {
	if (self.state == FCDynamicPaneStateRoot) {
		return;
	}
	
    CGPoint newLocation = CGPointMake(self.view.layer.anchorPoint.x * gesture.view.bounds.size.width, [gesture locationInView:self.view.superview].y);
	newLocation.y = MAX(newLocation.y,self.view.layer.anchorPoint.y * self.view.bounds.size.height);
	
	if (gesture.state == UIGestureRecognizerStateBegan) {
		CGPoint anchor = [gesture locationInView:gesture.view];
		[self setAnchorPoint:CGPointMake(anchor.x/gesture.view.bounds.size.width,
										 anchor.y/gesture.view.bounds.size.height)];
		
		self.pushBehavior.active = NO;
		[self.behavior removeChildBehavior:self.attachmentBehavior];
		[self.animator removeBehavior:self.behavior];
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		self.view.layer.position = newLocation;
	} else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setAnchorPoint:CGPointMake(0.5,0.5)];
		
		//I think that's a bug in the SDK, the collision behavior keeps losing its points
		[self.collisionBehavior addBoundaryWithIdentifier:@"collision" fromPoint:CGPointMake(0, -1) toPoint:CGPointMake(320, -1)];
		
		CGFloat pushDirectionY = [gesture velocityInView:self.view].y/2;
		[self.pushBehavior setPushDirection:CGVectorMake(0, pushDirectionY)];
		self.pushBehavior.active = YES;
		self.pushBehavior.action = (void (^)(void)) ^{
			__weak FCDynamicPane *weakSelf = self;
			if (weakSelf.view.frame.origin.y <= TILE_Y-60 && pushDirectionY < 0) {
				weakSelf.state = FCDynamicPaneStateActive;
			} else if ((weakSelf.view.frame.origin.y > 60 && pushDirectionY > 0)) {
				weakSelf.state = FCDynamicPaneStateRetracted;
			}
		};
		
		[self.behavior addChildBehavior:self.pushBehavior];
		[self.animator addBehavior:self.behavior];
	}
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
	[self addChildViewController:_viewController];
	[self.view addSubview:_viewController.view];
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
	[_viewController.view addGestureRecognizer:self.tapGestureRecognizer];
	
	self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
	[_viewController.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];
	[_viewController didMoveToParentViewController:self];
	
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self.view superview]];
	
	self.behavior = [[UIDynamicBehavior alloc] init];
	self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.view]];
	[self.collisionBehavior addBoundaryWithIdentifier:@"collision" fromPoint:CGPointMake(0, -1) toPoint:CGPointMake(320, -1)];
	[self.behavior addChildBehavior:self.collisionBehavior];
	
	self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.view]];
	self.gravityBehavior.action = ^{
		__weak FCDynamicPane *weakSelf = self;
		if (weakSelf.view.frame.origin.y <= 50) {
			self.attachmentBehavior.anchorPoint = CGPointMake(160, [UIScreen mainScreen].bounds.size.height / 2-3);
			self.attachmentBehavior.damping = 0.7f;
			self.attachmentBehavior.frequency = 2.0f;
			[self.behavior addChildBehavior:self.attachmentBehavior];
		} else if (weakSelf.view.frame.origin.y >= TILE_Y-60) {
			self.attachmentBehavior.anchorPoint = CGPointMake(160, [UIScreen mainScreen].bounds.size.height / 2+TILE_Y);
			self.attachmentBehavior.damping = 0.4f;
			self.attachmentBehavior.frequency = 4.0f;
			[self.behavior addChildBehavior:self.attachmentBehavior];
		}
	};
	[self.behavior addChildBehavior:self.gravityBehavior];
	
	self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.view attachedToAnchor:CGPointMake(160, TILE_Y+[UIScreen mainScreen].bounds.size.height/2)];
	self.attachmentBehavior.frequency = 4.0f;
	self.attachmentBehavior.damping = 0.4f;
	self.attachmentBehavior.length = 0;
	
	UIDynamicItemBehavior *dynamicView = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
//	dynamicView.resistance = 0.1f;
//	dynamicView.density = 3.0f;
	dynamicView.elasticity = 0.3f;
	dynamicView.allowsRotation = NO;
	[self.behavior addChildBehavior:dynamicView];
	
	self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.view] mode:UIPushBehaviorModeInstantaneous];
	[self.behavior addChildBehavior:self.pushBehavior];
	
	[self.animator addBehavior:self.behavior];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.view.bounds.size.width * anchorPoint.x, self.view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.view.bounds.size.width * self.view.layer.anchorPoint.x, self.view.bounds.size.height * self.view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.view.transform);
    
    CGPoint position = self.view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.view.layer.position = position;
    self.view.layer.anchorPoint = anchorPoint;
}

- (void)setState:(FCDynamicPaneState)state {
	if (state == FCDynamicPaneStateActive || state == FCDynamicPaneStateRoot) {
		self.gravityBehavior.gravityDirection = CGVectorMake(0, -1);
	} else if (state == FCDynamicPaneStateRetracted) {
		self.attachmentBehavior.anchorPoint = CGPointMake(160, [UIScreen mainScreen].bounds.size.height / 2 + TILE_Y);
		self.gravityBehavior.gravityDirection = CGVectorMake(0, 1.5);
	}
	
	_state = state;
}

@end
