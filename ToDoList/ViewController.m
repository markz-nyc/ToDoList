//
//  ViewController.m
//  ToDoList
//
//  Created by Mark Zhong on 3/29/17.
//  Copyright © 2017 Mark Zhong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>


@end

@implementation ViewController

//this is just test merge, pull request


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"todo_database"] == nil){
        self.items = @[@{@"name":@"Buy grocery", @"completed":@"0"}, @{@"name":@"Sample Task", @"completed":@"0"}].mutableCopy;
    }else{
        NSMutableArray *todo_data = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"todo_database"] mutableCopy];
        self.items = todo_data;
    }
    self.navigationItem.title = @"To Do List";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    
    
    UIColor *yourColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper1.jpg"]];
    self.tableView.backgroundColor = yourColor ;
    //self.tableView.backgroundView.backgroundColor = yourColor ;
    
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper2.png"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Edit Item

- (void)editItem:(UIBarButtonItem *)sender{
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing){
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
    }else{
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStylePlain;
    }
}


#pragma mark - Add Item

- (void)addItem:(UIBarButtonItem *)sender{

    UIAlertView *addItem = [[UIAlertView alloc] initWithTitle:@"Add Item" message:@"Write a new item name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Item", nil];
    
    addItem.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addItem textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [addItem show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != alertView.cancelButtonIndex){
        
        UITextField *inputText = [alertView textFieldAtIndex:0];
        NSString *itemName = inputText.text;
        NSDictionary *item = @{@"name": itemName, @"completed":@"0"};
        [self.items addObject:item];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"todo_database"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    
}

#pragma Delete Item

- (void)removeItemAtIndexPath:(NSIndexPath *)IndexPath{
    
    [self.items removeObjectAtIndex:IndexPath.row];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"todo_database"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ToDoItemRow";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    
    cell.textLabel.text = item[@"name"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    //[cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper2.png"]]];

    //UIColor *yourColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper1.jpg"]];
    cell.backgroundColor = [UIColor clearColor] ;
    //cell.backgroundView.backgroundColor = yourColor ;
    
    if([item[@"completed"] boolValue]){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item = [self.items[indexPath.row] mutableCopy];
    Boolean completed = [item[@"completed"] integerValue];
    item[@"completed"] = @(!completed);
    
    
    self.items[indexPath.row] = item;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = [item[@"completed"] integerValue]? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    [self.items[indexPath.row] setObject:@(!completed) forKey:@"completed"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"todo_database"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self removeItemAtIndexPath:indexPath];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}


@end
