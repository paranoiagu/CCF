
#import "MAHeaderView.h"
#import "FormViewController.h"
#import "CCFFormDao.h"
#import "CCFFormTree.h"


#define kDefaultSearchkey @"bj"
#define kSectionHeaderMargin 15.f
#define kSectionHeaderHeight 22.f
#define kTableCellHeight 42.f
#define kTagDownloadButton 0
#define kTagPauseButton 1
#define kTagDeleteButton 2
#define kButtonSize 30.f
#define kButtonCount 3

NSString const *DownloadStageIsRunningKey2 = @"DownloadStageIsRunningKey";
NSString const *DownloadStageStatusKey2 = @"DownloadStageStatusKey";
NSString const *DownloadStageInfoKey2 = @"DownloadStageInfoKey";

@interface FormViewController ()<UITableViewDataSource, UITableViewDelegate, MAHeaderViewDelegate> {
  
    char *_expandedSections;
  
    UIImage *_delete;
    
    CGRect orgTopFrame;
    
    CGRect screenFrame;
}
@end




@implementation FormViewController


@synthesize tableView = _tableView;
@synthesize ccfForms = _ccfForms;
@synthesize favForms = _favForms;
@synthesize needReloadWhenDisappear = _needReloadWhenDisappear;


#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        [self initForms];
    }
    
    return self;
}

- (void)dealloc {
    free(_expandedSections);
    _expandedSections = NULL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = NO;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.needReloadWhenDisappear) {
        
        self.needReloadWhenDisappear = NO;
    }
}

#pragma mark - Initialization

- (void)initNavigationBar {
    screenFrame = [ UIScreen mainScreen ].bounds;
    
    orgTopFrame = _offlineNavigationBar.frame;
    
    orgTopFrame.size.height = 20 + 44;
    orgTopFrame.origin.y = 0;
    
    _offlineNavigationBar.frame = orgTopFrame;
    
}

- (void)initToolBar {
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:self
                                    action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, flexbleItem, flexbleItem, nil];
}

- (void)initTableView {
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initForms {
    self.sectionTitles = @[ @"我的收藏", @"全部板块" ];

    
    self.favForms = [NSArray array];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ccf" ofType:@"json"];
    CCFFormTree * ccfFromTree = [[[CCFFormDao alloc]init] parseCCFForms:path];

    self.ccfForms = ccfFromTree.ccfforms;
    
    
    if (_expandedSections != NULL) {
        free(_expandedSections);
        _expandedSections = NULL;
    }
    
    _expandedSections = (char *)malloc( (self.sectionTitles.count + self.ccfForms.count) * sizeof(char));
    
    memset(_expandedSections, 0, (self.sectionTitles.count + self.ccfForms.count) * sizeof(char));
}



#pragma mark - Utility

- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event {
  UIButton *button = (UIButton *)sender;

  UITouch *touch = [[event allTouches] anyObject];

  if (![button pointInside:[touch locationInView:button] withEvent:event]) {
    return nil;
  }

  CGPoint touchPosition = [touch locationInView:self.tableView];

  return [self.tableView indexPathForRowAtPoint:touchPosition];
}


- (UIButton *)buttonWithImage:(UIImage *)image tag:(NSUInteger)tag {
    
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
  [button setImage:image forState:UIControlStateNormal];
  button.tag = tag;
  button.center = CGPointMake((kButtonCount - tag + 0.5) * kButtonSize, kButtonSize * 0.5);


  return button;
}

- (UIView *)accessoryView {
    
  UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize * kButtonCount, kButtonSize)];
  UIButton *deleteButton = [self buttonWithImage:[self deleteImage] tag:kTagDeleteButton];

  [accessory addSubview:deleteButton];

  return accessory;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return section < self.sectionTitles.count ? kSectionHeaderHeight : kTableCellHeight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *theTitle = nil;
    
    if (section < self.sectionTitles.count) {
        theTitle = self.sectionTitles[section];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), kSectionHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(headerView.bounds), CGRectGetHeight(headerView.bounds))];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = theTitle;
        lb.textColor = [UIColor whiteColor];
        
        [headerView addSubview:lb];
        
        return headerView;
    } else {
        CCFForm *pro = self.ccfForms[section - self.sectionTitles.count];
        
        theTitle = [pro valueForKey:@"formName"];
        
        MAHeaderView *headerView = [[MAHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), kTableCellHeight) expanded:_expandedSections[section]];
        
        headerView.section = section;
        headerView.text = theTitle;
        headerView.delegate = self;
        
        return headerView;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sectionTitles.count + self.ccfForms.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"numberOfRowsInSection  %ld", section);
    if (section == 0) {
        // 我的收藏
        return self.favForms.count;
    } else{
        // 所有论坛
        // return self.ccfForms.count;
        
        if (_expandedSections[section]) {
            CCFForm *pro = self.ccfForms[section - self.sectionTitles.count];
            return [[pro valueForKey:@"childForms"]count];
        }
        
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cityCellIdentifier = @"cityCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [self accessoryView];
    }
  
    CCFForm *item = [self itemForIndexPath:indexPath];

    
    if (item != nil) {
        cell.textLabel.text = [item valueForKey:@"formName"];
    }
    
    NSLog(@"cellForRowAtIndexPath ->> %ld      -->> raw : %ld", indexPath.section, indexPath.row);
    return cell;
}

- (CCFForm *)itemForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return nil;
    }
    
    if (indexPath.section < self.sectionTitles.count) {
        // 我的收藏
        return self.favForms[indexPath.row];
    } else{
        CCFForm *pro = self.ccfForms[indexPath.section - self.sectionTitles.count];
        
        return [pro valueForKey:@"childForms"][indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section < self.sectionTitles.count) {
    cell.backgroundColor = [UIColor whiteColor];
  } else {
    cell.backgroundColor = [UIColor lightGrayColor];
  }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //CCFForm * selete = [self itemForIndexPath:indexPath];
    
    NSLog(@"%ld     ,     %ld", indexPath.section, indexPath.row);
}


#pragma mark - ImageResource
- (UIImage *)deleteImage {
  if (_delete == nil) {
    _delete = [UIImage imageNamed:@"ic_delete_18pt"];
  }
  return _delete;
}


#pragma mark - MAHeaderViewDelegate
- (void)headerView:(MAHeaderView *)headerView section:(NSInteger)section expanded:(BOOL)expanded {
  _expandedSections[section] = expanded;

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}




- (IBAction)backClick:(UIBarButtonItem *)sender {
    
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end






