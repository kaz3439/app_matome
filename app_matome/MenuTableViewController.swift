//
//  MenuTableViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 2014/11/15.
//  Copyright (c) 2014 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var delegate : MenuTableViewControllerDelegate?
    var menuItems = [[
            "label" : "新着記事",
            "id" : "new"
        ],[
            "label" : "ランキング",
            "id" : "ranking"
        ],[
            "label" : "設定",
            "id" : "config"
        ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.tableView.frame
        tableView.backgroundView = effectView
        tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else {
            return menuItems.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.section == 1 {
            cell.textLabel.text = menuItems[indexPath.row]["label"]
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64;
        } else {
            return 44;
        }
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
            delegate?.menuTableView(tableView,
                didSelectRowAtIndexPath:indexPath)
    }
}

protocol MenuTableViewControllerDelegate {
    func menuTableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
}
