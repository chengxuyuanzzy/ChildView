//
//  ViewController.m
//  ChildViewTest
//
//  Created by 朱忠阳 on 2017/4/18.
//  Copyright © 2017年 朱忠阳. All rights reserved.
//

#import "ViewController.h"
#import "TitleLabel.h"
#import "TitleTableView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) TitleLabel *titleLabel;
@property (nonatomic, strong) TitleTableView *titleTableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *backScrollView;

@end

@implementation ViewController

- (NSArray *)array {
    if (!_array) {
        _array = @[@"第一个页面", @"第二个页面", @"第三个页面", @"第四个页面"];
    }
    return _array;
}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
    }
    return _backScrollView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 添加标题 */
    [self addTitleLabel];
    /** 添加底部view */
    [self addScrollView];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma - 添加标题
- (void)addTitleLabel {
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    [self.view addSubview:_titleView];
    
    for (int i=0; i<self.array.count; i++) {
        CGFloat labelW = 100;
        CGFloat labelH = 40;
        CGFloat labelY = 0;
        CGFloat labelX = i * labelW;
        TitleLabel *titleLabel = [[TitleLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        titleLabel.text = self.array[i];
        titleLabel.tag = i;
        [self.titleView addSubview:titleLabel];
        
        /** 给标题添加点击事件 */
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    TitleLabel *titleLabel = (TitleLabel *)recognizer.view;
    CGFloat offsetX = titleLabel.tag * self.view.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.backScrollView setContentOffset:offset animated:YES];
    
    [self changeTabelView:titleLabel.tag];
}
#pragma - 更换tableView
- (void)changeTabelView:(NSInteger)index {
    TitleTableView *tableView = self.childViewControllers[index];
    tableView.view.frame = self.backScrollView.bounds;
    [self.backScrollView addSubview:tableView.view];
}
#pragma - 添加底部view
- (void)addScrollView {
    for (int i=0; i<self.array.count; i++) {
        TitleTableView *titleTableView = [[TitleTableView alloc] initWithStyle:UITableViewStylePlain];
        titleTableView.contentString = self.array[i];
        [self addChildViewController:titleTableView];
    }
    self.backScrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.backScrollView.contentSize = CGSizeMake(contentX, 0);
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.delegate = self;
    [self.view addSubview:self.backScrollView];
    /** 添加默认控制器 */
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.backScrollView.bounds;
    [self.backScrollView addSubview:vc.view];
    
    TitleLabel *titleLabel = [self.titleView.subviews firstObject];
    titleLabel.scale = 1.0;
    
    self.titleTableView = self.childViewControllers[0];
}
#pragma - scrllView delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.backScrollView.frame.size.width;
    [self changeTabelView:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 取出绝对值 避免最左边往右拉时变形超过1 */
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    NSLog(@"value=%f, leftIndex=%ld, rightIndex=%ld, scaleRight=%f, scaleLeft=%f", value, leftIndex, rightIndex, scaleRight, scaleLeft);
    TitleLabel *labelLeft = self.titleView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    if (rightIndex < self.titleView.subviews.count) {
        TitleLabel *labelRihgt = self.titleView.subviews[rightIndex];
        labelRihgt.scale = scaleRight;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
