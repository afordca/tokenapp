//
//  TKAccountViewController.h
//  
//
//  Created by BASEL FARAG on 12/24/14.
//
//

#import "TKContentTimelineViewController.h"


@interface TKAccountViewController : TKContentTimelineViewController

@property (nonatomic, strong) PFUser *user;

-(id)initWithUser:(PFUser *)aUser;

@end
