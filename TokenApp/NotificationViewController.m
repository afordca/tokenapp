//
//  NotificationViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/25/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationsTableViewCell.h"
#import "Notifications.h"

@interface NotificationViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewNotifications;

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewNotifications.delegate = self;
    user = [User sharedSingleton];
}

#pragma mark - UITableView Delegate Methods

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Comments";
    }
    else if (section == 1)
    {
        return @"Likes";
    }
    else if (section == 2)
    {
        return @"Tags";
    }
    return @"Error";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return user.arrayOfNotificationComments.count;
    }
    else if (section == 1)
    {
        return user.arrayOfNotificationLikes.count;
    }
    else if (section == 2)
    {
        return user.arrayOfNotificationTags.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellnotification"];

    Notifications *notification = [Notifications new];

    //Comments
    if (indexPath.section == 0)
    {
        notification = [user.arrayOfNotificationComments objectAtIndex:indexPath.row];
        NSString *stringUsername = notification.stringUsername;
        NSString *stringType = notification.stringType;
        NSString *stringMediaType = notification.stringMediaType;

        cell.imageViewProfilePic.image = notification.imageProfilePic;
        cell.labelNoticationMessage.text =[notification createNotification:stringUsername type:stringType mediatype:stringMediaType];

        return cell;

    }
    //Likes
    else if (indexPath.section == 1)
    {
        notification = [user.arrayOfNotificationLikes objectAtIndex:indexPath.row];
        NSString *stringUsername = notification.stringUsername;
        NSString *stringType = notification.stringType;
        NSString *stringMediaType = notification.stringMediaType;

        cell.imageViewProfilePic.image = notification.imageProfilePic;
        cell.labelNoticationMessage.text =[notification createNotification:stringUsername type:stringType mediatype:stringMediaType];

        return cell;
    }
    //Tags
    else if (indexPath.section == 2)
    {
        notification = [user.arrayOfNotificationTags objectAtIndex:indexPath.row];
        NSString *stringUsername = notification.stringUsername;
        NSString *stringType = notification.stringType;
        NSString *stringMediaType = notification.stringMediaType;

        cell.imageViewProfilePic.image = notification.imageProfilePic;
        cell.labelNoticationMessage.text =[notification createNotification:stringUsername type:stringType mediatype:stringMediaType];

        return cell;

    }

    return cell;
}

@end
