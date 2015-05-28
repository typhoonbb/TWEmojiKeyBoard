//
//  TWEmojiKeyBoard.h
//  Supermacy
//
//  Created by Taylor on 15/5/27.
//  Copyright (c) 2015年 Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWEmojiKeyBoard : NSObject<UIScrollViewDelegate,UIGestureRecognizerDelegate>


-(void)createEmojiKeyBoard;

-(void)bindKeyBoardWithTextField:(UITextField*)textField;

-(void)unbindKeyBoard;

@end
