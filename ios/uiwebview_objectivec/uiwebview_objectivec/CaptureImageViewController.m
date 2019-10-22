//
//  CaptureImageViewController.m
//  uiwebview_objectivec
//
//  Created by jinreol kim on 21/10/2019.
//  Copyright © 2019 jinreol kim. All rights reserved.
//

#import "CaptureImageViewController.h"

@interface CaptureImageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation CaptureImageViewController
@synthesize captureImage, imgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgView.image = captureImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
