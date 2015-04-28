//
//  EWDrawerViewController.h
//  EWDrawerController
//
//  Created by wallace-leung on 15/4/24.
//
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

typedef NS_ENUM(NSInteger, EWDrawerSide){
    EWDrawerSideNone = 0,
    EWDrawerSideLeft,
    EWDrawerSideRight,
};

@interface EWDrawerViewController : UIViewController

@property(nonatomic, strong) UIImageView *backgroundView;

- (id)initWithLeftViewController:(UIViewController *)left
            CenterViewController:(UIViewController *)center;

- (void)toggleDrawSide:(EWDrawerSide)drawerSide completion:(void(^)(void))completion;

@end

@interface UIViewController (EWDrawerViewController)

@property(nonatomic, retain) EWDrawerViewController *drawerController;

@end
