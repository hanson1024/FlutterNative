//
//  ViewController.m
//  FlutterDemo0929
//
//  Created by luo on 2019/9/29.
//  Copyright © 2019 hanson. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import <Flutter/Flutter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)download:(UIButton *)sender {
    
    
}
    
- (IBAction)check:(UIButton *)sender {
    
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self presentViewController:flutterViewController animated:YES completion:nil];
}
    
@end
