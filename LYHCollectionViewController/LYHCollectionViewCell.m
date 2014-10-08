//
//  LYHCollectionViewCell.m
//  LYHCollectionViewController
//
//  Created by Charles Leo on 14-10-1.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHCollectionViewCell.h"

@interface LYHCollectionViewCell()

@end

@implementation LYHCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, 5, 5)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
    }
    return self;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
