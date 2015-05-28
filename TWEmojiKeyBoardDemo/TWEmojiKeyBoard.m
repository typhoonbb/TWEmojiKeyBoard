//
//  TWEmojiKeyBoard.m
//  Supermacy
//
//  Created by Taylor on 15/5/27.
//  Copyright (c) 2015年 Taylor. All rights reserved.
//

#import "TWEmojiKeyBoard.h"

#define  BTN_NORMAL_ARRAY @[@"emoji_recent_n",@"emoji_face_n",@"emoji_bell_n",@"emoji_flower_n",@"emoji_car_n",@"emoji_backspace_n"]

#define  BTN_SELECT_ARRAY @[@"emoji_recent_s",@"emoji_face_s",@"emoji_bell_s",@"emoji_flower_s",@"emoji_car_s",@"emoji_backspace_n"]

#define EMOJI_RECORD_FILE  [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/emojiRecords.plist"]

#define KEYBOARD_WIDTH [UIScreen mainScreen].bounds.size.width



@implementation TWEmojiKeyBoard
{
    
    BOOL isEmojKeyBoard;
    
    UIView *emojKeyBorad;
    
    UIButton *currentTypeBtn;
    
    UIImageView* cornerLeft;
    
    UIImageView* cornerRight;
    
    UIView *bottomView;
    
    UIImageView* leftLine;
    
    UIImageView* rightLine;
    
    UIPageControl *pageControl;
    
    UILabel *label;
    
    UIScrollView *emojiBackView;
    
    UIImageView *detailEmoji;
    
    UILabel *detailLabel;
    
    UILabel *zoomedEmoji;
    
    UITextField *mtextField;

}


