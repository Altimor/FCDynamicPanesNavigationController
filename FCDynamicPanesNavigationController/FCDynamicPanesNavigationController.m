//
//  FCDynamicPanesNavigationController.m
//
//  Created by Florent Crivello on 3/17/14.
//

#import "FCDynamicPanesNavigationController.h"

#define DEGREE_TO_RADIAN(x) x*M_PI/180
#define MINIMUM_VELOCITY 	0

@interface FCDynamicPanesNavigationController ()

@property (nonatomic) FCMutableArray *viewControllers;
@property (nonatomic, weak) UIViewController *activeViewController;

@end

@implementation FCDynamicPanesNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewControllers = [[FCMutableArray alloc] initWithDelegate:self];
	_paneSwitchingEnabled = YES;
	return self;
}

- (id)initWithRootViewController: (UIViewController *)viewController {
	self = [self initWithViewControllers:@[viewController]];
	if (!self) {
		return nil;
	}
	return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewControllers = [[FCMutableArray alloc] initWithDelegate:self];
	[_viewControllers addObjectsFromArray:viewControllers];
	return self;
}

- (void)pushViewController:(UIViewController *)viewController retracted:(BOOL)retracted {
	FCDynamicPane *dynamicPane = [[FCDynamicPane alloc] initWithViewController:viewController];
	[_viewControllers addObject:dynamicPane];
}

- (void)setPaneSwitchingEnabled:(BOOL)paneSwitchingEnabled {
	_paneSwitchingEnabled = paneSwitchingEnabled;
	for (FCDynamicPane *pane in _viewControllers) {
		pane.swipeEnabled = paneSwitchingEnabled;
	}
}

- (void)popViewControllerAnimated:(BOOL)animated {
	if (animated) {
		FCDynamicPane *lastPane = [self.viewControllers lastObject];
		lastPane.gravityBehavior.gravityDirection = CGVectorMake(0, 3);
		lastPane.gravityBehavior.action = nil;
		lastPane.state = FCDynamicPaneLeavingScreen;
		[lastPane.behavior removeChildBehavior:lastPane.attachmentBehavior];
	} else {
		[self.viewControllers removeLastObject];
	}
}

#pragma mark - FCMutableArray delegate

- (void)object:(FCDynamicPane *)object wasAddedToArray:(FCMutableArray *)array {
	if (![array indexOfObject:object]) {
		[object removeFromParentViewController];
		[self addChildViewController:object];
		object.view.frame = CGRectMake(0, 0, object.view.frame.size.width, object.view.frame.size.height);
		[self.view addSubview:object.view];
		[object didMoveToParentViewController:self];
		object.state = FCDynamicPaneStateRoot;
	} else {
		FCDynamicPane *includingViewController = ((FCDynamicPane *)[array objectAtIndex:[array indexOfObject:object]-1]);
		UIView *includingView = includingViewController.view;
		object.view.frame = CGRectMake(0, TILE_Y, object.view.frame.size.width, object.view.frame.size.height);
		
		[object removeFromParentViewController];
		[includingViewController addChildViewController:object];
		[includingView addSubview:object.view];
		[includingView bringSubviewToFront:object.view];
		[object didMoveToParentViewController:includingViewController];
		
		object.state = FCDynamicPaneStateRetracted;
	}
}

- (void)object:(id)object willBeRemovedFromArray:(FCMutableArray *)array {
	// Looks like we're popping a ViewController
	if ([object isKindOfClass:[FCDynamicPane class]]) {
		FCDynamicPane *pane = (FCDynamicPane *)object;
		//1. Move its childViewController (N+1) into its parentViewController (N-1)
		__block FCDynamicPane *childPane = nil;
		[pane.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj isKindOfClass:[FCDynamicPane class]]) {
				childPane = obj;
				*stop = YES;
			}
		}];
		if (childPane) {
			[childPane.view removeFromSuperview];
			[childPane willMoveToParentViewController:nil];
			[childPane removeFromParentViewController];
			childPane.view.frame = CGRectMake(0, [array indexOfObject:pane] ? [UIScreen mainScreen].bounds.size.height: 0, childPane.view.frame.size.width, childPane.view.frame.size.height);
			[pane.parentViewController.view addSubview:childPane.view];
			[pane.parentViewController addChildViewController:childPane];
			[childPane didMoveToParentViewController:pane.parentViewController];
			
			if (![array indexOfObject:pane]) {
				// The Root Pane just got removed
				childPane.state = FCDynamicPaneStateRoot;
			}
		}
		
		//2. Remove from its parentViewController
		[pane.view removeFromSuperview];
		[pane removeFromParentViewController];
		[pane didMoveToParentViewController:nil];
		
		//3. Bring back the child view's child view on top
		__block FCDynamicPane *childChildPane = nil;
		[childPane.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj isKindOfClass:[FCDynamicPane class]]) {
				childChildPane = obj;
				*stop = YES;
			}
		}];
		[childPane.view bringSubviewToFront:childChildPane.view];
	}
}

- (BOOL)shouldAddObject:(id)object toArray:(FCMutableArray *)array {
	if ([object isKindOfClass:[FCDynamicPane class]]) {
		((FCDynamicPane *)object).delegate = self;
		return YES;
	} else if ([object isKindOfClass:[UIViewController class]]) {
		FCDynamicPane *compositeItem = [[FCDynamicPane alloc] initWithViewController:object];
		[array addObject:compositeItem];
	}
	return NO;
}

- (void)dynamicPaneDidGoOutOfScreen:(FCDynamicPane *)pane {
	if (pane.state == FCDynamicPaneLeavingScreen) {
		[self.viewControllers removeObject:pane];
	}
}

@end
