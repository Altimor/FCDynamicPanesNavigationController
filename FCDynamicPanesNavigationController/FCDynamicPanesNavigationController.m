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

- (BOOL)shouldAddObject:(id)object toArray:(FCMutableArray *)array {
	if ([object isKindOfClass:[FCDynamicPane class]]) {
		return YES;
	} else if ([object isKindOfClass:[UIViewController class]]) {
		FCDynamicPane *compositeItem = [[FCDynamicPane alloc] initWithViewController:object];
		[array addObject:compositeItem];
	}
	return NO;
}

@end
