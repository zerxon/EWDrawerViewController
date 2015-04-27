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

@interface EWDrawerViewController : UIViewController

@end

@interface UIViewController (EWDrawerViewController)

@property(nonatomic, retain) EWDrawerViewController *drawerController;

- (id)initWithLeftViewController:(UIViewController *)left
            CenterViewController:(UIViewController *)center;

- (void)showLeft;

@end
