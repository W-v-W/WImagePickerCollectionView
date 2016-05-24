//
//  WImagePickerCollectionView.h
//  YunJiaHui
//
//  Created by Zhibo Wang on 16/5/18.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WImagePickerCollectionView;
@protocol WImagePickerCollectionViewDelegate <NSObject>
@optional
-(void)collectionView:(WImagePickerCollectionView *)collectionView shouldUpdateHeight:(CGFloat)newHeight;
@end


@class WImagePickerCollectionViewCell;
@interface WImagePickerCollectionView : UICollectionView

@property(nonatomic, weak)UIViewController *owner;
@property(nonatomic, weak)id<WImagePickerCollectionViewDelegate> heightDelegate;
@property(nonatomic, readonly, strong)NSMutableArray *images; //picked images
@property(nonatomic, assign)BOOL deletable; // default is YES.
@property(nonatomic, assign)BOOL isCompleted;


-(instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize lineSpace:(CGFloat)lineSpace itemsCountInRow:(NSUInteger)count maxCount:(NSUInteger) maxCount owner:(UIViewController *)owner;


-(void)deleteCell:(WImagePickerCollectionViewCell *)cell;



@end
