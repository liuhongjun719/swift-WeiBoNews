//
//  HJPlayerControlView.h
//  WeiBoNews
//
//  Created by 123456 on 16/11/15.
//  Copyright © 2016年 123456. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ASValueTrackingSlider.h"
//#import "ZFPlayer.h"

typedef void(^ChangeResolutionBlock)(UIButton *button);
typedef void(^SliderTapBlock)(CGFloat value);

typedef void (^FullScreenBtnDidClickedBlock)(UIButton *button);

@interface HJPlayerControlView : UIView

/** 分辨率的名称 */
@property (nonatomic, strong) NSArray               *resolutionArray  __deprecated_msg("Please implement 'zf_playerResolutionArray:' instead");
/** 切换分辨率的block */
@property (nonatomic, copy  ) ChangeResolutionBlock resolutionBlock __deprecated_msg("Please use ZFPlayerControlViewDelegate 'zf_controlView:resolutionAction:' instead");
/** slidertap事件Block */
@property (nonatomic, copy  ) SliderTapBlock        tapBlock __deprecated_msg("Please use ZFPlayerDelegate 'zf_controlView:progressSliderTap:' instead");

/**点击全屏按钮*/
@property(nonatomic, copy) FullScreenBtnDidClickedBlock fullScreenBtnDidClickedBlock;



@end
