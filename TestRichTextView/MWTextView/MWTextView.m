//
//  MWTextView.m
//  jiuhuar
//
//  Created by 孟伟 on 16/5/12.
//  Copyright © 2016年 Jiuhuar. All rights reserved.
//

#import "MWTextView.h"

@interface MWTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) NSMutableDictionary *defaultAttributes;

@end

@implementation MWTextView

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:16.f];

    [self addSubview:self.placeHolderLabel];
    [self sendSubviewToBack:_placeHolderLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)textChanged:(NSNotification *)notification
{
    [self configPlaceHolder];
    [self configStyles];
}

#pragma mark - Event
- (void)configPlaceHolder
{
    if (!_attributedPlaceholder) {
        return;
    }

    if ([MWTextView isNullString:self.text] && self.placeHolderLabel.alpha == 1.f) {
        return;
    }

    UIEdgeInsets insets = self.textContainerInset;

    _placeHolderLabel.attributedText = _attributedPlaceholder;
    [_placeHolderLabel sizeToFit];
    [_placeHolderLabel setFrame:CGRectMake(insets.left + 5, insets.top, self.bounds.size.width - (insets.left + insets.right + 10), CGRectGetHeight(_placeHolderLabel.frame))];

    self.placeHolderLabel.alpha = [MWTextView isNullString:self.text] ? 1.f : 0.f;
}

- (void)configStyles
{
    if (self.markedTextRange) {
        return;
    }
    
    if (!_regexAttributes || _regexAttributes.count == 0) {
        return;
    }

    NSString *str = self.text.mutableCopy;

    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:str attributes:self.defaultAttributes];

    for (NSString *key in _regexAttributes) {
        NSRegularExpression *regex = [NSRegularExpression
            regularExpressionWithPattern:key
                                 options:0
                                   error:nil];

        NSDictionary *attributes = _regexAttributes[key];

        NSArray *atResults = [regex matchesInString:str options:kNilOptions range:NSMakeRange(0, str.length)];
        for (NSTextCheckingResult *at in atResults) {
            if (at.range.location == NSNotFound && at.range.length <= 1)
                continue;
            NSRange matchRange = at.range;
            [aStr addAttributes:attributes range:matchRange];
        }
    }

    self.attributedText = aStr;
}

#pragma mark - Setter/Getter
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];

    if (_placeHolderLabel) {
        [_placeHolderLabel setFrame:CGRectMake(textContainerInset.left + 5, textContainerInset.top, self.bounds.size.width - (textContainerInset.left + textContainerInset.right + 10), CGRectGetHeight(_placeHolderLabel.frame))];
    }
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    if (_attributedPlaceholder != attributedPlaceholder) {
        _attributedPlaceholder = attributedPlaceholder;
        [self textChanged:nil];
    }
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.defaultAttributes setObject:self.font forKey:NSFontAttributeName];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    [self.defaultAttributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
}

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        UIEdgeInsets insets = self.textContainerInset;
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left + 5, insets.top, self.bounds.size.width - (insets.left + insets.right + 10), 1.0)];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.alpha = 0;
        _placeHolderLabel.tag = 999;
    }
    return _placeHolderLabel;
}

- (NSMutableDictionary *)defaultAttributes
{
    if (!_defaultAttributes) {
        _defaultAttributes = [@{} mutableCopy];
    }
    return _defaultAttributes;
}

#pragma mark - Private
+ (BOOL)isNullString:(id)tmp
{
    if (tmp == nil || tmp == NULL) {
        return YES;
    }
    if ([tmp isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@", tmp] length] == 0) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@", tmp] isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

@end
