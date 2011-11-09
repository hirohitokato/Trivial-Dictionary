//
//  KSDetailViewController.h
//  InDict
//
//  Created by 加藤 寛人 on 11/11/09.
//  Copyright (c) 2011年 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
