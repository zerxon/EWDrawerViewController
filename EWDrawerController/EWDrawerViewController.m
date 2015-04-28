//
//  EWDrawerViewController.m
//  EWDrawerController
//
//  Created by wallace-leung on 15/4/24.
//
//

#import "EWDrawerViewController.h"
#import <objc/runtime.h>

static const CGFloat EWDistanceRate = 0.6f;
static const CGFloat EWScaleProportion = 0.77f;

const char *EWDrawerViewControllerKey = "EWDrawerViewControllerKey";

@implementation UIViewController (EWDrawerViewController)

- (EWDrawerViewController *)drawerController
{
    EWDrawerViewController *controller = objc_getAssociatedObject(self, &EWDrawerViewControllerKey);
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
@property(nonatomic, assign) EWDrawerSide curDrawerSide;

@end

@implementation EWDrawerViewController

@synthesize leftViewController;
@synthesize centerViewController;
@synthesize distance;
@synthesize curDrawerSide;

- (id)initWithLeftViewController:(UIViewController *)left
              CenterViewController:(UIViewController *)center
{
    if (self = [super init]) {
        leftViewController = left;
        [leftViewController setDrawerController:self];
        
        centerViewController = center;
        [centerViewController setDrawerController:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    distance = 0;

    [self.view addSubview:centerViewController.view];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [centerViewController.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)setBackgroundView:(UIImageView *)backgroundView
{
    [self.backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    self.backgroundView.frame = self.view.frame;
    [self.view insertSubview:self.backgroundView atIndex:0];
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recongnizer
{
    CGFloat x = [recongnizer translationInView:self.view].x;
    CGFloat trueDistance = distance + x;
    
    if (recongnizer.state == UIGestureRecognizerStateEnded) {
        if (trueDistance > SCREEN_WIDTH * (EWScaleProportion / 3.0f)) {
            [self showLeft];
        }
        else if (trueDistance < SCREEN_WIDTH * -(EWScaleProportion / 3.0f)) {
            [self showRight];
        }
        else {
            [self showCenter];
        }
        
        return;
    }
    
    CGFloat EWScaleProportion = recongnizer.view.frame.origin.x >= 0 ? -1 : 1;
    EWScaleProportion *= trueDistance / SCREEN_WIDTH;
    EWScaleProportion *= 1 - EWScaleProportion;
    EWScaleProportion /= 0.6;
    EWScaleProportion += 1;
    if (EWScaleProportion <= EWScaleProportion) {
        return;
    }
    
    recongnizer.view.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y);
    recongnizer.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, EWScaleProportion, EWScaleProportion);
}

- (void)toggleDrawSide:(EWDrawerSide)drawerSide completion:(void(^)(void))completion
{
    NSParameterAssert(drawerSide != EWDrawerSideNone);

    if (curDrawerSide == drawerSide) {
        [self showCenter];
    }
    else if (drawerSide == EWDrawerSideLeft) {
        [self showLeft];
    }
    else if(drawerSide == EWDrawerSideRight) {
        [self showRight];
    }
    
    if (completion != nil) {
        completion();
    }
}

- (void)showLeft
{
    distance = self.view.center.x * (EWDistanceRate + EWScaleProportion / 2);
    curDrawerSide = EWDrawerSideLeft;
    [self doTheAnimate:EWScaleProportion];
}

- (void)showCenter
{
    distance = 0;
    curDrawerSide = EWDrawerSideNone;
    [self doTheAnimate:1];
}

- (void)showRight
{
    distance = self.view.center.x * -(EWDistanceRate + EWScaleProportion / 2);
    curDrawerSide = EWDrawerSideRight;
    [self doTheAnimate:EWScaleProportion];
}

- (void)doTheAnimate:(CGFloat)EWScaleProportion
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        centerViewController.view.center = CGPointMake(self.view.center.x + distance, self.view.center.y);
        centerViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, EWScaleProportion, EWScaleProportion);
    } completion:nil];
}

@end
