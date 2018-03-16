//
//  FYXAlertView.m
//  FYXComponent
//
//  Created by 欧阳云慧 on 2018/2/9.
//  Copyright © 2018年 欧阳云慧. All rights reserved.
//

#import "FYXAlertView.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)

#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)

CGFloat nativeScale(void) {
    static CGFloat scale = 0.0f;
    if (scale == 0.0f) {
        CGFloat width = SCREEN_WIDTH;
        scale = width / 375.0f;
    }
    return scale * 2;
}


@implementation FYXAlertView
{
    UIButton    * _backGroundBtn;      // 灰色背景按钮
    UILabel     * _alertTitle;         // 提示文字
    UILabel     * _msgLabel;           // 提示内容
    UIView      * _msgAlertView;       // 文字弹窗view
    UITextView  * _richTextView;       // 富文本显示框
    UIImageView * _alertTitleImage;    // 提示图片
    UIView      * _lineBreak1;         // 分割线
    NSString    * _text;               // 文字载体
    UIView      * _safeLightView;      // 安全提示灯
}

- (id)initWithFrame: (CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self createMainViewWithFrame: frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self createMainViewWithFrame: frame];
}

- (void)createMainViewWithFrame: (CGRect)frame {

    [_backGroundBtn removeFromSuperview];
    _backGroundBtn = nil;
    // 背景按钮
    _backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backGroundBtn.frame = self.frame;
    [_backGroundBtn setTitle:@"" forState:UIControlStateNormal];
    [_backGroundBtn setBackgroundColor:[UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.3]];
    [_backGroundBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _backGroundBtn];

    // 初始一根分割线
    _lineBreak1 = [[UIView alloc]init];
    _lineBreak1.backgroundColor = [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1];

}

#pragma -mark 基本弹窗
// 创建弹窗
- (void)createAlertView {
    UIView *_alertView = [[UIView alloc]init];
    _alertView.frame = CGRectMake(VIEW_CENTER_X(self) - 100 * displayScale, 160 * displayScale, 200 * displayScale, 100 * displayScale);
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 8;
    [self addSubview:_alertView];

    _alertTitle = [[UILabel alloc]init];
    _alertTitle.frame = CGRectMake(0, 5, VIEW_WIDTH(_alertView), 60 * displayScale);
    _alertTitle.numberOfLines = 2;
    _alertTitle.lineBreakMode = NSLineBreakByCharWrapping;
    _alertTitle.textAlignment = NSTextAlignmentCenter;
    _alertTitle.textColor     = [UIColor blackColor];
    [_alertView addSubview:_alertTitle];

    // 取消、确定按钮
    _sureBtn   = [[UIButton alloc]init];
    _cancelBtn = [[UIButton alloc]init];

    _sureBtn.frame   = CGRectMake(VIEW_WIDTH(_alertView) / 2, VIEW_HEIGHT(_alertTitle), VIEW_WIDTH(_alertView) / 2, 40 * displayScale);
    _cancelBtn.frame = CGRectMake(0,VIEW_HEIGHT(_alertTitle), VIEW_WIDTH(_alertView) / 2, 40 * displayScale);

    _sureBtn.titleLabel.font   = [UIFont systemFontOfSize:17 * displayScale];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17 * displayScale];

    [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];

    [_alertView addSubview:_sureBtn];
    [_alertView addSubview:_cancelBtn];

    // 分割线

    UIView *lineBreak2 = [[UIView alloc]init];

    _lineBreak1.frame = CGRectMake(VIEW_X(_cancelBtn), VIEW_Y(_cancelBtn), VIEW_WIDTH(_alertView), 1);
    lineBreak2.frame  = CGRectMake(VIEW_WIDTH(_alertView) / 2, VIEW_Y(_cancelBtn), 1, VIEW_HEIGHT(_cancelBtn));

    lineBreak2.backgroundColor = [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1];

    [_alertView addSubview:_lineBreak1];
    [_alertView addSubview:lineBreak2];

}

// 设置弹框文字
- (void)setAlertTitle: (NSString *)alertTitle titleFont:(NSInteger) titleFont{
    [self createAlertView];
    _alertTitle.text = alertTitle;

    [_alertTitle setFont: [UIFont systemFontOfSize:( titleFont * displayScale)]];
}