-(void)createEmojiKeyBoard{
    
    isEmojKeyBoard=NO;
    
    emojKeyBorad=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KEYBOARD_WIDTH, 216)];
    
    emojKeyBorad.backgroundColor=[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    
    emojiBackView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 36, KEYBOARD_WIDTH, 183)];
    
    emojiBackView.contentSize=CGSizeMake(29* KEYBOARD_WIDTH, 183);
    
    emojiBackView.scrollEnabled=NO;
    
    emojiBackView.pagingEnabled=YES;
    
    emojiBackView.backgroundColor=[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    
    [emojKeyBorad addSubview:emojiBackView];
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 183, KEYBOARD_WIDTH, 33)];
    
    bottomView.backgroundColor=[UIColor clearColor];
    
    [emojKeyBorad addSubview:bottomView];
    
    
    for (int i=0; i<6; i++) {
        
        
        CGFloat width=KEYBOARD_WIDTH/6;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 33)];
        
        if (i==1) {
            currentTypeBtn=btn;
        }
        
        [btn setBackgroundColor:[UIColor colorWithRed:224/255.f green:224/255.f blue:224/255.f alpha:1]];
        
        [btn setImage:[UIImage imageNamed:BTN_NORMAL_ARRAY[i]] forState:0];
        
        [btn addTarget:self action:@selector(chooseEmojiTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag=100+i;
        
        [bottomView addSubview:btn];
        
    }
    
    CGFloat width=KEYBOARD_WIDTH/6;
    
    cornerRight=[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, 8, 34)];
    
    cornerLeft=[[UIImageView alloc]initWithFrame:CGRectMake(width-8, -1, 8, 34)];
    
    cornerLeft.image=[UIImage imageNamed:@"emoji_corner_left"];
    
    cornerRight.image=[UIImage imageNamed:@"emoji_corner_right"];
    
    leftLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KEYBOARD_WIDTH, 1)];
    
    rightLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KEYBOARD_WIDTH, 1)];
    
    
    
    leftLine.backgroundColor=[UIColor colorWithRed:178/255.f green:178/255.f blue:178/255.f alpha:1];
    
    
    rightLine.backgroundColor=[UIColor colorWithRed:178/255.f green:178/255.f blue:178/255.f alpha:1];
    
    
    cornerRight.backgroundColor=[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    
    cornerLeft.backgroundColor=[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    
    
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 10, KEYBOARD_WIDTH-47, 36)];
    
    
    pageControl.center=CGPointMake(KEYBOARD_WIDTH/2, 18);
    
    [emojKeyBorad addSubview:pageControl];
    
    
    pageControl.numberOfPages=5;
    
    pageControl.currentPage=0;
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(KEYBOARD_WIDTH-47, 0, 47, 36)];
    
    [btn setImage:[UIImage imageNamed:@"emoji_close_n"] forState:0];
    
    [btn setImage:[UIImage imageNamed:@"emoji_close_s"] forState:UIControlStateHighlighted];
    
    [emojKeyBorad addSubview:btn];
    
    [btn addTarget:self action:@selector(stopEdit) forControlEvents:UIControlEventTouchUpInside];
    
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1];
    
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KEYBOARD_WIDTH, 36)];
    
    label.text=@"最近使用";
    
    [label setFont:[UIFont systemFontOfSize:12]];
    
    [label setTextColor:[UIColor lightGrayColor]];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    
    NSArray *array=@[@"People",@"Objects",@"Nature",@"Places"];
    
    
    NSDictionary *emojiDict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"EmojisList" ofType:@"plist"]];
    
    NSArray *pagesArray=@[@(1),@(18),@(23),@(28)];
    
    
    for (int i=0; i<4; i++) {
        
        NSArray *emojiArray=[emojiDict objectForKey:array[i]];
        
        NSNumber *n=pagesArray[i];
        
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(n.integerValue*KEYBOARD_WIDTH, 0, KEYBOARD_WIDTH, 183)];
        
        scrollView.delegate=self;
        
        scrollView.tag=2000+i;
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEmojiAction:)];
        
        [scrollView addGestureRecognizer:longPress];
        
        
        [emojiBackView addSubview:scrollView];
        
        scrollView.pagingEnabled=YES;
        
        NSInteger pageCount=(emojiArray.count+23)/24;
        
        
        [self displayRecentlyUsedEmoji];
        
        
        for (int j=0; j<emojiArray.count; j++) {
            
            NSInteger row,col,pageIdx;
            
            CGFloat width=(KEYBOARD_WIDTH-250)/7+30;
            
            row=(j/8 ) %3;
            
            col=(j+1) % 8 ==0? 8: (j +1 )%8;
            
            pageIdx=j/24;
            
            UILabel *emoji=[[UILabel alloc]initWithFrame:CGRectMake(5+(col-1)*width+pageIdx*KEYBOARD_WIDTH , 15+row* 39, 30, 30)];
            
            [emoji setFont:[UIFont systemFontOfSize:30]];
            
            emoji.text=emojiArray[j];
            
            [scrollView addSubview:emoji];
            
            scrollView.contentSize=CGSizeMake(KEYBOARD_WIDTH*pageCount, 183);
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectEmoji:)];
            
            emoji.userInteractionEnabled=YES;
            
            [emoji addGestureRecognizer:tap];
            
            tap.delegate=self;
            
        }
        
        
        
        
        
    }
    
    
    
    [self chooseEmojiTypeAction:currentTypeBtn];
    
    emojiBackView.clipsToBounds=NO;






}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    int pageNumber=scrollView.contentOffset.x/KEYBOARD_WIDTH;
    
    pageControl.currentPage=pageNumber;
    
    
}
-(void)longPressEmojiAction:(UILongPressGestureRecognizer*)longPress{
    
    CGPoint p=[longPress locationInView:longPress.view];
    
    
    UIView *emojiScroll;
    
    if (([longPress.view isKindOfClass:[UIScrollView class]] && longPress.view.tag >= 2000)  || longPress.view==emojiBackView) {
        
        emojiScroll=longPress.view;
        
    }else{
        
        return;
    }
    
    
    
    if (longPress.state==UIGestureRecognizerStateBegan || longPress.state==UIGestureRecognizerStateChanged) {
        
        NSArray *subViews=[emojiScroll subviews];
        
        for (UIView *sb in subViews) {
            
            
            if ([sb isKindOfClass:[UILabel class]] && CGRectContainsPoint(sb.frame, p)) {
                
                zoomedEmoji=(UILabel*)sb;
                
                [self showDetailEmoji:zoomedEmoji];
                
                break;
            }
            
        }
        
        
        
        
        
    }
    
    
    
    if (longPress.state==UIGestureRecognizerStateEnded) {
        
        
        if (zoomedEmoji) {
            

            [mtextField insertText:zoomedEmoji.text];
            [self recordUsedEmoji:zoomedEmoji.text];
        }
        
        [detailEmoji removeFromSuperview];
    }
    
    
}
-(void)showDetailEmoji:(UILabel*)emoji{
    
    if (!detailEmoji) {
        
        detailEmoji=[[UIImageView alloc]initWithFrame:CGRectMake(emoji.frame.origin.x,emoji.frame.origin.y, 82, 111)];
        
        detailEmoji.image=[UIImage imageNamed:@"emoji_touch"];
        
        detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
        
        [detailLabel setFont:[UIFont systemFontOfSize:40]];
        
        detailLabel.textAlignment=NSTextAlignmentCenter;
        
        [detailEmoji addSubview:detailLabel];
        
    }
    int screenWidth=KEYBOARD_WIDTH;
    
    int x=emoji.frame.origin.x;
    
    x=x % screenWidth;
    
    
    detailEmoji.frame=CGRectMake(x%screenWidth -24,emoji.frame.origin.y-40, 82, 111);
    
    [emojKeyBorad addSubview:detailEmoji];
    
    detailLabel.text=emoji.text;
    
}

