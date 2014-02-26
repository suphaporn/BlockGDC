//
//  louizViewController.m
//  gomeekitest
//
//  Created by louiz on 2/26/2557 BE.
//  Copyright (c) 2557 louiz. All rights reserved.
//

#import "louizViewController.h"

@interface louizViewController ()

@end

@implementation louizViewController
@synthesize dicObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    CGRect display2 = CGRectMake([[UIScreen mainScreen] applicationFrame].size.width/4,display1.origin.y+display1.size.height,[[UIScreen mainScreen] applicationFrame].size.width/2 , [[UIScreen mainScreen] applicationFrame].size.width/2);
    
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
    [self configureView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
