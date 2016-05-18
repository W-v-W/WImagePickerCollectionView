//
//  WImagePickerCollectionViewCell.m
//  YunJiaHui
//
//  Created by Zhibo Wang on 16/5/18.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WImagePickerCollectionViewCell.h"
#import "WImagePickerCollectionView.h"
#import "WButton.h"

@interface WImagePickerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet WButton *btnDelete;

@end

@implementation WImagePickerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCellImage:(UIImage *)cellImage{
    self.btnDelete.hidden = !self.picker.deletable;
    self.iv.image = cellImage;
    _cellImage = cellImage;
}

- (IBAction)deleteImage:(id)sender {
    [self.picker deleteCell:self];
}


@end
