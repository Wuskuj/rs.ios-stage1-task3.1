#import "ViewController.h"

int const LABEL_WIDTH = 80;
int const LABEL_HEIGHT = 40;
int const LABEL_X = 20;
int const LABEL_VIEW_Y = 90;

int const VIEW_X = 140;


@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *labelResultColor;
@property (nonatomic, strong) UILabel *labelRed;
@property (nonatomic, strong) UILabel *labelGreen;
@property (nonatomic, strong) UILabel *labelBlue;

@property (nonatomic, strong) UIView *viewResultColor;

@property(nonatomic, strong) UITextField *textFieldRed;
@property(nonatomic, strong) UITextField *textFieldGreen;
@property(nonatomic, strong) UITextField *textFieldBlue;

@property (nonatomic,strong) UIButton *buttonProcess;
@end


@implementation ViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLabels];
    [self setupView];
    [self setupTextFields];
    [self setupButton];
    [self accessibilityIdentifierFunc];
}


#pragma mark - Setup elements

-(void)setupLabels {
    self.labelResultColor = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_VIEW_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    self.labelRed = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_VIEW_Y + 60, LABEL_WIDTH, LABEL_HEIGHT)];
    self.labelGreen = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_VIEW_Y + 120, LABEL_WIDTH, LABEL_HEIGHT)];
    self.labelBlue = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_VIEW_Y + 180, LABEL_WIDTH, LABEL_HEIGHT)];
    
    self.labelResultColor.minimumScaleFactor = 0.5;
    self.labelResultColor.adjustsFontSizeToFitWidth = true;
    
    NSArray<UILabel *> *labelsArray = @[self.labelResultColor, self.labelRed, self.labelGreen, self.labelBlue];
    NSArray *titles = @[@"Color", @"RED", @"GREEN", @"BLUE"];
    for (int i = 0; i < labelsArray.count; i++) {
        labelsArray[i].text = titles[i];
        labelsArray[i].font = [UIFont fontWithName:@"Arial" size:17];
        [self.view addSubview:labelsArray[i]];
    }
}

-(void)setupView {
    self.viewResultColor = [[UIView alloc] initWithFrame:CGRectMake(VIEW_X, LABEL_VIEW_Y, self.view.bounds.size.width - VIEW_X - 35, 40)];
    self.viewResultColor.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.viewResultColor];
}

-(void)setupTextFields {
    int widthTF = self.view.bounds.size.width - VIEW_X - 15;
    self.textFieldRed = [[UITextField alloc] initWithFrame:CGRectMake(VIEW_X - 20, LABEL_VIEW_Y + 60, widthTF, 40)];
    self.textFieldGreen = [[UITextField alloc] initWithFrame:CGRectMake(VIEW_X - 20, LABEL_VIEW_Y + 120, widthTF, 40)];
    self.textFieldBlue = [[UITextField alloc] initWithFrame:CGRectMake(VIEW_X - 20, LABEL_VIEW_Y + 180, widthTF, 40)];
    NSArray<UITextField *> *textFieldsArray = @[self.textFieldRed,self.textFieldGreen,self.textFieldBlue];
    for (UITextField *textField in textFieldsArray) {
        textField.delegate = self;
        textField.placeholder = @"0..255";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
    }
    
}


-(void)setupButton {
    self.buttonProcess = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 35, LABEL_VIEW_Y + 250, 70, 40)];
    [self.buttonProcess setTitle:@"Process" forState:UIControlStateNormal];
    [self.buttonProcess setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonProcess setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.buttonProcess addTarget:self action:@selector(didTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonProcess];
}


#pragma mark - Selector
-(void)didTap {
    
    if (![self validationFunc:self.textFieldRed] || ![self validationFunc:self.textFieldGreen] || ![self validationFunc:self.textFieldBlue]) {
        self.labelResultColor.text = @"Error";
        self.viewResultColor.backgroundColor = UIColor.clearColor;
    }else {
        self.viewResultColor.backgroundColor = [self setBackgroundColorView];
        self.labelResultColor.text = [self hexStringForColor:[self setBackgroundColorView]];
    }
    
    [self clearTextFields];
}


#pragma mark - Work with textFields

-(BOOL)validationFunc:(UITextField *)textField {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet new];
    [characterSet formUnionWithCharacterSet:NSCharacterSet.decimalDigitCharacterSet];
    [characterSet invert];
    NSRange range = [textField.text rangeOfCharacterFromSet:characterSet];
    if (range.location != NSNotFound) {
        return NO;
    }
    if ([textField.text intValue] < 0 || [textField.text intValue] > 255 || [textField.text  isEqual: @""]) {
        return NO;
    }
    return YES;
}

-(void)clearTextFields {
    NSArray<UITextField *> *textFieldsArray = @[self.textFieldRed,self.textFieldGreen,self.textFieldBlue];
    for (UITextField *tf in textFieldsArray) {
        if ([tf isFirstResponder]) {
            [tf resignFirstResponder];
            break;
        }
    }
    for (UITextField *tf in textFieldsArray) {
        tf.text = @"";
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.labelResultColor.text = @"Color";
    return YES;
}



#pragma mark - Color

-(UIColor*)setBackgroundColorView {
    float red = [self.textFieldRed.text floatValue];
    float green = [self.textFieldGreen.text floatValue];
    float blue = [self.textFieldBlue.text floatValue];
    UIColor *color = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
    return color;
}

- (NSString *)hexStringForColor:(UIColor *)color {
      const CGFloat *components = CGColorGetComponents(color.CGColor);
      CGFloat r = components[0];
      CGFloat g = components[1];
      CGFloat b = components[2];
      NSString *hexString=[NSString stringWithFormat:@"0x%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
      return hexString;
}



#pragma mark - Identifier for elements

-(void)accessibilityIdentifierFunc {

    self.view.accessibilityIdentifier = @"mainView";
    self.viewResultColor.accessibilityIdentifier = @"viewResultColor";
    
    self.labelResultColor.accessibilityIdentifier = @"labelResultColor";
    self.labelRed.accessibilityIdentifier = @"labelRed";
    self.labelBlue.accessibilityIdentifier = @"labelBlue";
    self.labelGreen.accessibilityIdentifier = @"labelGreen";
    
    self.textFieldRed.accessibilityIdentifier = @"textFieldRed";
    self.textFieldGreen.accessibilityIdentifier = @"textFieldGreen";
    self.textFieldBlue.accessibilityIdentifier = @"textFieldBlue";
    
    self.buttonProcess.accessibilityIdentifier = @"buttonProcess";
}
@end
