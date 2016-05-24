//
//  WImagePickerCollectionView.m
//  YunJiaHui
//
//  Created by Zhibo Wang on 16/5/18.
//  Copyright © 2016年 Zhibo Wang. All rights reserved.
//

#import "WImagePickerCollectionView.h"
#import "WImagePickerCollectionViewCell.h"


@interface WImagePickerCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, readwrite, strong)NSMutableArray *images;

@property(nonatomic, strong)UIImagePickerController *imagePicker;

@property(nonatomic, assign)NSInteger maxCount;
@property(nonatomic, assign)NSInteger itemsCountInRow;
@property(nonatomic, assign)CGSize itemSize;
@property(nonatomic, assign)CGFloat lineSpace;

@property(nonatomic, assign)NSInteger priorRows;    //The number of rows


@end

@implementation WImagePickerCollectionView

// Toggle the completion status, hide or show the Add button and the delete button
// When the state  changes, it would also change deletable property;
-(void)setIsCompleted:(BOOL)isCompleted{
    if (_isCompleted == isCompleted) {
        return;
    }else{
        _isCompleted = isCompleted;
        self.deletable = !isCompleted;
    }
}

//
-(void)setDeletable:(BOOL)deletable{
    _deletable = deletable;
    [self reloadData];  //
}

-(void)deleteCell:(WImagePickerCollectionViewCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    [self.images removeObject:cell.cellImage];
    [self deleteItemsAtIndexPaths:@[indexPath]];

    [self updateHeight];
}


#pragma mark - initailizer

-(instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize lineSpace:(CGFloat)lineSpace itemsCountInRow:(NSUInteger)count maxCount:(NSUInteger)maxCount owner:(UIViewController *)owner{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = lineSpace;
    
    NSAssert(count > 0, @"必须大于等于1");
    if(count == 1){
        layout.minimumInteritemSpacing = 0;
    }else{
        layout.minimumInteritemSpacing = (frame.size.width - (itemSize.width * count))/(count - 1);
    }
    
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.itemsCountInRow = count;
        self.maxCount = (maxCount > 1 ? maxCount : 1);
        self.itemSize = itemSize;
        self.lineSpace = lineSpace;
        
        self.owner = owner;
        
        self.images = [NSMutableArray array];
        self.priorRows = 1;
        self.deletable = YES;
        
        [self registerNib:[UINib nibWithNibName:@"WImagePickerCollectionViewCell"bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        
        [self registerNib:[UINib nibWithNibName:@"WImagePickerCollectionViewPlusCell" bundle:nil] forCellWithReuseIdentifier:@"plusCell"];
    }
        
    return self;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num;
//    if (self.images.count < self.maxCount) {
        num = self.images.count + 1;
//    }else{
//        num = self.images.count;
//    }
    return num;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.images.count) {
        UICollectionViewCell *plusCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"plusCell" forIndexPath:indexPath];
        UIImageView *iv = [plusCell.contentView viewWithTag:1024];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plusAction)];
        [iv addGestureRecognizer:tap];
        
        if (self.isCompleted) {
            plusCell.hidden = YES;
        }else{
            plusCell.hidden = NO;
        }
        
        return plusCell;
    }else{
        WImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        cell.picker = self;
        cell.cellImage = self.images[indexPath.row];
        return cell;
    }
    
}

#pragma mark - action

-(void)plusAction{
    
    if(self.images.count == self.maxCount){
        return;
    }
    NSString *title = NSLocalizedString(@"method", nil);
    NSString *cancel = NSLocalizedString(@"cancel", nil);
    NSString *m1 = NSLocalizedString(@"album", nil);
    NSString *m2 = NSLocalizedString(@"camera", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:m1, m2, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.owner.view];
}



#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            [self pickImageWithSorceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            break;
        }
        case 1:{
            
            [self pickImageWithSorceType:UIImagePickerControllerSourceTypeCamera];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - image picker view delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.images addObject:image];
    
    [self updateHeight];
    
    [self reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getter overrite

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

#pragma mark -


-(void)pickImageWithSorceType:(UIImagePickerControllerSourceType) sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.sourceType = sourceType;
        [self.owner presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)updateHeight{
    NSInteger rows;
    if (self.images.count == self.maxCount) {
        rows = ceilf(self.images.count * 1.0 /self.itemsCountInRow);
    }else{
        rows = ceilf((self.images.count + 1) * 1.0 / self.itemsCountInRow);
    }
    
    if (rows != self.priorRows) {
        self.priorRows = rows;
        CGFloat newHeight = rows*(self.itemSize.height)+(rows-1)*self.lineSpace;
        self.frame = ({
            CGRect frame = self.frame;
            frame.size.height = newHeight;
            frame;
        });
        if ([self.heightDelegate respondsToSelector:@selector(collectionView:shouldUpdateHeight:)]) {
            [self.heightDelegate collectionView:self shouldUpdateHeight:newHeight];
        }
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
