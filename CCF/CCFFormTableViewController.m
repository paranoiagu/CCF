
//  MyTableViewController.m
//  MyTableView
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFormTableViewController.h"

#import "CCFThreadViewCell.h"
#import "CCFFormSectionInfo.h"
#import "CCFFormHeaderView.h"
#import "CCFFormDao.h"

#import <AFNetworking.h>
#import <IGHTMLQuery.h>
#import "CCFUser.h"
#import "CCFPost.h"
#import "CCFThreadDetail.h"

#import "LoginViewController.h"

#import "CCFParser.h"

#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"

#import "CCFFormDao.h"

#import "CCFFormTreeJSONModel.h"


#import "CCFFormTableViewController.h"
#import "CCFThreadListTableViewController.h"
#import "CCFEntry.h"
#import "DrawerView.h"

#import "CCFUtils.h"

#import "CCFCoreDataManager.h"
#import "FormEntry+CoreDataProperties.h"


@interface MyAPLEmailMenuItem : UIMenuItem
@property (nonatomic) NSIndexPath *indexPath;
@end

@implementation MyAPLEmailMenuItem
@end


#pragma mark - MyTableViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface CCFFormTableViewController ()

@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSIndexPath *pinchedIndexPath;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CGFloat initialPinchHeight;

@property (nonatomic) IBOutlet CCFFormHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;



@end


#pragma mark -

#define DEFAULT_ROW_HEIGHT 48
#define HEADER_HEIGHT 48


@implementation CCFFormTableViewController


@synthesize forms = _forms ;
@synthesize leftDrawerView = _leftDrawerView;



- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


#pragma mark CCFEntryDelegate
-(void)transValue:(CCFEntry *)value{
    
}



#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initplays];
    
    // Add a pinch gesture recognizer to the table view.
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:pinchRecognizer];
    
    // Set up default values.
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    /*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */
    self.uniformRowHeight = DEFAULT_ROW_HEIGHT;
    self.openSectionIndex = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"CCFFormHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    _leftDrawerView = [[DrawerView alloc] initWithDrawerType:DrawerViewTypeLeft andXib:@"DrawerView"];
    [self.navigationController.view addSubview:_leftDrawerView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
        
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        
        for (CCFForm *play in self.forms) {
            
            CCFFormSectionInfo *sectionInfo = [[CCFFormSectionInfo alloc] init];
            sectionInfo.forms = play;
            sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSInteger countOfQuotations = [[sectionInfo.forms valueForKey:@"childForms" ] count];
            for (NSInteger i = 0; i < countOfQuotations; i++) {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            
            [infoArray addObject:sectionInfo];
        }
        
        self.sectionInfoArray = infoArray;
    }
}

