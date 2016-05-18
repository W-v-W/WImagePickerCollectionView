//
//  ViewController.m
//  WImagePickerCollectionView
//
//  Created by Zhibo Wang on 16/5/18.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "ViewController.h"
#import "WImagePickerCollectionView.h"

@interface ViewController ()<WImagePickerCollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WImagePickerCollectionView *cv = [[WImagePickerCollectionView alloc]initWithFrame:CGRectMake(20, 100, 280, 100) itemSize:CGSizeMake(90, 100) lineSpace:5 itemsCountInRow:3 maxCount:9 owner:self];
    cv.heightDelegate = self;
    [self.view addSubview:cv];
}

-(void)collectionView:(WImagePickerCollectionView *)collectionView shouldUpdateHeight:(CGFloat)newHeight{
    NSLog(@"new Height : %.2f", newHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