-(void)displayRecentlyUsedEmoji{
    
    
    
    NSMutableArray *usedEmojiArray=[NSMutableArray arrayWithContentsOfFile:EMOJI_RECORD_FILE];
    
    for (int k=0; k<usedEmojiArray.count; k++) {
        
        NSInteger row,col;
        
        row=k/8;
        
        col=(k+1) %8 ==0 ?8:(k+1)%8;
        
        CGFloat width=(KEYBOARD_WIDTH-250)/7+30;
        
        UILabel *emojiLabel=(UILabel*)[emojiBackView viewWithTag:(1000+k)];
        
        if (!emojiLabel) {
            
            emojiLabel=[[UILabel alloc]initWithFrame:CGRectMake(5+(col-1)*width, 15+row*39, 30, 30)];
            
            emojiLabel.tag=1000+k;
            
        }
        
        
        if ([emojiLabel gestureRecognizers].count==0) {
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectEmoji:)];
            
            emojiLabel.userInteractionEnabled=YES;
            [emojiLabel addGestureRecognizer:tap];
            
            tap.delegate=self;
            
        }
        
        emojiLabel.text=usedEmojiArray[k];
        
        [emojiLabel setFont:[UIFont systemFontOfSize:30]];
        
        [emojiBackView addSubview:emojiLabel];
        
    }
    
    UILongPressGestureRecognizer *longp=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEmojiAction:)];
    
    [emojiBackView addGestureRecognizer:longp];
    
}
//记录使用过的表情
-(void)recordUsedEmoji:(NSString*)emojiStr{
    
    NSMutableArray *recordArray=[NSMutableArray arrayWithContentsOfFile:EMOJI_RECORD_FILE];
    if (!recordArray) {
        
        recordArray=[[NSMutableArray alloc]init];
        
    }
    /**
     *  最近使用只保存24个，也就是最多一页！
     */
    if (recordArray.count==24) {
        
        [recordArray removeObject:[recordArray firstObject]];
        
    }
    if ( [recordArray containsObject:emojiStr]) {
        
        [recordArray removeObject:emojiStr];
        
    }
    [recordArray insertObject:emojiStr atIndex:0];
    
    
    [recordArray writeToFile:EMOJI_RECORD_FILE atomically:YES];
    
    
    
    
    
    [self performSelectorOnMainThread:@selector(displayRecentlyUsedEmoji) withObject:nil waitUntilDone:YES];
    
    
}


-(void)didSelectEmoji:(UITapGestureRecognizer*)tap{
    
    
    
    if (tap.state==UIGestureRecognizerStateEnded) {
        
        UILabel *emojiLabel=(UILabel*)[tap view];
       

        [mtextField insertText:emojiLabel.text];
        
        if (emojiLabel.tag<1000) {
            
            [self recordUsedEmoji:emojiLabel.text];
            
        }
        
    }
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UILabel"]) {
        
        return YES;
    }
    return  NO;
}

