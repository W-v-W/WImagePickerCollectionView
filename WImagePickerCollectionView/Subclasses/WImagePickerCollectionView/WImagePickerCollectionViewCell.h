//
//  WImagePickerCollectionViewCell.h
//  YunJiaHui
//
//  Created by Zhibo Wang on 16/5/18.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WImagePickerCollectionView;

@interface WImagePickerCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak)WImagePickerCollectionView *picker;

@property(nonatomic, strong)UIImage *cellImage;

@end
