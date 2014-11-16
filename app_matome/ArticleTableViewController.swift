//
//  ArticleTableViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 2014/11/16.
//  Copyright (c) 2014年 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ArticleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let mockArticles = [
        [
            title: "テスト記事",
            date: NSDate(),
            source: "テスト情報源",
            url: NSURL(string: "http://google.com")
        ],
        [
            title: "テスト記事2",
            date: NSDate(),
            source: "テスト情報源2",
            url: NSURL(string: "http://yahoo.co.jp")
        ],
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.section == 1 {
            cell.textLabel.text = menuItems[indexPath.row]["label"]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
            
    }
}
