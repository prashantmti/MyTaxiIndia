//
//  baseView.m
//  MyTaxiIndia
//
//  Created by mytaxiit on 10/16/15.
//  Copyright © 2015 mytaxiit. All rights reserved.
//

#import "baseView.h"

@interface baseView ()

@end

@implementation baseView

@synthesize datePicker;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(NSArray*)getLocationArray
{
    NSArray *locationArray;
    locationArray=[NSArray arrayWithObjects:@"Adilabad", @"Anantapur", @"Chittoor", @"East Godavari", @"Guntur", @"Hyderabad", @"YSR district", @"Karimnagar", @"Khammam", @"Krishna", @"Kurnool", @"Mahbubnagar", @"Medak", @"Nalgonda", @"Sri Potti Sri Ramulu Nellore", @"Nizamabad", @"Prakasam", @"Ranga Reddy", @"Srikakulam", @"Vishakhapatnam", @"Vizianagaram", @"Warangal", @"West Godavari", @"Anjaw", @"Changlang", @"East Kameng", @"East Siang", @"Lohit", @"Lower Subansiri", @"Papum Pare", @"Tawang", @"Tirap", @"Dibang Valley", @"Upper Siang", @"Upper Subansiri", @"West Kameng", @"West Siang", @"Kurung Kumey", @"Lower Dibang Valley", @"Barpeta", @"Bongaigaon", @"Cachar", @"Darrang", @"Dhemaji", @"Dhubri", @"Dibrugarh", @"Goalpara", @"Golaghat", @"Hailakandi", @"Jorhat", @"Karbi Anglong", @"Karimganj", @"Kokrajhar", @"Lakhimpur", @"Marigaon", @"Nagaon", @"Nalbari", @"Dima Hasao", @"Sibsagar", @"Sonitpur", @"Tinsukia", @"Araria", @"Arwal", @"Banka", @"Begusarai", @"Bhagalpur", @"Bhojpur", @"Buxar", @"Darbhanga", @"East Champaran", @"Gaya", @"Gopalganj", @"Jamui", @"Jehanabad", @"Khagaria", @"Kishanganj", @"Kaimur", @"Katihar", @"Lakhisarai", @"Madhubani", @"Munger", @"Madhepura", @"Muzaffarpur", @"Nalanda", @"Nawada", @"Patna", @"Purnia", @"Rohtas", @"Saharsa", @"Samastipur", @"Sheohar", @"Sheikhpura", @"Saran", @"Sagar(bihar)", @"Supaul", @"Siwan", @"Vaishali (Akshay)", @"West Champaran", @"Bastar", @"Bijapur(chhattisgarh)", @"Bilaspur(chhattisgarh)", @"Dantewada", @"Dhamtari", @"Durg", @"Jashpur", @"Janjgir-Champa", @"Korba", @"Koriya", @"Kanker", @"Kabirdham (formerly Kawardha)", @"Mahasamund", @"Narayanpur", @"Raigarh", @"Rajnandgaon", @"Raipur", @"Surajpur", @"Central Delhi", @"East Delhi", @"New Delhi", @"North Delhi", @"North East Delhi", @"North West Delhi", @"South Delhi", @"South West Delhi", @"West Delhi", @"Goa", @"Ahmedabad", @"Amreli district", @"Anand", @"Banaskantha", @"Bharuch", @"Bhavnagar", @"Dahod", @"The Dangs", @"Gandhinagar", @"Jamnagar", @"Junagadh", @"Kutch", @"Kheda", @"Mehsana", @"Narmada", @"Navsari", @"Patan", @"Panchmahal", @"Porbandar", @"Rajkot", @"Sabarkantha", @"Surendranagar", @"Surat", @"Vadodara", @"Valsad", @"Ambala", @"Bhiwani", @"Faridabad", @"Fatehabad", @"Gurgaon", @"Hissar", @"Jhajjar", @"Jind", @"Karnal", @"Kaithal", @"Kurukshetra", @"Mahendragarh", @"Mewat", @"Panchkula", @"Panipat", @"Rewari", @"Rohtak", @"Sirsa", @"Sonipat", @"Yamuna Nagar", @"Palwal", @"Bilaspur(hp)", @"Chamba", @"Hamirpur(hp)", @"Kangra", @"Kinnaur", @"Kullu", @"Lahaul and Spiti", @"Mandi", @"Shimla", @"Sirmaur", @"Solan", @"Una", @"Anantnag", @"Badgam", @"Bandipora", @"Baramulla", @"Doda", @"Ganderbal", @"Jammu", @"Kargil", @"Kathua", @"Kishtwar", @"Kupwara", @"Kulgam", @"Leh", @"Poonch", @"Pulwama", @"Rajauri", @"Ramban", @"Reasi", @"Samba", @"Shopian", @"Srinagar", @"Udhampur", @"Bokaro", @"Chatra", @"Deoghar", @"Dhanbad", @"Dumka", @"East Singhbhum", @"Garhwa", @"Giridih", @"Godda", @"Gumla", @"Hazaribag", @"Koderma", @"Lohardaga", @"Pakur", @"Palamu", @"Ranchi", @"Sahibganj", @"Seraikela Kharsawan", @"West Singhbhum", @"Ramgarh", @"Bidar", @"Belgaum", @"Bijapur(karnataka)", @"Bagalkot", @"Bellary", @"Bangalore Rural", @"Bangalore Urban", @"Chamarajnagar", @"Chikkamagaluru", @"Chitradurga", @"Davanagere", @"Dharwad", @"Dakshina Kannada", @"Gadag", @"Gulbarga", @"Hassan", @"Haveri district", @"Kodagu", @"Kolar", @"Koppal", @"Mandya", @"Mysore", @"Raichur", @"Shimoga", @"Tumkur", @"Udupi", @"Uttara Kannada", @"Ramanagara", @"Chikkaballapur", @"Yadgir", @"Alappuzha", @"Ernakulam", @"Idukki", @"Kollam", @"Kannur", @"Kasaragod", @"Kottayam", @"Kozhikode", @"Malappuram", @"Palakkad", @"Pathanamthitta", @"Thrissur", @"Thiruvananthapuram", @"Wayanad", @"Alirajpur", @"Anuppur", @"Ashok Nagar", @"Balaghat", @"Barwani", @"Betul", @"Bhind", @"Bhopal", @"Burhanpur", @"Chhatarpur", @"Chhindwara", @"Damoh", @"Datia", @"Dewas", @"Dhar", @"Dindori", @"Guna", @"Gwalior", @"Harda", @"Hoshangabad", @"Indore", @"Jabalpur", @"Jhabua", @"Katni", @"Khandwa (East Nimar)", @"Khargone (West Nimar)", @"Mandla", @"Mandsaur", @"Morena", @"Narsinghpur", @"Neemuch", @"Panna", @"Rewa", @"Rajgarh", @"Ratlam", @"Raisen", @"Sagar(mp)", @"Satna", @"Sehore", @"Seoni", @"Shahdol", @"Shajapur", @"Sheopur", @"Shivpuri", @"Sidhi", @"Singrauli", @"Tikamgarh", @"Ujjain", @"Umaria", @"Vidisha", @"Ahmednagar", @"Akola", @"Amravati", @"Aurangabad", @"Bhandara", @"Beed", @"Buldhana", @"Chandrapur", @"Dhule", @"Gadchiroli", @"Gondia", @"Hingoli", @"Jalgaon", @"Jalna", @"Kolhapur", @"Latur", @"Mumbai", @"Pushkar", @"Nandurbar", @"Nanded", @"Nagpur", @"Nashik", @"Osmanabad", @"Parbhani", @"Pune", @"Raigad", @"Ratnagiri", @"Sindhudurg", @"Sangli", @"Solapur", @"Satara", @"Thane", @"Wardha", @"Washim", @"Yavatmal", @"Bishnupur", @"Churachandpur", @"Chandel", @"Imphal", @"Senapati", @"Tamenglong", @"Thoubal", @"Ukhrul", @"Port Blair", @"East Garo Hills", @"East Khasi Hills", @"Jaintia Hills", @"Ri Bhoi", @"South Garo Hills", @"West Garo Hills", @"West Khasi Hills", @"Aizawl", @"Champhai", @"Kolasib", @"Lawngtlai", @"Lunglei", @"Mamit", @"Saiha", @"Serchhip", @"Dimapur", @"Kohima", @"Mokokchung", @"Mon", @"Phek", @"Tuensang", @"Wokha", @"Zunheboto", @"Angul", @"Boudh (Bauda)", @"Bhadrak", @"Balangir", @"Bargarh (Baragarh)", @"Balasore", @"Cuttack", @"Debagarh (Deogarh)", @"Dhenkanal", @"Ganjam", @"Gajapati", @"Jharsuguda", @"Jajpur", @"Jagatsinghpur", @"Khordha", @"Kendujhar (Keonjhar)", @"Kalahandi", @"Kandhamal", @"Koraput", @"Kendrapara", @"Malkangiri", @"Mayurbhanj", @"Nabarangpur", @"Nuapada", @"Nayagarh", @"Puri", @"Rayagada", @"Sambalpur", @"Subarnapur (Sonepur)", @"Sundergarh", @"Karaikal", @"Mahe", @"Pondicherry", @"Yanam", @"Amritsar", @"Barnala", @"Bhatinda", @"Firozpur", @"Faridkot", @"Fatehgarh Sahib", @"Fazilka", @"Gurdaspur", @"Hoshiarpur", @"Jalandhar", @"Kapurthala", @"Ludhiana", @"Mansa", @"Moga", @"Sri Muktsar Sahib", @"Pathankot", @"Patiala", @"Rupnagar", @"Sahibzada Ajit Singh Nagar (Mohali)", @"Sangrur", @"Shahid Bhagat Singh Nagar", @"Tarn Taran", @"Ajmer", @"Alwar", @"Bikaner", @"Barmer", @"Banswara", @"Bharatpur", @"Baran", @"Bundi", @"Bhilwara", @"Churu", @"Chittorgarh", @"Dausa", @"Dholpur", @"Dungapur", @"Ganganagar", @"Hanumangarh", @"Jhunjhunu", @"Jalore", @"Jodhpur", @"Jaipur", @"Jaisalmer", @"Jhalawar", @"Karauli", @"Kota", @"Nagaur", @"Pali", @"Pratapgarh(rj)", @"Rajsamand", @"Sikar", @"Sawai Madhopur", @"Sirohi", @"Tonk", @"Udaipur", @"East Sikkim", @"North Sikkim", @"South Sikkim", @"West Sikkim", @"Ariyalur", @"Chennai", @"Coimbatore", @"Cuddalore", @"Dharmapuri", @"Dindigul", @"Erode", @"Kanchipuram", @"Kanyakumari", @"Karur", @"Madurai", @"Nagapattinam", @"Nilgiris", @"Namakkal", @"Perambalur", @"Pudukkottai", @"Ramanathapuram", @"Salem", @"Sivaganga", @"Tirupur", @"Tiruchirappalli", @"Theni", @"Tirunelveli", @"Thanjavur", @"Thoothukudi", @"Tiruvallur", @"Tiruvarur", @"Tiruvannamalai", @"Vellore", @"Viluppuram", @"Virudhunagar", @"Dhalai", @"North Tripura", @"South Tripura", @"Khowai", @"West Tripura", @"Agra  ", @"Allahabad", @"Aligarh", @"Ambedkar Nagar", @"Auraiya", @"Azamgarh", @"Barabanki", @"Budaun", @"Bagpat", @"Bahraich", @"Bijnor", @"Ballia", @"Banda", @"Balrampur", @"Bareilly", @"Basti", @"Bulandshahr", @"Chandauli", @"Chhatrapati Shahuji Maharaj Nagar", @"Chitrakoot(up)", @"Deoria", @"Etah", @"Kanshi Ram Nagar", @"Etawah", @"Firozabad", @"Farrukhabad", @"Fatehpur", @"Faizabad", @"Gautam Buddh Nagar", @"Gonda", @"Ghazipur", @"Gorakhpur", @"Ghaziabad", @"Hamirpur(up)", @"Hardoi", @"Mahamaya Nagar", @"Jhansi", @"Jalaun", @"Jyotiba Phule Nagar", @"Jaunpur district", @"Ramabai Nagar (Kanpur Dehat)", @"Kannauj", @"Kanpur", @"Kaushambi", @"Kushinagar", @"Lalitpur", @"Lakhimpur Kheri", @"Lucknow", @"Mau", @"Meerut", @"Maharajganj", @"Mahoba", @"Mirzapur", @"Moradabad", @"Mainpuri", @"Mathura", @"Muzaffarnagar", @"Panchsheel Nagar district (Hapur)", @"Pilibhit", @"Prabudh Nagar (Shamli)", @"Pratapgarh(up)", @"Rampur", @"Raebareli", @"Saharanpur", @"Sitapur", @"Shahjahanpur", @"Sant Kabir Nagar", @"Siddharthnagar", @"Sonbhadra", @"Sant Ravidas Nagar", @"Sultanpur", @"Shravasti", @"Unnao", @"Varanasi", @"Almora", @"Bageshwar", @"Chamoli", @"Champawat", @"Dehradun", @"Haridwar", @"Nainital", @"Pauri Garhwal", @"Pithoragarh", @"Rudraprayag", @"Tehri Garhwal", @"Udham Singh Nagar", @"Uttarkashi", @"Birbhum", @"Bankura", @"Bardhaman", @"Darjeeling", @"Dakshin Dinajpur", @"Hooghly", @"Howrah", @"New Jalpaiguri ", @"Cooch Behar", @"Kolkata", @"Maldah", @"Paschim Medinipur", @"Purba Medinipur", @"Murshidabad", @"Nadia", @"North 24 Parganas", @"South 24 Parganas", @"Purulia", @"Uttar Dinajpur", @"Mount Abu", @"Ranthambor", @"Noida", @"Khajuraho", @"Bandhavgarh", @"Kanha", @"Orchha", @"Sanchi", @"Panchmarhi", @"Chitrakoot(mp)", @"Chandigarh", @"Manali", @"Dharamshala", @"Dalhousie", @"Khajjiar", @"Mussoorie", @"Jim Corbett", @"Ranikhet", @"Rishikesh", @"Lansdowne", @"Kedarnath", @"Pahalgam", @"Gulmarg", @"Sonamarg", @"Patnitop", @"Katra", @"Dwarka", @"Somnath", @"Shirdi", @"Lonavala", @"Bhimashankar", @"Mahabaleshwar", @"Khandala", @"Ajanta", @"Ellora", @"Srisailam", @"Vijayawada", @"Tirupati", @"Nagarjunasagar", @"Keesaragutta", @"Basar", @"Pochampally", @"Bangalore", @"Badami", @"Mangalore", @"Hampi", @"Coorg", @"Madikeri", @"Belur", @"Bandipur", @"Kodaikanal", @"Coonoor", @"Rameshwaram", @"Ooty", @"Kotagiri", @"Yercaud", @"Chidambaram", @"Cochin", @"Munnar", @"Thekkady", @"Kumarakom", @"Alleppey", @"Varkala", @"Trivandrum", @"Kovalam", @"Bekal", @"Ponmudi", @"Guruvayoor", @"Athirampilly", @"Vrindavan", @"Kalka", @"Badrinath", @"Junagarh", @"Vagamon", @"Bhubaneswar", @"Mohali", @"Hubli", @"Rohtang Pass", @"Kausani", @"Bhimtal", @"Corbett", @"Kathgodam", @"Guwahati", @"Gangtok", @"Ladakh", @"Bagdogra", @"Kalimpong", @"Siliguri", @"Mahabalipuram", @"Tirchi", @"Cherrapunji", @"Lachung", @"Delhi", @"Khatushyam", @"Salasarbalaji", nil];
    
    
    locationArray = [locationArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return locationArray;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)addDatePickerWithToolBar{
    
    //pickerView
    
    datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-195,self.view.frame.size.width,195)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(pickerAction:) forControlEvents:UIControlEventValueChanged]; // method to respond to changes in the picker value
    
    //Set Date
    [datePicker setDate:[NSDate date]];
    datePicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    //toolBar
    CGFloat tbW,tbH;
    tbW=self.view.frame.size.width; tbH=44;
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-tbH-195,tbW,tbH)];
    
    UIBarButtonItem *IDLeftTBBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(IDLeftTBBtnAction:)];
    IDLeftTBBtn.tintColor=[UIColor grayColor];
    
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *IDRightTBBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(IDRightTBBtnAction:)];
    IDRightTBBtn.tintColor=[UIColor grayColor];
    
    [toolBar setItems:[[NSArray alloc] initWithObjects:IDLeftTBBtn,spacer,IDRightTBBtn,nil]];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    [self.view addSubview:toolBar];
    [self.view addSubview:datePicker];
    
}



