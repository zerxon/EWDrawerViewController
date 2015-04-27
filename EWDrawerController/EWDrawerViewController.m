//
//  EWDrawerViewController.m
//  EWDrawerController
//
//  Created by wallace-leung on 15/4/24.
//
//

#import "EWDrawerViewController.h"
#import <objc/runtime.h>

const char *EWDrawerViewControllerKey = "EWDrawerViewControllerKey";

@implementation UIViewController (EWDrawerViewController)

- (EWDrawerViewController *)drawerController
{
    EWDrawerViewController *controller = objc_getAssociatedObject(self, EWDrawerViewControllerKey);
    if (!controller) {
        controller = self.parentViewController.drawerController;
    }
    
    return controller;
}

- (void)setDrawerController:(EWDrawerViewController *)drawerController
{
    objc_setAssociatedObject(self, &EWDrawerViewControllerKey, drawerController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface EWDrawerViewController ()

@property(nonatomic, strong) UIViewController *leftViewController;
@property(nonatomic, strong) UIViewController *centerViewController;
@property(nonatomic, assign) CGFloat distance;
@property(nonatomic, assign) CGFloat FullDistance;
@property(nonatomic, assign) CGFloat Proportion;

@end

@implementation EWDrawerViewController

@synthesize leftViewController;
@synthesize centerViewController;
@synthesize distance;
@synthesize FullDistance;
@synthesize Proportion;

- (id)initWithLeftViewController:(UIViewController *)left
              CenterViewController:(UIViewController *)center
{
    if (self = [super init]) {
        leftViewController = left;
        centerViewController = center;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    distance = 0;
    FullDistance = 0.78;
    Proportion = 0.77;
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    

    [self.view addSubview:centerViewController.view];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [centerViewController.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recongnizer
{
    CGFloat x = [recongnizer translationInView:self.view].x;
    CGFloat trueDistance = distance + x;
    
    if (recongnizer.state == UIGestureRecognizerStateEnded) {
        if (trueDistance > SCREEN_WIDTH * (Proportion / 3.0f)) {
            [self showLeft];
        }
        else if (trueDistance < SCREEN_WIDTH * -(Proportion / 3.0f)) {
            [self showRight];
        }
        else {
            [self showCenter];
        }
        
        return;
    }
    
    CGFloat proportion = recongnizer.view.frame.origin.x >= 0 ? -1 : 1;
    proportion *= trueDistance / SCREEN_WIDTH;
    proportion *= 1 - Proportion;
    proportion /= 0.6;
    proportion += 1;
    if (proportion <= Proportion) {
        return;
    }
    
    recongnizer.view.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y);
    recongnizer.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
}

- (void)showLeft
{
    distance = self.view.center.x * (FullDistance + Proportion / 2);
    [self doTheAnimate:Proportion];
}

- (void)showCenter
{
    distance = 0;
    [self doTheAnimate:1];
}

- (void)showRight
{
    distance = self.view.center.x * -(FullDistance + Proportion / 2);
    [self doTheAnimate:Proportion];
}

- (void)doTheAnimate:(CGFloat)proportion
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        centerViewController.view.center = CGPointMake(self.view.center.x + distance, self.view.center.y);
        centerViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    } completion:nil];
}

@end