#pragma -mark 文字弹窗
- (void)createMsgAlert {
    _msgAlertView = [[UIView alloc]init];

    _msgAlertView.frame = CGRectMake(VIEW_CENTER_X(self) - 100 * displayScale,
                                     160 * displayScale,
                                     200 * displayScale,
                                     300 * displayScale);
    _msgAlertView.layer.cornerRadius = 8;
    _msgAlertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_msgAlertView];

    _alertTitle = [[UILabel alloc]init];
    _alertTitle.frame = CGRectMake(0, 5, VIEW_WIDTH(_msgAlertView), 23 * displayScale);
    _alertTitle.numberOfLines = 1;
    _alertTitle.textAlignment = NSTextAlignmentCenter;
    _alertTitle.textColor     = [UIColor blackColor];
    [_msgAlertView addSubview:_alertTitle];

    _msgLabel = [[UILabel alloc]init];
    _msgLabel.frame = CGRectMake(8 * displayScale,
                                 VIEW_HEIGHT(_alertTitle) + VIEW_Y(_alertTitle),
                                 VIEW_WIDTH(_msgAlertView) - 16 * displayScale,
                                 VIEW_HEIGHT(_msgAlertView) - VIEW_HEIGHT(_alertTitle) - 40 * displayScale);
     
    _msgLabel.numberOfLines = 0;
    _msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _msgLabel.textAlignment = NSTextAlignmentLeft;
    _msgLabel.textColor     = [UIColor blackColor];
    [_msgAlertView addSubview:_msgLabel];

    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(0,
                                  VIEW_HEIGHT(_alertTitle) + VIEW_Y(_alertTitle) + VIEW_HEIGHT(_msgLabel),
                                  VIEW_WIDTH(_msgAlertView),
                                  35 * displayScale);

    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17 * displayScale];
    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_msgAlertView addSubview:_cancelBtn];

    // 分割线

}

// 设置弹窗内容
- (void)setMsgAlertView: (NSString *)alertTitle titleFont:(NSInteger) titleFont alertMsg:(NSString *)msg msgFont:(NSInteger)msgFont  msgColor: (UIColor *)msgColor{
    [self createMsgAlert];
    _alertTitle.text = alertTitle;
    _msgLabel.text   = msg;
    _msgLabel.textColor = msgColor;
    [_alertTitle setFont:[UIFont systemFontOfSize:titleFont * displayScale]];
    [_msgLabel setFont:[UIFont systemFontOfSize:msgFont * displayScale]];

}

// 设置文本弹窗的高度
- (void)setMsgAlertFrame: (NSInteger)alertHeight AlertWidth:(NSInteger)alertWidth {
    _msgAlertView.frame = CGRectMake(VIEW_CENTER_X(self) - alertWidth / 2 * displayScale,
                                     160 * displayScale,
                                     alertWidth * displayScale,
                                     alertHeight * displayScale);

    _alertTitle.frame   = CGRectMake(0, 12, VIEW_WIDTH(_msgAlertView), 23 * displayScale);

    _msgLabel.frame     = CGRectMake(13 * displayScale,
                                     VIEW_HEIGHT(_alertTitle) + VIEW_Y(_alertTitle),
                                     VIEW_WIDTH(_msgAlertView) - 26 * displayScale,
                                     VIEW_HEIGHT(_msgAlertView) - VIEW_HEIGHT(_alertTitle) - 60 * displayScale);

    _cancelBtn.frame    = CGRectMake(0,
                                     VIEW_HEIGHT(_alertTitle) + VIEW_Y(_alertTitle) + VIEW_HEIGHT(_msgLabel) + 12 * displayScale,
                                     VIEW_WIDTH(_msgAlertView),
                                     30 * displayScale);

    _lineBreak1.frame   = CGRectMake(8 * displayScale, VIEW_Y(_cancelBtn), VIEW_WIDTH(_cancelBtn) - 16, 1);

    [_msgAlertView addSubview:_lineBreak1];
}


#pragma -mark 富文本显示框
- (void)createRichTextAlertView {
    _richTextView = [[UITextView alloc]init];
    _richTextView.frame = CGRectMake(VIEW_CENTER_X(self) - 100 * displayScale, 160 * displayScale, 200 * displayScale, 300 * displayScale);
    _richTextView.textColor = [UIColor blackColor];
    _richTextView.textAlignment = NSTextAlignmentLeft;
    _richTextView.backgroundColor = [UIColor whiteColor];
    _richTextView.layer.cornerRadius = 8;

    [self addSubview:_richTextView];

    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(VIEW_CENTER_X(_richTextView) + 8 * displayScale,
                                  VIEW_HEIGHT(_richTextView) + 20 * displayScale + VIEW_Y(_richTextView),
                                  30 * displayScale,
                                  30 * displayScale);

    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];
}


