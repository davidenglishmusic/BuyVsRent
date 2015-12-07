//
//  BuyViewController.swift
//  BuyVsRent
//
//  Created by David English on 2015-11-29.
//  Copyright © 2015 David English. All rights reserved.
//

import UIKit
import CoreData

class BuyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let reuseIdentifier = "House"
    
    var houses = [NSManagedObject]()

    @IBOutlet weak var houseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Properties"
        
        houseTable.delegate = self
        houseTable.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "House")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            houses = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HouseTableCell
        
        let house = houses[indexPath.row]
        
        cell.propertyLabel!.text = house.valueForKey("address") as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "addNewProperty") {
            if let houseViewController = segue.destinationViewController as? HouseViewController {
                houseViewController.currentHouse = []
            }
        }
        
        else if (segue.identifier == "editProperty") {
            if let houseViewController = segue.destinationViewController as? HouseViewController {
                if houseTable.indexPathForSelectedRow?.row != nil {
                    let selectedRow = houseTable.indexPathForSelectedRow!.row
                    houseViewController.currentHouse = [houses[selectedRow]]
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        houseTable.delegate = self
        houseTable.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "House")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            houses = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        houseTable.reloadData()
    }

}
