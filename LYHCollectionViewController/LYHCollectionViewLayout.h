//
//  LYHCollectionViewLayout.h
//  LYHCollectionViewController
//
//  Created by Charles Leo on 14-10-1.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHCollectionViewLayout : UICollectionViewLayout
-(void)detachItemAtIndexPath:(NSIndexPath *)indexPath completion:(void(^)(void))completion;
@end