// 设置富文本内容
- (void)setRichTextView: (NSString*)textContent textFont:(NSInteger)textFont {
    [self createRichTextAlertView];
    _richTextView.text = textContent;
    [_richTextView setFont:[UIFont systemFontOfSize:textFont * displayScale]];
}

// 设置富文本高度
- (void)setRichTextViewFrame: (NSInteger)width height:(NSInteger)height {
    _richTextView.frame = CGRectMake(VIEW_CENTER_X(self) - width / 2 * displayScale,
                                     160 * displayScale,
                                     width * displayScale,
                                     height * displayScale);

    _cancelBtn.frame    = CGRectMake(VIEW_CENTER_X(self) - 15 * displayScale,
                                     VIEW_HEIGHT(_richTextView) + 20 * displayScale + VIEW_Y(_richTextView),
                                     30 * displayScale,
                                     30 * displayScale);
}

#pragma -mark 图片的提示框
- (void)createImageAlertView {
    UIView *_alertView = [[UIView alloc]init];
    _alertView.frame = CGRectMake(40 * displayScale, 160 * displayScale, VIEW_WIDTH(self) - 80 * displayScale, 200 * displayScale);
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 8;
    [self addSubview:_alertView];
    
    _alertTitleImage = [[UIImageView alloc]init];
    _alertTitleImage.frame = CGRectMake(VIEW_WIDTH(_alertView) / 2 - 25 * displayScale, 18 * displayScale, 50 * displayScale, 50 * displayScale);
    _alertTitleImage.image = [UIImage imageNamed:@"sure.png"];
    [_alertView addSubview:_alertTitleImage];

    _msgLabel = [[UILabel alloc]init];
    _msgLabel.frame = CGRectMake(15,
                                 VIEW_Y(_alertTitleImage) + VIEW_HEIGHT(_alertTitleImage),
                                 VIEW_WIDTH(_alertView) - 30 * displayScale,
                                 70 * displayScale);
    _msgLabel.numberOfLines = 0;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.textColor     = [UIColor blackColor];
    [_alertView addSubview:_msgLabel];

    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(0,
                                  VIEW_HEIGHT(_msgLabel) + 20 * displayScale + VIEW_Y(_msgLabel),
                                  VIEW_WIDTH(_alertView),
                                  40 * displayScale);
    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"sure" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_alertView addSubview:_cancelBtn];

    // 分割线
    _lineBreak1.frame = CGRectMake(8 * displayScale, VIEW_Y(_cancelBtn), VIEW_WIDTH(_cancelBtn) - 16, 1);
    [_alertView addSubview:_lineBreak1];
}

// 设置图片弹窗
- (void)setImageAlertView: (NSString *)content contentFont: (NSInteger)contentFont contentColor: (UIColor *)contentColor imageName: (NSString *)imageName {
    [self createImageAlertView];
    _msgLabel.text = content;
    _msgLabel.textColor = contentColor;
    [_msgLabel setFont:[UIFont systemFontOfSize:contentFont * displayScale]];

    if (imageName != nil) {
        _alertTitleImage.image = [UIImage imageNamed:imageName];
    }

}

