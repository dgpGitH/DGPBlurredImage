//
//  ViewController.h
//  PulldownBlurredImage
//
//  Created by 戴国平 on 16/7/21.
//  Copyright © 2016年 dgp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGPBlurredImage.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DGPBlurredImage *blurredImage;

@end

