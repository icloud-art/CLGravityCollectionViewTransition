//
//  LYHCollectionViewLayout.m
//  LYHCollectionViewController
//
//  Created by Charles Leo on 14-10-1.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHCollectionViewLayout.h"

static CGFloat kItemSize = 150.0f;
#define attachmentPoint CGPointMake(CGRectGetMidX(self.collectionView.bounds), 64)
@interface LYHCollectionViewLayout()
@property (strong,nonatomic) UIDynamicAnimator * dynamicAnimator;
@property (weak,nonatomic) UIGravityBehavior * gravityBehaviour;
@property (weak,nonatomic) UICollisionBehavior * collisionBehaviour;
@end

@implementation LYHCollectionViewLayout
-(id)init{
    if (self = [super init]) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithCollectionViewLayout:self];
        //重力行为
        UIGravityBehavior * gravityBehaviour = [[UIGravityBehavior alloc]initWithItems:@[]];
        gravityBehaviour.gravityDirection = CGVectorMake(0, 1);
        self.gravityBehaviour = gravityBehaviour;
        [self.dynamicAnimator addBehavior:gravityBehaviour];
        //碰撞行为
        UICollisionBehavior * collisionBehaviour = [[UICollisionBehavior alloc]initWithItems:@[]];
        [self.dynamicAnimator addBehavior:collisionBehaviour];
        self.collisionBehaviour = collisionBehaviour;
    }
    return self;
    
}

-(CGSize)collectionViewContentSize{
    return self.collectionView.bounds.size;
}


-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem * updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
            attributes.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame) + kItemSize, 100, kItemSize, kItemSize);
            
            UIAttachmentBehavior * attachmentBehaviour = [[UIAttachmentBehavior alloc]initWithItem:attributes attachedToAnchor:attachmentPoint];
            attachmentBehaviour.length = 300;
            attachmentBehaviour.damping = 0.4;//阻尼
            attachmentBehaviour.frequency = 1.0f;
            [self.dynamicAnimator addBehavior:attachmentBehaviour];
            [self.gravityBehaviour addItem:attributes];
            [self.collisionBehaviour addItem:attributes];
        }
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


- (void)detachItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion{
    __block UIAttachmentBehavior * attachmentBehaviour;
    __block UICollectionViewLayoutAttributes * attributes;
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIAttachmentBehavior class]]) {
            if ([[[obj items].firstObject indexPath]isEqual:indexPath]) {
                attachmentBehaviour = obj;
                attributes = [[obj items] firstObject];
                * stop = YES;
            }
        }
    }];
    
    [self.dynamicAnimator removeBehavior:attachmentBehaviour];
    
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collisionBehaviour removeItem:attributes];
        [self.gravityBehaviour removeItem:attributes];
        [self.collectionView performBatchUpdates:^{
            completion();
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    });
}


@end
