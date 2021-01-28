//
//  AboutTableViewController.m
//  relapps
//
//  Created by Diego Loop on 28/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "AboutTableViewController.h"
#import "AboutViewController.h"
#import "BackgroundColorView.h"
#import "IllustrationView.h"
#import "Data.h"
#import <MessageUI/MessageUI.h>


@interface AboutTableViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) int indexPressed;
@property (strong, nonatomic) MFMailComposeViewController *mail;


@end

@implementation AboutTableViewController

- (MFMailComposeViewController *)mail
{
    if (!_mail) {
        _mail = [[MFMailComposeViewController alloc] init];
        _mail.mailComposeDelegate = self;
        [_mail setToRecipients:@[EMAIL_FEEDBACK]];
        [_mail setSubject:@"My feedback"];
        
    }
    return _mail;
}

- (void)addBackgroundColor
{
    BackgroundColorView *backgroundView = [[BackgroundColorView alloc] init];
    [backgroundView setFrame:self.view.bounds];
    [self.view insertSubview:backgroundView atIndex:0];
    backgroundView.backgroundStyle = BackgroundStyleGreenLightBall;
    
    self.navigationItem.rightBarButtonItem.tintColor = self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB([Data getInstance].ballColor);
    
}


#define RATE @"Rate this app"
#define HOWTO @"FAQ"
#define FEEDBACK @"Send feedback via email"
#define ABOUT_US @"About us"
#define TERMS @"Terms and conditions"
#define VERSION @"Version 1.0"

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        [_items addObject:HOWTO];
        [_items addObject:RATE];
        [_items addObject:FEEDBACK];
        [_items addObject:ABOUT_US];
        [_items addObject:TERMS];
        [_items addObject:VERSION];
    }
    return _items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self addBackgroundColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SegueID = @"ShowAboutContent";
    self.indexPressed = (int)indexPath.row;
    if ([[self.items objectAtIndex:indexPath.row] isEqualToString:ABOUT_US]
        || [[self.items objectAtIndex:indexPath.row] isEqualToString:HOWTO]
        || [[self.items objectAtIndex:indexPath.row] isEqualToString:TERMS]) {
        [self performSegueWithIdentifier:SegueID sender:self];
        
    }
    else if([[self.items objectAtIndex:indexPath.row] isEqualToString:RATE]){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APP]];
    }
    
    else if( [[self.items objectAtIndex:indexPath.row] isEqualToString:FEEDBACK] )
    {
        
        if ([MFMailComposeViewController canSendMail]) {
            [self presentViewController:self.mail animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sending Feedback isn't possible :("
                                                                           message:@"We cannot send your feedback without an Email accout. Please provide your feedback via iTunes, we are continously checking for updates"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AboutViewController *about = [segue destinationViewController];
    
    if ([[self.items objectAtIndex:self.indexPressed] isEqualToString:HOWTO]) {
        about.title = [self.items objectAtIndex:self.indexPressed];
        NSString *text = [NSString stringWithFormat:@"Q: What is this app all about?\n\nA: Basically, this is not just an app, it’s a philosophy of life. We are providing a new tool which will help you to disconnect you from the busy and fast-paced world we live in. This app will try to reduce the stress level of your day.\n\nWe have to be honest. This app is not magical, it requires more from your side. Please use this app in combination with fresh air, a healthy diet, sports, laughing to name a few, but every journey starts with the first step.\n\nQ: Who is this app made for?\n\nA: This app is made for everyone who wants to improve their day by releasing stress.\n\nQ: Why does the ball change its color from green to blue?\n\nA: The ball changes its state depending on your progress. It starts always with green and changes to blue when your relaxation goal per day has been achieved. Please note that you can change your relaxation time goal per day at any time in settings.\n\nQ: What is so special about this app?\n\nA: You apply 3 of your senses. Sight, hearing and touch, which are crucial for this app.\n\nSight: we have built animations pleasant in color, shapes and moves.\n\nHearing: with 3D audio the sound will enhance the perception of the relaxation moves.\n\nTouch: We have built a special algorithm. It will show you the way to total relaxation with every touch of your fingertip following the ball.\n\nWith the combination of these 3 senses, the impact on you will be deeper and lasting.\n\nQ: How often should I use the app to feel relaxed?\n\nA: You can use this app as many times as you want. You know best when you are feeling stressed-out and that’s the best time to use the app.\n\nQ: What can I do to stay relaxed?\n\nA: We have built a reminder which will notify you so you won’t forget your dose of relaxation according to your preference (see settings). Important here is regularity!\n\nQ: How can I get the best of this app?\n\nA: We recommend you to find a place where you feel comfortable, on the couch, in the woods, at a lake, etc. The quieter the better.\n\nWe strongly suggest to use headphones to feel the sound and energy going directly into your body.\n\nQ: Anything else I need to consider?\n\nA: Yes, please don’t use this app while operating dangerous machinery and driving!\n\n\n\n\n"];
        
        about.text = text;
    }
    
    if ([[self.items objectAtIndex:self.indexPressed] isEqualToString:ABOUT_US]) {
        about.title = [self.items objectAtIndex:self.indexPressed];
        
        NSString *text =[NSString stringWithFormat:@"Living in a time where everything is digital, rapid and fast-paced, we often forget the little things that make us feel incredibly comfy and happy. Living with too much stress is not healthy and will have a negative impact on your life - eventually. That’s why Relax exists!\n\nWe are a small, but encouraged team from Bavaria, Germany with one target in mind: Increase your quality of life! This is just the beginning of what we hope to be an eternal journey. Our research and development will continue, so stay tuned for new releases, new features and new ways to relax.\n\nThe idea for creating Relax came during a trip to Asia. It was a very busy but fascinating time. We came across the Baoding balls* which require the use of your hearing, sight and touch to fully unfold their effect. Those helped us tremendously during our trip, and that’s why it was essential for us to create a modern alternative that can be used at any time and is always with you in your pocket.\n\nPlease let us know how your life has improved, share your ideas or just to say hi by sending us your feedback.\n\n* Baoding balls: these awesome Chinese metal ball used for meditation, medicine and well known as healthy balls\n\n\n\n\n"];
        
        
        
//        [NSString stringWithFormat:@"Living in a time where everything has to be digital, rapid and fast-paced, we often forget the little things that make us feel incredibly comfy and happy. Do you remember the laughter, the warmth around your heart and the butterflies in your stomach from that certain someone? Sometimes it’s not possible to be together. This is something we can’t change, but what we can change is to make you feel closer to each other. That’s why we created herzly… \n\nWe created this project for our family and friends, and they deserve the best quality possible, that's why we chose every component of a herzly postcard eagerly, from paper over ink to stamp. To make the postcard complete, you add your beautiful photograph of a precious moment, some lovely words, and it is good to go!\n\nOur intention is to start sending postcards at a real competitive price, making it attractive to anyone - we hope you like it, you are welcome ;-) Remember, the best things in life come free... or at least affordable like herzly.\n\nThe moment for herzly couldn’t be better. The easy access to internet, the high quality cameras in our pockets and the desire to share your moments are the best preconditions to make herzly real.\n\nThink about it, sharing your pictures on your favourite social media will at most have some likes and comments, but we know you can get more than that. For real! Just think about the last time you received a postcard and how special you felt! And how it made you smile every time you saw it hanging on your wall! Huh!\n\nWe hope you love herzly and the idea behind it as much as we do and we don't want to stop here! We are trying to create the foundation for a new era of sharing. There are so many ideas in our heads we want to develop for you, but we need your feedback to sort them out. So please feel free to share your comments on social media or send us an email to servus@herzly.com, any recommendations are more than welcome and appreciated.\n\n\n\n\n"];
        
        about.text = text;
        
        
    }else if([[self.items objectAtIndex:self.indexPressed] isEqualToString:TERMS]){
        about.title = [self.items objectAtIndex:self.indexPressed];
        
        NSString *text = [NSString stringWithFormat:@"THE USER UNDERSTANDS THAT THIS APP SHOULD NOT BE USED WHILE OPERATING DANGEROUS MACHINERY OR DRIVING.\n\nThe user understands that this app is not responsible for any harm that might be caused. The user of this app assumes all risks in the use of the product, waving any claims against this app for any and all mental or physical injuries.\n\nThose who should consult a physician before the use of this product include: individuals under the influence of medication or drugs.\nThis app should not be used while under the influence of alcohol or other mood altering substances, whether they be legal or illegal.\n\nIn no case will this app and their creators be liable for chance, accidental, special, direct or indirect damages resulting from use, misuse or defects of the software, instructions or documentation.\n\n\n\n\n"];

//        NSString *text = [NSString stringWithFormat:@"The user of this app understands that this app is not responsible for any harmful that might be cause. The user of this app assumes all risks in the use of the products, waving any claims against this app for any and all mental or physical injuries.\n\nThe user understands that this app should not be used on tasks that require full concentration like driving or operating dangerous machinery.\nThis app should not to be used while under the influence of alcohol or other mood altering substances, whether they be legal or illegal.\nThis app should not be used if the user is under medication or drugs.\n\nIn no case will this app and their creators be liable for chance, accidental, special, direct or indirect damages resulting from use, misuse or defects of the software, instructions or documentation."];
//        NSString *text = [NSString stringWithFormat:@"I agree to grant herzly permission to print this content on a paper postcard to the specified recipient on my behalf. I have proof-read the message for errors and understand the message will be printed as is.\n\nI agree that the content is not deceptive, illegal, malicious nor harmful. In the event that the communication is deemed unsolicited by anyone involved in this transaction, herzly will not be held liable for any damages, legal or otherwise, resulting from this postcard.\n\nI understand that herzly reserves the right to reject any order for any reason, if the content is found to be deceptive, illegal, malicious or harmful in any way. I understand that the Deutsche Post AG does not offer tracking info for postcards and herzly will not refund orders after being placed and paid. I understand that my postcard will be postmarked from Germany.\n\n\n\n\n"];
        
        about.text = text;
    }
}


@end
