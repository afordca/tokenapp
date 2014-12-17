//
//  HomeFeedViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/11/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "Macros.h"
#import "CustomActivityTableViewCell.h"


@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayOfFollowing;
@property NSMutableArray *arrayOfImages;
@property NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *date;
@property NSString *dateDiff;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.arrayOfImages = [NSMutableArray new];

    PFQuery *query = [[[PFUser currentUser] relationForKey:@"followingRelation"] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.arrayOfFollowing = objects;
        PFQuery *queryOfImages = [PFQuery queryWithClassName:@"UserPhoto"];
        [queryOfImages orderByDescending:@"createdAt"];
        [queryOfImages findObjectsInBackgroundWithBlock:^(NSArray *objectsTwo, NSError *error) {
            for (PFObject *images in objectsTwo) {
                for (PFUser *user in self.arrayOfFollowing) {
                    if ([[images objectForKey:@"author"] isEqualToString:user.username]) {
                        [self.arrayOfImages addObject:images];

                    }
                }
            }
            [self.tableView reloadData];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    PFObject *image = self.arrayOfImages[indexPath.row];

    PFFile *parseFileWithImage = [image objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cell.imageViewForPhotos.image = [UIImage imageWithData:data];
    }];

    PFFile *parseFileWithImageProfile = [image objectForKey:@"imageProfile"];
    NSURL *urlProfile = [NSURL URLWithString:parseFileWithImageProfile.url];
    NSURLRequest *requestURLProfile = [NSURLRequest requestWithURL:urlProfile];
    [NSURLConnection sendAsynchronousRequest:requestURLProfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cell.imageViewProfileImage.image = [UIImage imageWithData:data];
    }];

    PFQuery *queryOfLikes = [PFQuery queryWithClassName:@"Likes"];
    [queryOfLikes whereKey:@"objectIdImage" equalTo:image.objectId];
    [queryOfLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        cell.labelNumberOfLikes.text = [NSString stringWithFormat:@"%d likes ♥︎", objects.count];
    }];

    PFQuery *queryOfComments = [PFQuery queryWithClassName:@"Comments"];
    [queryOfComments whereKey:@"objectIdImage" equalTo:image.objectId];
    [queryOfComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        cell.labelComments.text = [NSString stringWithFormat:@"%d comments", objects.count];
    }];

    //Todays Date
    NSDate *today = [[NSDate alloc] init];

    //Testing Date
    //    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    //	[tempFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    //	NSDate *temp = [tempFormatter dateFromString:@"2014-08-19 09:00:00"];

    //Image Taken Date
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    NSString *imageDate = [df stringFromDate:image.createdAt];

    NSDate *imagePostedOn = [[NSDate alloc] init];
    imagePostedOn = [df dateFromString:imageDate];

    //Formula to get date difference
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:imagePostedOn toDate:today options:0];

    NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:imagePostedOn];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;

    //Return hours if image was taken today or in days
    if ([components day] == 0)
    {
        self.dateDiff = [NSString stringWithFormat:@"%ldh ago", (long)hoursBetweenDates];
    }
    else {
        self.dateDiff = [NSString stringWithFormat:@"%ld ago", (long)[components day]];
    }

    cell.labelTimer.text = self.dateDiff;

    cell.labelUsername.text = [image objectForKey:@"author"];
    cell.labelImageDescription.text = [image objectForKey:@"photoCaption"];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    return indexPath;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
