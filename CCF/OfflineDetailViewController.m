
#import "MAHeaderView.h"
#import "OfflineDetailViewController.h"
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

@interface OfflineDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MAHeaderViewDelegate> {
  char *_expandedSections;
  UIImage *_download;
  UIImage *_pause;
  UIImage *_delete;
    
    CGRect orgTopFrame;
    
    CGRect screenFrame;
}
@end




@implementation OfflineDetailViewController
@synthesize tableView = _tableView;
@synthesize provinces = _provinces;
@synthesize downloadingItems = _downloadingItems;
@synthesize downloadStages = _downloadStages;
@synthesize needReloadWhenDisappear = _needReloadWhenDisappear;


#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        [self setupCities];
        
        [self setupTitle];
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
    
    UILabel *prompts = [[UILabel alloc] init];
    prompts.text = [NSString stringWithFormat:@"默认关键字是\"%@\", 结果在console打印", kDefaultSearchkey];
    //    prompts.textAlignment   = UITextAlignmentCenter;
    prompts.textAlignment = NSTextAlignmentCenter;
    prompts.backgroundColor = [UIColor clearColor];
    prompts.textColor = [UIColor whiteColor];
    prompts.font = [UIFont systemFontOfSize:15];
    [prompts sizeToFit];
    
    UIBarButtonItem *promptsItem = [[UIBarButtonItem alloc] initWithCustomView:prompts];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, promptsItem, flexbleItem, flexbleItem, nil];
}

- (void)initTableView {
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setupCities {
    self.sectionTitles = @[ @"全国", @"直辖市", @"省份" ];
    
    //  self.cities = [MAOfflineMap sharedOfflineMap].cities;
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ccf" ofType:@"json"];
    CCFFormTree * ccfFromTree = [[[CCFFormDao alloc]init] parseCCFForms:path];
    
    // 省份
    self.provinces = ccfFromTree.ccfforms;//[ccfFromTree filterByCCFUser:NO];//[MAOfflineMap sharedOfflineMap].provinces;
    // 自治区
    //  self.municipalities = [MAOfflineMap sharedOfflineMap].municipalities;
    
    self.downloadingItems = [NSMutableSet set];
    self.downloadStages = [NSMutableDictionary dictionary];
    
    if (_expandedSections != NULL) {
        free(_expandedSections);
        _expandedSections = NULL;
    }
    
    _expandedSections = (char *)malloc( (self.sectionTitles.count + self.provinces.count) * sizeof(char));
    
    memset(_expandedSections, 0, (self.sectionTitles.count + self.provinces.count) * sizeof(char));
}

- (void)setupTitle {
    self.navigationItem.title = @"Titlellllll";
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




//- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath == nil) {
//    return nil;
//  }
//
//  MAOfflineItem *item = nil;
//
//  switch (indexPath.section) {
//    case 0: {
//      item = [MAOfflineMap sharedOfflineMap].nationWide;
//      break;
//    }
//    case 1: {
//      item = self.municipalities[indexPath.row];
//      break;
//    }
//    case 2: {
//      item = nil;
//      break;
//    }
//    default: {
//      MAOfflineProvince *pro = self.provinces[indexPath.section - self.sectionTitles.count];
//
//      if (indexPath.row == 0) {
//        item = pro;  // 添加整个省
//      } else {
//        item = pro.cities[indexPath.row - 1];  // 添加市
//      }
//
//      break;
//    }
//  }
//
//  return item;
//}

- (UIButton *)buttonWithImage:(UIImage *)image tag:(NSUInteger)tag {
    
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
  [button setImage:image forState:UIControlStateNormal];
  button.tag = tag;
  button.center = CGPointMake((kButtonCount - tag + 0.5) * kButtonSize, kButtonSize * 0.5);


  return button;
}

- (UIView *)accessoryView {
    
  UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize * kButtonCount, kButtonSize)];
  UIButton *downloadButton = [self buttonWithImage:[self downloadImage] tag:kTagDownloadButton];
  UIButton *pauseButton = [self buttonWithImage:[self pauseImage] tag:kTagPauseButton];
  UIButton *deleteButton = [self buttonWithImage:[self deleteImage] tag:kTagDeleteButton];

  [accessory addSubview:downloadButton];
  [accessory addSubview:pauseButton];
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
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0,
                                                                CGRectGetWidth(headerView.bounds),
                                                                CGRectGetHeight(headerView.bounds))];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = theTitle;
        lb.textColor = [UIColor whiteColor];
        
        [headerView addSubview:lb];
        
        return headerView;
    } else {
//        MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
//        theTitle = pro.name;
        
        MAHeaderView *headerView = [[MAHeaderView alloc]
                                    initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds),
                                                             kTableCellHeight)
                                    expanded:_expandedSections[section]];
        
        theTitle = @"00000000000";
        headerView.section = section;
        headerView.text = theTitle;
        headerView.delegate = self;
        
        return headerView;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sectionTitles.count + self.provinces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  NSInteger number = 0;

  switch (section) {
    case 0: {
      number = 1;
      break;
    }
//    case 1: {
//      number = self.municipalities.count;
//      break;
//    }
    default: {
      if (_expandedSections[section]) {
//        MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
//        // 加1用以下载整个省份的数据
//        number = pro.cities.count + 1;
          number = 5;
      }
      break;
    }
  }

  return number;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cityCellIdentifier = @"cityCellIdentifier";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellIdentifier];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryView = [self accessoryView];
  }

//  MAOfflineItem *item = [self itemForIndexPath:indexPath];
//  [self updateCell:cell forItem:item];

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section < self.sectionTitles.count) {
    cell.backgroundColor = [UIColor whiteColor];
  } else {
    cell.backgroundColor = [UIColor lightGrayColor];
  }
}

#pragma mark - ImageResource
- (UIImage *)downloadImage {
  if (_download == nil) {
    _download = [UIImage imageNamed:@"ic_get_app_18pt"];
  }
  return _download;
}

- (UIImage *)pauseImage {
  if (_pause == nil) {
    _pause = [UIImage imageNamed:@"ic_query_builder_18pt"];
  }
  return _pause;
}

- (UIImage *)deleteImage {
  if (_delete == nil) {
    _delete = [UIImage imageNamed:@"ic_delete_18pt"];
  }
  return _delete;
}

#pragma mark - MAHeaderViewDelegate

- (void)headerView:(MAHeaderView *)headerView
           section:(NSInteger)section
          expanded:(BOOL)expanded {
  _expandedSections[section] = expanded;

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                withRowAnimation:UITableViewRowAnimationNone];
}




- (IBAction)backClick:(UIBarButtonItem *)sender {
    
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end






