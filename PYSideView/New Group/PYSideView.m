//
//  PYSideView.m
//  PYSideView
//
//  Created by yang.pu on 2019/7/31.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import "PYSideView.h"
#import <Masonry/Masonry.h>

#define SideView_MoveHeight ([UIScreen mainScreen].bounds.size.height*0.6)

@interface PYSideView ()
//@property (nonatomic, strong) FJRSideViewController *sideVC;
@property (nonatomic, strong) UIView *backTapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *vcView;
@property (nonatomic, strong) UIView *toView;

@property (nonatomic, assign) sideFrom sideFrom;
@property (nonatomic, assign) sideMoveType sideMoveType;
//

@property (nonatomic, strong) UIViewController *VC;

@property (nonatomic, strong) UILabel *titleLab;//标题
@property (nonatomic, strong) UILabel *subTitleLab;//子标题

@end

@implementation PYSideView

+ (PYSideView *)defaultFJRSideView{
    PYSideView *sideView = [[PYSideView alloc] init];
    sideView.sideMoveType = sideMove_default;
    sideView.sideFrom = sideFrom_bottom;
    sideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    return sideView;
}

- (void)ShowSideViewMoveType:(sideMoveType)sideMoveType sideFrom:(sideFrom)sideFrom toView:(UIView *)toView vcName:(NSString *)vcName vcParams:(nullable NSDictionary *)params{
    
    self.sideMoveType = sideMoveType;
    self.sideFrom = sideFrom;
    self.toView = toView;
    [self setSubviews:vcName vcParams:params];
    
    if (sideMoveType == sideMove_together) {
        
//        toView.fjr_height = toView.fjr_height + SideView_MoveHeight;
//        toView.backgroundColor = [UIColor purpleColor];
    }
    
    [toView addSubview:self];
    //    sideView.frame = toView.frame;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    if (sideMoveType && sideMoveType == sideMove_together) {
//        [UIView animateWithDuration:0.3 animations:^{
//            toView.fjr_y = - SideView_MoveHeight;
//        }];
    }else{
        [self animationToStart];
    }
}

- (void)setSubviews:(NSString *)vcName vcParams:(NSDictionary *)params{
    [self addSubview:self.backTapView];
    [self.backTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.sideMoveType && self.sideMoveType == sideMove_together) {//整体上移
            make.left.right.bottom.offset(0);
            make.height.offset(SideView_MoveHeight);
        }else{//仅下面视图上移
            make.left.right.offset(0);
            make.top.equalTo(self.mas_bottom);
            make.height.offset(SideView_MoveHeight);
        }
    }];
    
    if (vcName) {
        Class class = NSClassFromString(vcName);
        self.VC = [class alloc];
        
        NSString* targetInstanceSelStr = [NSString stringWithFormat:@"initWithExtraParam:"];
        SEL targetInstanceSelector = NSSelectorFromString(targetInstanceSelStr);
        SEL sideInitSelector = NSSelectorFromString(@"init");
        if ([self.VC respondsToSelector:NSSelectorFromString(targetInstanceSelStr)]) {
            IMP targetInstanceImp = [self.VC methodForSelector:targetInstanceSelector];
            void (*targetInstanceFunction)(id, SEL, NSDictionary *) = (void*)targetInstanceImp;
            targetInstanceFunction(self.VC, targetInstanceSelector, params);
        }else if ([self.VC respondsToSelector:NSSelectorFromString(@"init")]){
            IMP sideInstanceImp = [self.VC methodForSelector:sideInitSelector];
            void (*targetInstanceFunction)(id, SEL, NSString *) = (void*)sideInstanceImp;
            targetInstanceFunction(self.VC, sideInitSelector, @"");
        }
        
        [self.contentView addSubview:self.VC.view];
        
        [self.VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.equalTo(self.navView.mas_bottom);
        }];
        
        //内容的点击事件
//        @weakify(self)
//        self.VC.sideItemSelectBlock = ^(FJRUIModel *uiModel) {
//            @strongify(self)
//            if (self.delegate && [self.delegate respondsToSelector:@selector(sideViewSelectItemUIModel:)]) {
//                [self.delegate sideViewSelectItemUIModel:uiModel];
//            }
//        };
//
//        self.VC.sideSubElementSelectBlock = ^(FJRUIModel *uiModel, NSUInteger index, id param) {
//            @strongify(self)
//            if (self.delegate && [self.delegate respondsToSelector:@selector(sideViewSelectSubElementInItemUIModel:indexOfElement:extraParma:)]) {
//                [self.delegate sideViewSelectSubElementInItemUIModel:uiModel indexOfElement:index extraParma:param];
//            }
//        };
//
//        self.VC.sideClickBlock = ^(id data) {
//            @strongify(self)
//            if (self.delegate && [self.delegate respondsToSelector:@selector(sideViewClickView:fromVC:)]) {
//                [self.delegate sideViewClickView:data fromVC:vcName];
//            }
//        };
//
//        //数据赋值
//        self.VC.sideNavDataBlock = ^(id data) {
//            @strongify(self)
//            NSDictionary *dataDic = [data objectForKey:@"data"];
//            self.topIcon = [[dataDic objectForKey:@"icon"] objectForKey:@"url"];//装扮大
//            self.title = [dataDic objectForKey:@"title"];
//            self.subTitle = [dataDic objectForKey:@"subTitle"];
//            self.closeImg = [UIImage imageNamed:@""];
//            [self setNavViewData];
//        };
    }
    
}

