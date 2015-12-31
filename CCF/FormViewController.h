#import <UIKit/UIKit.h>
#import "CCFForm.h"

@interface FormViewController : UIViewController


@property(nonatomic, strong) NSArray *sectionTitles;
@property(nonatomic, strong) NSArray<CCFForm*> *ccfForms;
@property(nonatomic, strong) NSArray<CCFForm*> *favForms;


@property(nonatomic, assign) BOOL needReloadWhenDisappear;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *offlineNavigationBar;

- (IBAction)backClick:(UIBarButtonItem *)sender;

@end