- (void)initplays {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ccf" ofType:@"json"];
    NSArray<CCFFormJSONModel*> * forms = [[[CCFFormDao alloc]init] parseCCFForms:path];
    
    self.forms = [forms mutableCopy];
    
    
    
    NSMutableArray<CCFFormJSONModel *> * needInsert = [NSMutableArray array];
    
    for (CCFFormJSONModel *form in self.forms) {
        [needInsert addObject:form];
        
        NSMutableArray<CCFFormJSONModel> * childForms = [form valueForKey:@"childForms"];
        
        if (childForms != nil && childForms.count > 0) {
            
            for (CCFFormJSONModel * child in childForms) {
                [needInsert addObject:child];
            }
        }
    }
    
    CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];

    [manager insertData:needInsert operation:^(NSManagedObject *target, id src) {
        FormEntry *newsInfo = (FormEntry*)target;
        newsInfo.formId = [src valueForKey:@"formId"];
        newsInfo.formName = [src valueForKey:@"formName"];
        newsInfo.parentFormId = [src valueForKey:@"parentFormId"];
    }];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CCFThreadListTableViewController * controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setEntry:)]) {
        
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSLog(@"prepareForSegue %ld      %ld   ", path.section, path.row);
        
        CCFFormJSONModel * select = [self.forms[path.section] valueForKey:@"childForms"][path.row];
        
        CCFEntry * entry = [[CCFEntry alloc]init];
        
        entry.urlId = [select valueForKey:@"formId"];
        
        entry.page = @"1";
        
        [controller setValue:entry forKey:@"entry"];

        NSLog(@"prepareForSegue ");
        
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.forms count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = [[sectionInfo.forms valueForKey:@"childForms" ] count];
    
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
    
    CCFThreadViewCell *cell = (CCFThreadViewCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CCFThreadViewCell" owner:self options:nil];
        
        cell = [nib lastObject];
        
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        if (cell.longPressRecognizer == nil) {
            UILongPressGestureRecognizer *longPressRecognizer =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            cell.longPressRecognizer = longPressRecognizer;
        }
    }
    else {
        cell.longPressRecognizer = nil;
    }
    
    CCFFormJSONModel *play = (CCFFormJSONModel *)[(self.sectionInfoArray)[indexPath.section] forms];
    cell.quotation = [play valueForKey:@"childForms"][indexPath.row];//(play.quotations)[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CCFFormHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    sectionHeaderView.titleLabel.text = [sectionInfo.forms valueForKey:@"formName"];
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"didSelectRowAtIndexPath %ld,   %ld ", indexPath.section, indexPath.row);
//    [self performSegueWithIdentifier:@"ToThreadList" sender:self.view];
    
}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(CCFFormHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [[sectionInfo.forms valueForKey:@"childForms" ] count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        CCFFormSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [[previousOpenSection.forms valueForKey:@"childForms" ] count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(CCFFormHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma mark - Handling pinches

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchRecognizer {
    
    /*
     There are different actions to take for the different states of the gesture recognizer.
     * In the Began state, use the pinch location to find the index path of the row with which the pinch is associated, and keep a reference to that in pinchedIndexPath. Then get the current height of that row, and store as the initial pinch height. Finally, update the scale for the pinched row.
     * In the Changed state, update the scale for the pinched row (identified by pinchedIndexPath).
     * In the Ended or Canceled state, set the pinchedIndexPath property to nil.
     */
    
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pinchLocation = [pinchRecognizer locationInView:self.tableView];
        NSIndexPath *newPinchedIndexPath = [self.tableView indexPathForRowAtPoint:pinchLocation];
        self.pinchedIndexPath = newPinchedIndexPath;
        
        CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[newPinchedIndexPath.section];
        self.initialPinchHeight = [[sectionInfo objectInRowHeightsAtIndex:newPinchedIndexPath.row] floatValue];
        // Alternatively, set initialPinchHeight = uniformRowHeight.
        
        [self updateForPinchScale:pinchRecognizer.scale atIndexPath:newPinchedIndexPath];
    }
    else {
        if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
            [self updateForPinchScale:pinchRecognizer.scale atIndexPath:self.pinchedIndexPath];
        }
        else if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
            self.pinchedIndexPath = nil;
        }
    }
}


- (void)updateForPinchScale:(CGFloat)scale atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath && (indexPath.section != NSNotFound) && (indexPath.row != NSNotFound)) {
        
        CGFloat newHeight = round(MAX(self.initialPinchHeight * scale, DEFAULT_ROW_HEIGHT));
        
        CCFFormSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
        [sectionInfo replaceObjectInRowHeightsAtIndex:indexPath.row withObject:@(newHeight)];
        // Alternatively, set uniformRowHeight = newHeight.
        
        /*
         Switch off animations during the row height resize, otherwise there is a lag before the user's action is seen.
         */
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}


#pragma mark - Handling long presses

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    
    /*
     For the long press, the only state of interest is Began.
     When the long press is detected, find the index path of the row (if there is one) at press location.
     If there is a row at the location, create a suitable menu controller and display it.
     */
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *pressedIndexPath =
        [self.tableView indexPathForRowAtPoint:[longPressRecognizer locationInView:self.tableView]];
        
        if (pressedIndexPath && (pressedIndexPath.row != NSNotFound) && (pressedIndexPath.section != NSNotFound)) {
            
            [self becomeFirstResponder];
            NSString *title = NSLocalizedString(@"Email", @"Email menu title");
            MyAPLEmailMenuItem *menuItem =
            [[MyAPLEmailMenuItem alloc] initWithTitle:title action:@selector(emailMenuButtonPressed:)];
            menuItem.indexPath = pressedIndexPath;
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            menuController.menuItems = @[menuItem];
            
            CGRect cellRect = [self.tableView rectForRowAtIndexPath:pressedIndexPath];
            // lower the target rect a bit (so not to show too far above the cell's bounds)
            cellRect.origin.y += 40.0;
            [menuController setTargetRect:cellRect inView:self.tableView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (void)emailMenuButtonPressed:(UIMenuController *)menuController {
    
    NSArray<UIMenuItem *> *menuItems = [[UIMenuController sharedMenuController] menuItems];
    if (menuItems != nil && menuItems.count > 0) {
        MyAPLEmailMenuItem *menuItem = (MyAPLEmailMenuItem *)menuItems[0];
        if (menuItem.indexPath) {
            [self resignFirstResponder];
            [self sendEmailForEntryAtIndexPath:menuItem.indexPath];
        }
    }
    
}

- (void)sendEmailForEntryAtIndexPath:(NSIndexPath *)indexPath {
    
    CCFFormJSONModel * selectForm = self.forms[indexPath.section];
    CCFForm *quotation = [selectForm valueForKey:@"childForms"][indexPath.row];
    
    // In production, send the appropriate message.
    NSLog(@"Send email using quotation:\n%@", [quotation valueForKey:@"formName"]);
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    if (result == MFMailComposeResultFailed) {
        // In production, display an appropriate message to the user.
        NSLog(@"Mail send failed with error: %@", error);
    }
}


- (IBAction)onLeftBarButtonItemClick:(UIBarButtonItem *)sender {
    [self.leftDrawerView openLeftDrawer];
}
@end