-(void)chooseEmojiTypeAction:(UIButton*)btn{
    
    
    
    if (btn.tag==105) {
        

        [mtextField deleteBackward];
        
        return;
        
    }
    
    switch (btn.tag) {
        case 100:
        {
            pageControl.numberOfPages=0;
            
            
            [emojiBackView scrollRectToVisible:CGRectMake(0, 0, KEYBOARD_WIDTH, 183) animated:NO];
            break;
        }
            
        case 101:
        {
            UIScrollView *scroll=(UIScrollView*)[emojiBackView viewWithTag:2000];
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                
                int p=scroll.contentOffset.x/KEYBOARD_WIDTH;
                pageControl.currentPage=p;
                
            }
            pageControl.numberOfPages=8;
            [emojiBackView scrollRectToVisible:CGRectMake(KEYBOARD_WIDTH, 0, KEYBOARD_WIDTH, 183) animated:NO];
            break;
        }
        case 102:
        {
            UIScrollView *scroll=(UIScrollView*)[emojiBackView viewWithTag:2001];
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                
                int p=scroll.contentOffset.x/KEYBOARD_WIDTH;
                pageControl.currentPage=p;
                
            }
            pageControl.numberOfPages=10;
            [emojiBackView scrollRectToVisible:CGRectMake(18*KEYBOARD_WIDTH , 0, KEYBOARD_WIDTH, 183) animated:NO];
            break;
        }
        case 103:
        {
            UIScrollView *scroll=(UIScrollView*)[emojiBackView viewWithTag:2002];
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                
                int p=scroll.contentOffset.x/KEYBOARD_WIDTH;
                pageControl.currentPage=p;
                
            }
            pageControl.numberOfPages=5;
            [emojiBackView scrollRectToVisible:CGRectMake(23*KEYBOARD_WIDTH , 0, KEYBOARD_WIDTH, 183) animated:NO];
            break;
        }
        case 104:
        {
            UIScrollView *scroll=(UIScrollView*)[emojiBackView viewWithTag:2003];
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                
                int p=scroll.contentOffset.x/KEYBOARD_WIDTH;
                pageControl.currentPage=p;
                
            }
            pageControl.numberOfPages=5;
            [emojiBackView scrollRectToVisible:CGRectMake(28*KEYBOARD_WIDTH , 0, KEYBOARD_WIDTH, 183) animated:NO];
            break;
        }
        default:
            break;
    }
    if(btn.tag==100){
        
        pageControl.hidden=YES;
        
        [emojKeyBorad addSubview:label];
        
        [cornerLeft removeFromSuperview];
        
        
    }else{
        
        pageControl.hidden=NO;
        [label removeFromSuperview];
    }
    
    if (currentTypeBtn) {
        
        [currentTypeBtn setImage:[UIImage imageNamed:BTN_NORMAL_ARRAY[currentTypeBtn.tag-100]] forState:0];
        currentTypeBtn.backgroundColor=[UIColor colorWithRed:224/255.f green:224/255.f blue:224/255.f alpha:1];
        
    }
    
    
    [btn setImage:[UIImage imageNamed:BTN_SELECT_ARRAY[btn.tag-100]] forState:0];
    
    NSInteger index=  btn.tag-100;
    
    CGFloat width=KEYBOARD_WIDTH/6;
    
    leftLine.frame=CGRectMake((index)*width-KEYBOARD_WIDTH-3, 0, KEYBOARD_WIDTH, 1);
    
    rightLine.frame=CGRectMake((index+1)*width+3, 0, KEYBOARD_WIDTH, 1);
    
    [bottomView addSubview:leftLine];
    
    [bottomView addSubview:rightLine];
    
    [bottomView bringSubviewToFront:leftLine];
    
    [bottomView bringSubviewToFront:rightLine];
    
    
    [btn setBackgroundColor:[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1]];
    
    currentTypeBtn=btn;
    
    UIButton *prevBtn=(UIButton*)[bottomView viewWithTag:btn.tag-1];
    
    if (prevBtn) {
        
        [prevBtn addSubview:cornerLeft];
        
    }
    
    
    UIButton *nextBtn=(UIButton*)[bottomView viewWithTag:btn.tag+1];
    
    if (nextBtn) {
        
        [nextBtn addSubview:cornerRight];
        
    }
    
    
    
    
}
-(void)bindKeyBoardWithTextField:(UITextField*)textField{

    mtextField=textField;
    
    mtextField.inputView=emojKeyBorad;
    
    [mtextField reloadInputViews];


}
-(void)unbindKeyBoard{

    
    mtextField.inputView=nil;
    
    [mtextField reloadInputViews];
    
    mtextField=nil;




}
-(void)stopEdit{

    [mtextField resignFirstResponder];



}
@end
