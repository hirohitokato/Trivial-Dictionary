//
//  KSMasterViewController.h
//  InDict
//
//  Created by 加藤 寛人 on 11/11/09.
//  Copyright (c) 2011年 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSDetailViewController;

@interface KSMasterViewController : UITableViewController

@property (strong, nonatomic) KSDetailViewController *detailViewController;

@end