- (void)animationToStart{
    switch (self.sideFrom) {
        case sideFrom_left:
            
            break;
        case sideFrom_bottom:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sideViewBeginMoveDirectionTag:fromVC:)]) {
                [self.delegate sideViewBeginMoveDirectionTag:1 fromVC:NSStringFromClass(self.VC.class)];
            }
            
            [self layoutIfNeeded];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset([UIScreen mainScreen].bounds.size.height*0.4);
            }];
            
            //            if (self.sideMoveType && self.sideMoveType == sideMove_together) {
            //                [self.toView updateConstraints:^(MASConstraintMaker *make) {
            //                    make.top.offset(200 - 667);
            //                }];
            //            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)closeBtn:(UIButton *)button{
    if (self.sideMoveType == sideMove_together) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.toView.fjr_y = 0;
//            self.toView.fjr_height = [FJRScreen sharedInstance].height;
//            self.fjr_y = 0;
//            self.fjr_height = [FJRScreen sharedInstance].height;
//        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideViewBeginMoveDirectionTag:fromVC:)]) {
        [self.delegate sideViewBeginMoveDirectionTag:2 fromVC:NSStringFromClass(self.VC.class)];
    }
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.mas_bottom);
        make.height.offset(SideView_MoveHeight);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.VC.view removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)closeSideView{
    [self closeBtn:nil];
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        
        [_contentView addSubview:self.navView];
        [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            if (self.delegate && [self.delegate respondsToSelector:@selector(sideView_navViewHeight)]) {
                make.height.offset([self.delegate sideView_navViewHeight]);
            }else{
                make.height.offset(self.navViewHeight ?: 95);
            }
            
        }];
        
        //圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 95) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 95);
        maskLayer.path = maskPath.CGPath;
        self.navView.layer.mask = maskLayer;
        
    }
    return _contentView;
}

- (UIView *)navView{
    if (!_navView) {
        _navView = [UIView new];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideView_NavView:)]) {
            _navView = [self.delegate sideView_NavView:_navView];
        }else{
//            _navView.backgroundColor = FJRRGB(@"#FFFFFF");
            
            self.titleLab = [UILabel new];
            self.titleLab.font = [UIFont systemFontOfSize:14 weight:1];
            [_navView addSubview:self.titleLab];
            
            self.subTitleLab = [UILabel new];
            self.subTitleLab.font = [UIFont systemFontOfSize:12];
            [_navView addSubview:self.subTitleLab];
            
            [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.top.bottom.offset(0);
                make.height.offset(20);
                make.bottom.lessThanOrEqualTo(self.subTitleLab.mas_top).offset(-5);
                make.left.offset(20);
                make.right.offset(-20);
            }];
            
            self.titleLab.text = self.title ?: @"";
            self.titleLab.textAlignment = NSTextAlignmentLeft;
//            self.titleLab.textColor = [[FJRColor sharedInstance] colorWithString:@"#333333"];
            
            self.subTitleLab.text = self.subTitle ?: @"";
//            self.subTitleLab.textColor = [[FJRColor sharedInstance] colorWithString:@"#999999"];
            [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.offset(-20);
                make.bottom.offset(-12);
            }];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_navView addSubview:closeBtn];
            
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(12));
                make.right.offset(-12);
                make.size.sizeOffset(CGSizeMake(24, 24));
            }];
            
            [closeBtn setImage:self.closeImg ?: [UIImage imageNamed:@"关闭_sideView"] forState:UIControlStateNormal];
            [closeBtn setImage:self.closeImg ?: [UIImage imageNamed:@"关闭_sideView"] forState:UIControlStateHighlighted];
            [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *lineView = [UIView new];
//            lineView.backgroundColor = [[FJRColor sharedInstance] colorWithString:@"#DFDFDF"];
            [_navView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.right.offset(-20);
                make.bottom.offset(0);
                make.height.offset(0.5);
            }];
        }
    }
    return _navView;
}

@end
