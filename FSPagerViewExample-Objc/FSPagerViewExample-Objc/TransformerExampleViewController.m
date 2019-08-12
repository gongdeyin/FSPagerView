//
//  TransformerExampleViewController.m
//  FSPagerViewExample-Objc
//
//  Created by Wenchao Ding on 19/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

#import "TransformerExampleViewController.h"
#import "FSPagerViewExample_Objc-Swift.h"
#import "FSPagerViewObjcCompat.h"

@interface TransformerExampleViewController () <UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (strong, nonatomic) NSArray<NSString *> *transformerNames;
@property (assign, nonatomic) NSInteger typeIndex;

@property (weak  , nonatomic) IBOutlet UITableView *tableView;
@property (weak  , nonatomic) IBOutlet FSPagerView *pagerView;

@end

@implementation TransformerExampleViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
    self.transformerNames = @[@"cross fading", @"zoom out", @"depth", @"linear", @"overlap", @"ferris wheel", @"inverted ferris wheel", @"coverflow", @"cubic"];
    [self.pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.pagerView.isInfinite = NO;
    self.typeIndex = 5;
   
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.typeIndex = self.typeIndex;
//    [self.pagerView selectItemAtIndex:3 animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transformerNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.transformerNames[indexPath.row];
    cell.accessoryType = indexPath.row == self.typeIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.typeIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Transformers";
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView
{
    return self.imageNames.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
}

#pragma mark - Private properties

- (void)setTypeIndex:(NSInteger)typeIndex
{
    _typeIndex = typeIndex;
    FSPagerViewTransformerType type;
    switch (typeIndex) {
        case 0: {
            type = FSPagerViewTransformerTypeCrossFading;
            break;
        }
        case 1: {
            type = FSPagerViewTransformerTypeZoomOut;
            break;
        }
        case 2: {
            type = FSPagerViewTransformerTypeDepth;
            break;
        }
        case 3: {
            type = FSPagerViewTransformerTypeLinear;
            break;
        }
        case 4: {
            type = FSPagerViewTransformerTypeOverlap;
            break;
        }
        case 5: {
            type = FSPagerViewTransformerTypeFerrisWheel;
            break;
        }
        case 6: {
            type = FSPagerViewTransformerTypeInvertedFerrisWheel;
            break;
        }
        case 7: {
            type = FSPagerViewTransformerTypeCoverFlow;
            break;
        }
        case 8: {
            type = FSPagerViewTransformerTypeCubic;
            break;
        }
        default:
            type = FSPagerViewTransformerTypeZoomOut;
            break;
    }
    self.pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:type];
    switch (type) {
        case FSPagerViewTransformerTypeCrossFading:
        case FSPagerViewTransformerTypeZoomOut:
        case FSPagerViewTransformerTypeDepth: {
            self.pagerView.itemSize = FSPagerViewAutomaticSize;
            self.pagerView.decelerationDistance = 1;
            break;
        }
        case FSPagerViewTransformerTypeLinear: //这里是横线放大效果
        case FSPagerViewTransformerTypeOverlap: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.6, 0.75);
            //size必须配置
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            //这是参数是减速效果可以不管
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            break;
        }
        case FSPagerViewTransformerTypeFerrisWheel: //这是我们要的弧形运动效果
        case FSPagerViewTransformerTypeInvertedFerrisWheel: {
            //size必须配置
            self.pagerView.itemSize = CGSizeMake(180, 140);
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            //配置弧形半径
            self.pagerView.transformer.ferrisWheelRadius = 6.0;
            //正常卡片大小
            self.pagerView.transformer.minimumScale = 1.0;
            //中间放大倍数
            self.pagerView.transformer.maxScale = 1.3;
            //围绕旋转半径
            self.pagerView.transformer.ferrisWheelRadius = 2200;
            break;
        }
        case FSPagerViewTransformerTypeCoverFlow: {
            self.pagerView.itemSize = CGSizeMake(220, 170);
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            break;
        }
        case FSPagerViewTransformerTypeCubic: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            self.pagerView.decelerationDistance = 1;
            break;
        }
        default:
            break;
    }
}

@end


