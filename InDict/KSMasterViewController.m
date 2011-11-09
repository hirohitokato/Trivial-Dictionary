//
//  KSMasterViewController.m
//  InDict
//
//  Created by Hirohito Kato on 11/11/09.
//  Copyright (c) 2011 KatokichiSoft. All rights reserved.
//
#import "KSMasterViewController.h"
#import <UIKit/UITextChecker.h>

@interface KSMasterViewController ()
- (void)search;
@end

@implementation KSMasterViewController

@synthesize searchBar = _searchBar;
@synthesize checker=_checker;
@synthesize matched=_matched, suggestions=_suggestions, history=_history;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Tiny Dictionary", @"Master");
        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
        self.searchBar.delegate = self;

        _checker = [[UITextChecker alloc] init];
        NSLog(@"available language:%@", [UITextChecker availableLanguages]);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // matched
            return _matched?1:0;
            break;
        case 1: // suggestions
            return [_suggestions count];
            break;
        case 2: // history /* not implemented yet */
            return [_history count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *ret;
    switch (section) {
        case 0: // match
            ret = NSLocalizedString(@"Match", @"Section title");
            break;
        case 1:
            ret = NSLocalizedString(@"Did you mean?", @"Section title");
            break;
        case 2:
            ret = NSLocalizedString(@"History", @"Section title");
            break;
        default:
            ret = @"Error";
            break;
    }
    return ret;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString *text;
    switch ([indexPath section]) {
        case 0: // match
            text = _matched;
            break;
        case 1:
            text = [_suggestions objectAtIndex:[indexPath row]];
            break;
        case 2:
            text = [_history objectAtIndex:[indexPath row]];
            break;
        default:
            text = @"Error";
            break;
    }
    cell.textLabel.text = text;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *term = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if (term) {
        UIReferenceLibraryViewController *controller = [[UIReferenceLibraryViewController alloc] initWithTerm:term];
        [self.navigationController presentModalViewController:controller animated:YES];
        // [self.navigationController pushViewController:controller animated:YES];

    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

#pragma mark - UISearchBarDelegate
- (void)search
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // called when text changes (including clear)
    _suggestions = [_checker guessesForWordRange:NSMakeRange(0, [searchText length])
                                        inString:searchText
                                        language:@"en_US"];
    BOOL isMatched = [UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:searchText];
    if (isMatched) {
        self.matched = searchText;
    } else {
        self.matched = nil;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // called when keyboard search button pressed
    [searchBar resignFirstResponder];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self performSelector:@selector(search) withObject:nil afterDelay:0.0f];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    // called when bookmark button pressed
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    // called when cancel button pressed
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    // called when search results button pressed
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
@end
