//
//  TWEmojiKeyBoard.h
//  Supermacy
//
//  Created by Taylor on 15/5/27.
//  Copyright (c) 2015年 Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWEmojiKeyBoard : NSObject<UIScrollViewDelegate,UIGestureRecognizerDelegate>

//创建keyBoard
-(void)createEmojiKeyBoard;

//绑定自定义键盘
-(void)bindKeyBoardWithTextField:(UITextField*)textField;

//取消绑定
-(void)unbindKeyBoard;

@end
