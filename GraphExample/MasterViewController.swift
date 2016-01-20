//
//  MasterViewController.swift
//  GraphExample
//
//  Created by HiraiKokoro on 2015/11/24.
//  Copyright © 2015年 HiraiKokoro. All rights reserved.
//

import UIKit
import Graph

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [
        (
            "棒グラフ",
            [Graph.barGraph([("Jan.", [3000, 0]), ("Feb.", [5000, 0]), ("Mar.", [5200, 2222]), ("Apr.", [9000, 3]), ("May.", [10000, 3000])], minValue: 0, maxValue: 0)],
            GraphViewAppearance(
                colors: [UIColor.lightGrayColor(), UIColor.redColor()],
                lineColor: nil,
                textColors: [UIColor.darkGrayColor()],
                lineValueColors: nil,
                valueColors: [UIColor.darkGrayColor(), UIColor.redColor()],
                blankColor: nil,
                barWidthRatio: nil,
                dotDiameter: nil,
                font: nil
            )
        ),
        (
            "棒グラフ＆折線グラフ",
            [
                Graph.barGraph([("Jan.", 16000000), ("Feb.", 3000000), ("Mar.", 2000000), ("Apr.", 8000000), ("May.", 6000000)], minValue: 0, maxValue: 50000000),
                Graph.lineGraph([("Jan.", 8000000), ("Feb.", 3000000), ("Mar.", 0), ("Apr.", 8000000), ("May.", 6000000)], minValue: 0, maxValue: 50000000)
            ],
            GraphViewAppearance(
                colors: [UIColor.lightGrayColor()],
                lineColor: [UIColor.redColor()],
                textColors: [UIColor.darkGrayColor()],
                lineValueColors: [UIColor.redColor()],
                valueColors: [UIColor.darkGrayColor()],
                blankColor: nil,
                barWidthRatio: nil,
                dotDiameter: nil,
                font: nil
            )
        )
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel!.text = objects[indexPath.row].0
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

