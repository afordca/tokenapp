//
//  PTKContentDetailTableViewController.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/19/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "PFQueryTableViewController.h"

@interface PTKContentDetailTableViewController : PFQueryTableViewController <UITextFieldDelegate, UIActionSheetDelegate, PTKPhotoDetailsHeaderViewDelegate,PTKBaseTextCellDelegate>

@property (nonatomic, strong) PFObject *photo;

-(id)initWithPhoto: (PFObject*)aPhoto;

@end