# pragma -mark 三个按钮弹窗
// 三个按钮弹窗
- (void)creatMoreBtnAlertView {
    UIView *_alertView = [[UIView alloc]init];
    _alertView.frame = CGRectMake(VIEW_CENTER_X(self) - 100 * displayScale, 160 * displayScale, 200 * displayScale, 200 * displayScale);
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 8;
    [self addSubview:_alertView];

    _msgLabel = [[UILabel alloc]init];
    _msgLabel.frame = CGRectMake(15 , 18 * displayScale, VIEW_WIDTH(_alertView) - 30, 72 * displayScale);
    _msgLabel.textAlignment = NSTextAlignmentLeft;
    _msgLabel.textColor     = [UIColor blackColor];
    _msgLabel.numberOfLines = 0;
    [_alertView addSubview:_msgLabel];

    _sureBtn = [[UIButton alloc]init];
    _sureBtn.frame = CGRectMake(0, VIEW_Y(_msgLabel) + VIEW_HEIGHT(_msgLabel) + 8, VIEW_WIDTH(_alertView), 35 * displayScale);
    [_sureBtn setTitle:@"sure" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithRed:0 green:122.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_sureBtn];

    _middleBtn = [[UIButton alloc]init];
    _middleBtn.frame = CGRectMake(0, VIEW_Y(_sureBtn) + VIEW_HEIGHT(_sureBtn), VIEW_WIDTH(_sureBtn), VIEW_HEIGHT(_sureBtn));
    [_middleBtn setTitle:@"NO,select Other" forState:UIControlStateNormal];
    [_middleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_middleBtn addTarget:self action:@selector(otherClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_middleBtn];

    _cancelBtn =  [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(0, VIEW_Y(_middleBtn) + VIEW_HEIGHT(_middleBtn), VIEW_WIDTH(_sureBtn), VIEW_HEIGHT(_sureBtn));
    [_cancelBtn setTitle:@"think more" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_cancelBtn];

    // 分割线
    _lineBreak1.frame = CGRectMake(0, VIEW_Y(_sureBtn), VIEW_WIDTH(_sureBtn), 1);
    [_alertView addSubview:_lineBreak1];

    UIView * _lineBreak2 = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_Y(_middleBtn), VIEW_WIDTH(_middleBtn), 1)];
    _lineBreak2.backgroundColor = [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1];
    [_alertView addSubview:_lineBreak2];

    UIView * _lineBreak3 = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_Y(_cancelBtn), VIEW_WIDTH(_cancelBtn), 1)];
    _lineBreak3.backgroundColor = [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1];;
    [_alertView addSubview:_lineBreak3];

}

// 设置多按钮提示
- (void)setMoreBtnAlertView: (NSString *)content contentFont: (NSInteger)contentFont {
    [self creatMoreBtnAlertView];
    _msgLabel.text = content;
    [_msgLabel setFont:[UIFont systemFontOfSize:contentFont * displayScale]];
}

#pragma -mark 气泡弹窗
- (void)setBubbleView: (NSString *)text font: (CGFloat)textFont textColor: (UIColor *)textColor{

    _text = [text copy];
    _alertTitle = [[UILabel alloc]init];
    _msgAlertView = [[UIView alloc]init];

    UIFont *font = [UIFont systemFontOfSize: textFont * displayScale];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;                    // 随字数，字体扩展大小

    _alertTitle.text = _text;
    _alertTitle.font = font;
    _alertTitle.textColor = textColor;
    _alertTitle.frame = CGRectMake(8, 12, textSize.width, textSize.height);
    _alertTitle.textAlignment = NSTextAlignmentCenter;

    UIImageView *bubbleImageView = [[UIImageView alloc]init];
    bubbleImageView.image = [UIImage imageNamed:@"bubble.png"];
    bubbleImageView.frame = CGRectMake(0, 0, textSize.width + 16 * displayScale, textSize.height + 16 * displayScale);

    _msgAlertView.frame = CGRectMake(VIEW_WIDTH(self) - textSize.width - 30 * displayScale, 62 * displayScale, VIEW_WIDTH(bubbleImageView), VIEW_HEIGHT(bubbleImageView) + 5);
    _msgAlertView.backgroundColor = [UIColor clearColor];
    _msgAlertView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [_msgAlertView addSubview:bubbleImageView];
    [bubbleImageView addSubview:_alertTitle];
    [self addSubview:_msgAlertView];
}

