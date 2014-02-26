//
//  louizDetailViewController.m
//  gomeekitest
//
//  Created by louiz on 2/26/2557 BE.
//  Copyright (c) 2557 louiz. All rights reserved.
//

#import "louizDetailViewController.h"

@interface louizDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation louizDetailViewController
@synthesize dicObject;


- (void)loadView
{
    
    // Set your custom view
    UIView *cView = [[UIView alloc] initWithFrame:CGRectZero];
    cView.backgroundColor = [UIColor whiteColor];
    self.view = cView;
    
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    }
    
    [super awakeFromNib];
}


- (void)configureView
{
    // Update the user interface for the detail item.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *contentid = [NSString stringWithFormat:@"http://mobiletest.gomeekisystems.com/%@.json",[dicObject objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:contentid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error;
    NSMutableDictionary *allCourses = [NSJSONSerialization
                                       JSONObjectWithData:response
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    NSString *status =[[allCourses objectForKey:@"status"]objectForKey:@"code"];
    
    CGRect display1 = CGRectMake(0, 60, [[UIScreen mainScreen] applicationFrame].size.width, 30);
    
    CGRect display2 = CGRectMake(0,display1.origin.y+display1.size.height,200 , 200);
    
    CGRect display3 = CGRectMake(0, display2.size.height+10,[[UIScreen mainScreen] applicationFrame].size.width , [[UIScreen mainScreen] applicationFrame].size.height-display1.size.height-display2.size.height);
    
    if ([status isEqualToString:@"200"]) {
        //NSLog(@"%@",allCourses);
        
        NSString *strTitle = [[allCourses objectForKey:@"data"] objectForKey:@"title"];
        NSString *strHtml = [[allCourses objectForKey:@"data"] objectForKey:@"content"];
        NSString *strImage =  [NSString stringWithFormat:@"http://mobiletest.gomeekisystems.com/%@",[[allCourses objectForKey:@"data"]objectForKey:@"image"]];
        
        //
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:display1];
        [lblTitle setText:strTitle];
        
        [self.view addSubview:lblTitle];
        
        //image
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:display2];
        [self.view addSubview:imgView];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            //NSString *strImage = [NSString stringWithFormat:strImage];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [imgView setImage:image];
                
            });
        });
        
        
        //webview
        UIWebView *webVC = [[UIWebView alloc] initWithFrame:display3];
        
        [webVC loadHTMLString:strHtml baseURL:nil];
        [webVC setDelegate:self];
        
        [self.view addSubview:webVC];
    
        
        
    }

   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
