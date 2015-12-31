#import <UIKit/UIKit.h>
#import "CCFForm.h"

@interface FormViewController : UIViewController

@property(nonatomic, strong) NSArray *cities;

@property(nonatomic, strong) NSArray *sectionTitles;
@property(nonatomic, strong) NSArray<CCFForm*> *provinces;


@property(nonatomic, strong) NSMutableSet *downloadingItems;
@property(nonatomic, strong) NSMutableDictionary *downloadStages;

@property(nonatomic, assign) BOOL needReloadWhenDisappear;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *offlineNavigationBar;

- (IBAction)backClick:(UIBarButtonItem *)sender;

@end
