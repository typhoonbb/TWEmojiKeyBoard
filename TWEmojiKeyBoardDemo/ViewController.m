//
//  ViewController.m
//  TWEmojiKeyBoardDemo
//
//  Created by Taylor on 15/5/28.
//  Copyright (c) 2015年 Taylor. All rights reserved.
//

#import "ViewController.h"
#import "TWEmojiKeyBoard.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mTextField;
@property (weak, nonatomic) IBOutlet UIButton *switchTypeButton;

@end

@implementation ViewController

{

    BOOL isEmojiKeyBoard;
    TWEmojiKeyBoard *keyBoard;

}

- (IBAction)switchKeyBoardTypeAction:(UIButton *)sender {
    
    
    if (!isEmojiKeyBoard) {
        
        /**
         使用自定义键盘
         */
        isEmojiKeyBoard=YES;
        
        if (!keyBoard) {
            
            keyBoard=[[TWEmojiKeyBoard alloc]init];
            
            [keyBoard createEmojiKeyBoard];
            
        }
        
        [sender setImage:[UIImage imageNamed:@"btn_publish_keyboard_b"] forState:0];
        [keyBoard bindKeyBoardWithTextField:_mTextField];
        
        
    }else{
    
    
        /**
         *  使用系统默认的键盘
         */
        [keyBoard unbindKeyBoard];
        [sender setImage:[UIImage imageNamed:@"btn_publish_face_b"] forState:0];
        isEmojiKeyBoard=NO;
    
    
    }
    
    
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isEmojiKeyBoard=NO;
    
    
    

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
