//
//  BMContantViewController.h
//  BMAddressBook
//
//  Created by elvin on 16/8/16.
//  Copyright © 2016年 zhouhongji. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取通讯录信息
typedef void (^SelectedContantBlock)(NSString *userName,NSString *moblie);

@interface BMContantViewController : UIViewController

@property (copy, nonatomic) SelectedContantBlock selectedContantBlock;


@end
