//
//  LYHCollectionViewController.m
//  LYHCollectionViewController
//
//  Created by Charles Leo on 14-10-1.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHCollectionViewController.h"
#import "LYHCollectionViewCell.h"
#import "LYHCollectionViewLayout.h"
@interface LYHCollectionViewController ()
@property (nonatomic,assign) NSInteger count;
@end

@implementation LYHCollectionViewController
static NSString * CellIndentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(userDidPressTrashButton:)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(userDidPressAddButton:)];
    
    [self.collectionView registerClass:[LYHCollectionViewCell class] forCellWithReuseIdentifier:CellIndentifier];
}

- (void)userDidPressAddButton:(id)sender{
 [self.collectionView performBatchUpdates:^{
     [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count inSection:0]]];
     self.count++;
     self.navigationItem.rightBarButtonItem.enabled = self.count < 16;
     self.navigationItem.leftBarButtonItem.enabled = YES;
 } completion:nil];
    
}

-(void)userDidPressTrashButton:(id)sender{
    LYHCollectionViewLayout * layout = (LYHCollectionViewLayout *)self.collectionViewLayout;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [layout detachItemAtIndexPath:[NSIndexPath indexPathForItem:self.count - 1 inSection:0] completion:^{
        self.count--;
        self.navigationItem.leftBarButtonItem.enabled = self.count > 0;
        self.navigationItem.rightBarButtonItem.enabled = self.count < 16;
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYHCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    NSString * imageName = [NSString stringWithFormat:@"%d.jpg",indexPath.row % 16];
    [cell setImage:[UIImage imageNamed:imageName]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
