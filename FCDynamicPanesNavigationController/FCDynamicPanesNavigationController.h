//
//  FCDynamicPanesNavigationController.h
//
//  Created by Florent Crivello on 3/17/14.
//

#import <UIKit/UIKit.h>
#import <FCMutableArray.h>
#import "FCDynamicPane.h"

@interface UIViewController (FCDynamicPanesNavigationController)

@property (nonatomic, readonly) FCDynamicPanesNavigationController *panesNavigationController;

@end

@interface FCDynamicPanesNavigationController : UIViewController <FCMutableArrayDelegate, FCDynamicPaneDelegate>

- (id)initWithRootViewController: (UIViewController *)viewController;

- (id)initWithViewControllers:(NSArray *)viewControllers;

- (void)pushViewController:(UIViewController *)viewController retracted:(BOOL)retracted;

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popViewControllerAnimated:(BOOL)animated;

@property (readonly, nonatomic) FCMutableArray *viewControllers;
@property (nonatomic) BOOL paneSwitchingEnabled;

@end
