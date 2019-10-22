//
//  ViewController.m
//  uiwebview_objectivec
//
//  Created by jinreol kim on 21/10/2019.
//  Copyright © 2019 jinreol kim. All rights reserved.
//

#import "ViewController.h"
#import "CaptureImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.webView.delegate = self;
    
    NSURL *targetURL = [NSURL URLWithString:@"http://10.17.119.151:8888/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:targetURL];
    
    [webView loadRequest:urlRequest];
    
    NSLog(@"viewDidLoad");

}

- (IBAction)actionManualSegue:(UIButton *)sender {
    NSLog(@"actionManualSegue2");
    [self performSegueWithIdentifier:@"SegueNext" sender:self];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"jscall:"]) {
        NSLog(@"from javascript requestString:%@", requestString);
        
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSString *parseString = [components objectAtIndex:1];
        
        NSLog(@"from javascript parseString:%@", parseString);
        
        NSString *decodedString = [parseString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"from javascript decodedString:%@", decodedString);
        
        NSData *jsonData = [decodedString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];

        NSLog(@"command = %@", [dict objectForKey:@"command"]);
        NSLog(@"data = %@", [dict objectForKey:@"data"]);
        
        NSString *strCommand = [dict objectForKey:@"command"];
        if ([strCommand isEqualToString:@"capture"]) {
            NSLog(@"to be capture!");
            //[self performSegueWithIdentifier:@"SegueNext" sender:self];
            
            NSLog(@"webView.bounds width:%f, height:%f", webView.bounds.size.width, webView.bounds.size.height);
            NSLog(@"webView.scrollView.contentSize width:%f, height:%f", webView.scrollView.contentSize.width, webView.scrollView.contentSize.height);
            
//            webView.scrollView.contentOffset = CGPointZero;
//            webView.scrollView.frame = CGRectMake(0, 0, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height);
            
            //NSLog(@"webView.scrollView.contentSize:%@", webView.scrollView.contentSize);
            UIImage *captureImage = [self captureWebView];
            UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);
            
        }
    }
    
    return YES;
}

- (UIImage *) captureWebView {
    
    CGPoint savedContentOffset = webView.scrollView.contentOffset;
    CGRect savedFrame = webView.scrollView.frame;
    
    UIGraphicsBeginImageContext(webView.scrollView.contentSize);
    
    webView.scrollView.contentOffset = CGPointZero;
    webView.scrollView.frame = CGRectMake(0, 0, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height);
    
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    webView.scrollView.contentOffset = savedContentOffset;
    webView.scrollView.frame = savedFrame;
    
    return viewImage;
}

//CaptureImageViewController
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueNext"]) {
        NSLog(@"prepareForSegue");
        CaptureImageViewController *viewController = [segue destinationViewController];
        viewController.captureImage = [self captureWebView];
    }
}
@end
