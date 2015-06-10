//
//  CandyTableViewController.swift
//  Search Bar
//
//  Created by Georgy Marrero on 6/10/15.
//  Copyright (c) 2015 Georgy Marrero. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var candies = [Candy]()
    
    var filteredCandies = [Candy]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sample Data for candyArray
        self.candies = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check which one is the tableView showing.
        if tableView == self.searchDisplayController!.searchResultsTableView {
            // The Search Table View is showing.
            
            return self.filteredCandies.count
        } else {
            // The normal Table View is showing.
            
            return self.candies.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        var candy : Candy
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("candyDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as! UIViewController
            // Check if the sender (tableView) was from the Search Display Controller
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                // Table View Sender is from the Search Display Controller
                
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()! // Get the index path from the Search Display Controller
                let destinationTitle = self.filteredCandies[indexPath.row].name // title will be set from filteredCandies
                candyDetailViewController.title = destinationTitle // change title in Detail VC
            } else {
                // Table View Sender is not from the Search Display Controller
                
                let indexPath = self.tableView.indexPathForSelectedRow()!  // Get the index path from the normal Table View
                let destinationTitle = self.candies[indexPath.row].name // title will be set from candies array
                candyDetailViewController.title = destinationTitle // change title in Detail VC
            }
        }
    }
    
    // MARK: - Search bar
    
    // This will happen everytime the text in the Search Bar is changed.
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    // This will happen when the Scope is changed.
    // NOTE: This example's Search Bar doesn't have any scope.
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

    // MARK: - Helper functions
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredCandies = self.candies.filter({(candy: Candy) -> Bool in
            //let scope = "myScope"
            //let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText, options: nil, range: nil, locale: nil)
            return (stringMatch != nil)
        })
    }

}
