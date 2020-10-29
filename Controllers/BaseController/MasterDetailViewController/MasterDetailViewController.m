//
//  MasterDetailViewController.m
//  Loopocity
//
//  Created by Hossam Ghareeb on 2/1/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import "MasterDetailViewController.h"
#import "AbstractViewController.h"
@interface MasterDetailViewController ()

@end

@implementation MasterDetailViewController
@synthesize ignoreAddMainMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
      delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AbstractViewController *leftMenu = [self.storyboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"LeftViewStoryboard" : @"LeftViewStoryboardiPhone")];
   leftMenu.masterDetailViewController = self;
    self.leftDrawerViewController = leftMenu;
    if(!ignoreAddMainMenu)
   {
       AbstractViewController *loopView = [self.storyboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"MainViewStoryboard" : @"MainViewStoryboardiPhone")];
       
       loopView.masterDetailViewController = self;
       
       self.centerViewController = loopView;
   }
    
    self.rightDrawerViewController = nil;
    if(!(IPAD_VERSION)) {
        self.maximumLeftDrawerWidth = 300;
    }
    else {
        self.maximumLeftDrawerWidth = 480;
    }
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)setCenterViewControllerWithMasterDetail:(AbstractViewController *)centerViewController
{
    centerViewController.masterDetailViewController = self;
    self.centerViewController = centerViewController;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//-(void)openLoginView
//{
//    delegate.checking=@"yes";
//    [self performSegueWithIdentifier:sender:self];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
