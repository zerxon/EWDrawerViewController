//
//  ViewController.m
//  EWDrawerController
//
//  Created by wallace-leung on 15/4/24.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    [self.view addSubview:btn];
    [btn setTitle:@"Toggle Left" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"Toggle Right" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onClick1:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(id)sender
{
    [self.drawerController toggleDrawSide:EWDrawerSideLeft completion:^() {
        
    }];
}

- (void)onClick1:(id)sender
{
    [self.drawerController toggleDrawSide:EWDrawerSideRight completion:nil];
}

@end