#pragma -mark 安全提示灯
- (void)createSafeLightView: (NSString *)instructText suggest: (NSString *)suggestText title: (NSString *)title instruteTitle: (NSString * ) instruteTitle suggestTitle: (NSString *)suggestTitle{

    _alertTitleImage = [[UIImageView alloc]init];
    _alertTitleImage.frame = CGRectMake(25 * displayScale, 25 * displayScale, 70 * displayScale, 70 * displayScale);

    UIFont *font = [UIFont boldSystemFontOfSize: 18 * displayScale];
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

    _alertTitle = [[UILabel alloc]init];
    _alertTitle.frame = CGRectMake(VIEW_X_Right(_alertTitleImage) + 20 * displayScale, VIEW_CENTER_Y(_alertTitleImage) - textSize.height / 2, 147 * displayScale, textSize.height);
    _alertTitle.text = title;
    _alertTitle.font = font;
    _alertTitle.numberOfLines = 0;
    _alertTitle.textColor = [UIColor colorWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:1];

    _lineBreak1.frame = CGRectMake(VIEW_X(_alertTitleImage), VIEW_Y_Bottom(_alertTitleImage) + 10 * displayScale, VIEW_WIDTH(_alertTitleImage) + VIEW_WIDTH(_alertTitle) + 20 * displayScale, 1);

    UILabel *instruteTitleLb = [[UILabel alloc]init];
    textSize = [instruteTitle boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    instruteTitleLb.frame = CGRectMake(VIEW_X(_lineBreak1), VIEW_Y_Bottom(_lineBreak1) + 12 * displayScale, VIEW_WIDTH(_lineBreak1), textSize.height);
    instruteTitleLb.textColor = [UIColor colorWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:1];
    instruteTitleLb.font = font;
    instruteTitleLb.text = instruteTitle;

    UILabel *instruteTextLb = [[UILabel alloc]init];
    font = [UIFont systemFontOfSize: 14 * displayScale];
    attrs = @{NSFontAttributeName : font};
    textSize = [instructText boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    instruteTextLb.textColor = [UIColor colorWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:0.5];
    instruteTextLb.numberOfLines = 0;
    instruteTextLb.font = font;
    instruteTextLb.text = instructText;
    instruteTextLb.frame = CGRectMake(VIEW_X(_lineBreak1), VIEW_Y_Bottom(instruteTitleLb) + 12 * displayScale, VIEW_WIDTH(_lineBreak1), textSize.height);

    UILabel *suggestTitleLb = [[UILabel alloc]init];
    font = [UIFont boldSystemFontOfSize: 16 * displayScale];
    attrs = @{NSFontAttributeName : font};
    textSize = [suggestTitle boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    suggestTitleLb.frame = CGRectMake(VIEW_X(_lineBreak1), VIEW_Y_Bottom(instruteTextLb) + 30 * displayScale, VIEW_WIDTH(_lineBreak1), textSize.height);
    suggestTitleLb.text = suggestTitle;
    suggestTitleLb.font = font;
    suggestTitleLb.textColor = [UIColor colorWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:1];

    UILabel *suggestLb = [[UILabel alloc]init];
    font = [UIFont systemFontOfSize: 14 * displayScale];
    attrs = @{NSFontAttributeName : font};
    textSize = [suggestText boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    suggestLb.frame = CGRectMake(VIEW_X(_lineBreak1), VIEW_Y_Bottom(suggestTitleLb) + 12 * displayScale, VIEW_WIDTH(_lineBreak1), textSize.height);
    suggestLb.textColor = [UIColor colorWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:0.5];
    suggestLb.numberOfLines = 0;
    suggestLb.font = font;
    suggestLb.text = suggestText;

    _safeLightView = [[UIView alloc]init];
    _safeLightView.frame = CGRectMake(40 * displayScale, 120 * displayScale, SCREEN_WIDTH - 80 * displayScale, VIEW_HEIGHT(_alertTitleImage) + VIEW_HEIGHT(suggestTitleLb) + VIEW_HEIGHT(suggestLb) + VIEW_HEIGHT(instruteTitleLb) + VIEW_HEIGHT(instruteTextLb) + 130 * displayScale);
    _safeLightView.backgroundColor = [UIColor whiteColor];
    _safeLightView.layer.cornerRadius = 8;
    _safeLightView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_safeLightView];
    [_safeLightView addSubview:_alertTitleImage];
    [_safeLightView addSubview:_alertTitle];
    [_safeLightView addSubview:_lineBreak1];
    [_safeLightView addSubview:instruteTitleLb];
    [_safeLightView addSubview:instruteTextLb];
    [_safeLightView addSubview:suggestTitleLb];
    [_safeLightView addSubview:suggestLb];

    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(VIEW_CENTER_X(self) - 10 * displayScale,VIEW_Y_Bottom(_safeLightView) + 30 * displayScale, 40 * displayScale, 40 * displayScale);
    [_cancelBtn addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];

}

- (void)setSafeLightView: (NSString *)instructText suggest: (NSString *)suggestText title: (NSString *)title instruteTitle: (NSString * ) instruteTitle suggestTitle: (NSString *)suggestTitle titleImage: (NSString *)titleImage{
    [self createSafeLightView:instructText suggest:suggestText title:title instruteTitle:instruteTitle suggestTitle:suggestTitle];
    _alertTitleImage.image = [UIImage imageNamed:titleImage];
}

#pragma -mark action
// 点击背景隐藏
- (void)hiddenClick: (UIButton *)sender {
    self.hidden = YES;
}

// 弹窗点击确定
- (void)sureClick: (UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sureDidClick:)]) {
        [self.delegate sureDidClick:self];
    }

}

// 另外点击事件
- (void)otherClick: (UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(otherBtnDidClick:)]) {
        [self.delegate otherBtnDidClick:self];
    }
}
@end
