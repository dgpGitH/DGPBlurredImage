//
//  ViewController.m
//  PulldownBlurredImage
//
//  Created by 戴国平 on 16/7/21.
//  Copyright © 2016年 dgp. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.blurredImage = [[DGPBlurredImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    
    self.tableView.tableHeaderView = self.blurredImage;
    
    [self.view addSubview:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.blurredImage updateHeaderView:scrollView.contentOffset];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIde = @"cellIde";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
