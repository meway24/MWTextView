//
//  MWTextView.h
//  jiuhuar
//
//  Created by 孟伟 on 16/5/12.
//  Copyright © 2016年 Jiuhuar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWTextView : UITextView

@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;

@property (nonatomic, strong) NSDictionary *regexAttributes;

@end
