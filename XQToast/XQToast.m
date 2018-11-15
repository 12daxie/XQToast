//
//  XQToast.m

//  Copyright (c) 2016 XQToast ( https://github.com/CoderZhuXH/XQToast )

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "XQToast.h"

//Toast默认停留时间
#define ToastDispalyDuration 1.2f
//Toast到顶端/底端默认距离
#define ToastSpace 100.0f
//Toast背景颜色
#define ToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]

@interface XQToast ()
@property(nonatomic,strong)UIButton *contentView;
@property(nonatomic,assign)CGFloat duration;
@end

@implementation XQToast

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {

        UIFont *font = [UIFont boldSystemFontOfSize:16];
        NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
        CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 40, rect.size.height+ 20)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        self.contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        self.contentView.layer.cornerRadius = 20.0f;
        self.contentView.backgroundColor = ToastBackgroundColor;
        [self.contentView addSubview:textLabel];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        self.contentView.alpha = 0.0f;
        self.duration = ToastDispalyDuration;
        
    }
    
    return self;
}

-(void)dismissToast{
    
    [self.contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender{
    
    [self hideAnimation];
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 0.0f;
    [UIView commitAnimations];
}
+(UIWindow *)window
{
    UIWindow *window =  [[[UIApplication sharedApplication] windows] lastObject];
    if(window && !window.hidden) return window;
    window = [UIApplication sharedApplication].delegate.window;
    return window;
}

- (void)showIn:(UIView *)view{
    self.contentView.center = view.center;
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showIn:(UIView *)view fromTopOffset:(CGFloat)top{
    self.contentView.center = CGPointMake(view.center.x, top + self.contentView.frame.size.height/2);
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showIn:(UIView *)view fromBottomOffset:(CGFloat)bottom{
    self.contentView.center = CGPointMake(view.center.x, view.frame.size.height-(bottom + self.contentView.frame.size.height/2));
    [view  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

#pragma mark-中间显示
+ (void)showCenterWithText:(NSString *)text{
    
    [XQToast showCenterWithText:text duration:ToastDispalyDuration];
}

+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration{
    
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window]];
}
#pragma mark-上方显示
+ (void)showTopWithText:(NSString *)text{
    
    [XQToast showTopWithText:text  topOffset:ToastSpace duration:ToastDispalyDuration];
}
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration
{
     [XQToast showTopWithText:text  topOffset:ToastSpace duration:duration];
}
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset{
    [XQToast showTopWithText:text  topOffset:topOffset duration:ToastDispalyDuration];
}

+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration{
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window] fromTopOffset:topOffset];
}
#pragma mark-下方显示
+ (void)showBottomWithText:(NSString *)text{
    
    [XQToast showBottomWithText:text  bottomOffset:ToastSpace duration:ToastDispalyDuration];
}
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration
{
      [XQToast showBottomWithText:text  bottomOffset:ToastSpace duration:duration];
}
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset{
    [XQToast showBottomWithText:text  bottomOffset:bottomOffset duration:ToastDispalyDuration];
}

+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration{
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:[self window] fromBottomOffset:bottomOffset];
}

@end


@implementation UIView (XQToast)

#pragma mark-中间显示
- (void)showXQToastCenterWithText:(NSString *)text
{
    [self showXQToastCenterWithText:text duration:ToastDispalyDuration];
}

- (void)showXQToastCenterWithText:(NSString *)text duration:(CGFloat)duration
{
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:self];
}

#pragma mark-上方显示
- (void)showXQToastTopWithText:(NSString *)text
{
    [self showXQToastTopWithText:text topOffset:ToastSpace duration:ToastDispalyDuration];
}

- (void)showXQToastTopWithText:(NSString *)text duration:(CGFloat)duration
{
    [self showXQToastTopWithText:text topOffset:ToastSpace duration:duration];
}

- (void)showXQToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset
{
    [self showXQToastTopWithText:text topOffset:topOffset duration:ToastDispalyDuration];
}

- (void)showXQToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration
{
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:self fromTopOffset:topOffset];
}

#pragma mark-下方显示
- (void)showXQToastBottomWithText:(NSString *)text
{
    [self showXQToastBottomWithText:text bottomOffset:ToastSpace duration:ToastDispalyDuration];
}

- (void)showXQToastBottomWithText:(NSString *)text duration:(CGFloat)duration
{
    [self showXQToastBottomWithText:text bottomOffset:ToastSpace duration:duration];
}

- (void)showXQToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset
{
    [self showXQToastBottomWithText:text bottomOffset:bottomOffset duration:ToastDispalyDuration];
}

- (void)showXQToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration
{
    XQToast *toast = [[XQToast alloc] initWithText:text];
    toast.duration = duration;
    [toast showIn:self fromBottomOffset:bottomOffset];
}

@end

