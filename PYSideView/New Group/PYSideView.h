//
//  PYSideView.h
//  PYSideView
//
//  Created by yang.pu on 2019/7/31.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    sideFrom_left,
    sideFrom_bottom
} sideFrom;

typedef enum : NSUInteger {
    sideMove_default,
    sideMove_together
} sideMoveType;

@protocol SideViewDelegate <NSObject>
@optional
//自定义上方的NAV样式
- (UIView *)sideView_NavView:(UIView *)navView;
- (CGFloat)sideView_navViewHeight;//nav高度

//- (void)sideViewSelectItemUIModel:(nullable __kindof FJRUIModel *)uiModel;
//- (void)sideViewSelectSubElementInItemUIModel:(nullable __kindof FJRUIModel *)itemUIModel
//                               indexOfElement:(NSUInteger)index
//                                   extraParma:(nullable id)parma;
- (void)sideViewClickView:(nullable id)data fromVC:(NSString *)fromVC;

//视图开始上滑
- (void)sideViewBeginMoveDirectionTag:(NSInteger)DirectionTag fromVC:(NSString *)fromVC;//1：上 2：下，暂时先简单写了，以后调整
@end

@interface PYSideView : UIView
@property (nonatomic, weak) id<SideViewDelegate> delegate;

@property (nonatomic, assign) CGFloat navViewHeight;//nav高度

@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *subTitle;//子标题
@property (nonatomic, strong) UIImage *closeImg;//右侧关闭按钮图片

+ (PYSideView *)defaultFJRSideView;

- (void)closeSideView;

@end

NS_ASSUME_NONNULL_END
