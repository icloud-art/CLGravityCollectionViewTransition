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
    //NSString * imageName = [NSString stringWithFormat:@"%ld.jpg",indexPath.row % 16];
    
    NSArray * array = @[@"http://c.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2e9bd1c57f4dc2d562843568dc.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/d833c895d143ad4bd79b97c480025aafa40f0678.jpg",@"http://c.hiphotos.baidu.com/image/pic/item/6609c93d70cf3bc745c21ce8d300baa1cc112af0.jpg",@"http://b.hiphotos.baidu.com/image/w%3D230/sign=8ccd1468123853438ccf8022a312b01f/91ef76c6a7efce1b24f12fcead51f3deb58f65d8.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/95eef01f3a292df535a659dabe315c6035a8739c.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/d043ad4bd11373f01d4f169da70f4bfbfbed04bb.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/b7003af33a87e950eb5cbb5c13385343fbf2b4b3.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/1b4c510fd9f9d72a97867315d62a2834359bbbdc.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/9d82d158ccbf6c81bb5e74e2be3eb13533fa404a.jpg",@"http://b.hiphotos.baidu.com/image/pic/item/bba1cd11728b47107846ccfac1cec3fdfc03239e.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/e61190ef76c6a7efe10bc6ddfffaaf51f3de661f.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/48540923dd54564e0f63d53cb1de9c82d1584fb4.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/cc11728b4710b91206f93bfac1fdfc03924522fe.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a29013e399c9ef76094a369ad8.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/4e4a20a4462309f7f8244a16700e0cf3d7cad66f.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/0b7b02087bf40ad12dbf21e7552c11dfa9ecce5f.jpg"];
    //异步加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *  url = [array objectAtIndex:self.count-1];
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage * image = [[UIImage alloc]initWithData:data];
        if (image != nil) {
            //回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, image.size.height/2, image.size.width/3);
                [cell setImage:image];
                NSLog(@"height is %f width is %f",image.size.height,image.size.width);
                NSLog(@"异步加载一张美女图!");
            });
        }
    });
    //[cell setImage:[UIImage imageNamed:imageName]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