//-(void)addDatePickerWithToolBar1
//{
//    //Set Date Picker
//    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
//    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//    
//    //Set Date
//    [datePicker setDate:[NSDate date]];
//}

//-(UIToolbar*)addToolBar{
//    
//    UIAlertController * uac=   [UIAlertController
//                                 alertControllerWithTitle:nil
//                                 message:Nil
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    
//    
//    
//    UITextField *text;
//    //Add ToolBar
//    CGFloat tbW,tbH;
//    tbW=self.view.frame.size.width; tbH=44;
//    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-tbH-195,tbW,tbH)];
//    
//    UIBarButtonItem *IDLeftTBBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(IDLeftTBBtnAction:)];
//    IDLeftTBBtn.tintColor=[UIColor grayColor];
//    
//    
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem *IDRightTBBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(IDRightTBBtnAction:)];
//    IDRightTBBtn.tintColor=[UIColor grayColor];
//    
//    [toolBar setItems:[[NSArray alloc] initWithObjects:IDLeftTBBtn,spacer,IDRightTBBtn,nil]];
//    [toolBar setBarStyle:UIBarStyleDefault];
//    [toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
//    
//    
//    //[showView:viewObj
//    
//    //[uac add]
////    text.inputAccessoryView=toolBar;
////    text.inputView=toolBar;
//    
//    return toolBar;
//}

-(void)IDLeftTBBtnAction:(id)sender
{
    NSDate *chosen = [datePicker date];
    [datePicker removeFromSuperview];
    [toolBar removeFromSuperview];
    NSLog(@"%@",chosen);
}

-(void)IDRightTBBtnAction:(id)sender
{
    [datePicker removeFromSuperview];
    [toolBar removeFromSuperview];
}

- (IBAction)pickerAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    //NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
}

     
-(void)showPickerView
{
      [self addDatePickerWithToolBar];
         [UIView animateWithDuration:1 animations:^{
           
             CGRect currentRect =datePicker.frame;
             currentRect.origin.y = 320;
             currentRect.size.height = 250;
             [self.view setFrame:currentRect];
            }
            completion:^(BOOL finished) {
            //[modalView.view removeFromSuperview];
        }];
}
     
//-(void)dismissView{
//    
//        [UIView animateWithDuration:1 animations:^{
//            CGRect currentRect = modalView.view.frame;
//            currentRect.origin.y = 650.0f;
//            currentRect.size.height = 295.0f;
//            [modalView.view setFrame:currentRect];
//        }
//                         completion:^(BOOL finished)
//    {
//                             //[modalView.view removeFromSuperview];
//                         }];
//    }
@end
