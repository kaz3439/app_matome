//
//  ArticleMasterViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 1/17/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ArticleMasterViewController: UITableViewController {

    var articles : [PFObject] = []
    var scrollViewTranslation :CGFloat = 0.0
    var navOriginY : CGFloat = 0.0
    var articleMasterTableViewCellHeight: CGFloat = 0.0
    var articleWoImageMasterTableViewCellHeight: CGFloat = 0.0
    var articleMasterTableViewLoadingCellHeight: CGFloat = 0.0
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)
        
        self.tableView.alwaysBounceVertical = true

        let cellWithImageNib = UINib(nibName: "ArticleMasterTableViewCell", bundle: nil)
        tableView.registerNib(cellWithImageNib, forCellReuseIdentifier: "ArticleMasterTableViewCell")
        let cellWithImage = cellWithImageNib.instantiateWithOwner(self, options: nil)[0] as ArticleMasterTableViewCell
        self.articleMasterTableViewCellHeight = cellWithImage.frame.height
        let cellWoImageNib = UINib(nibName: "ArticleWoImageMasterTableViewCell", bundle: nil)
        tableView.registerNib(cellWoImageNib, forCellReuseIdentifier: "ArticleWoImageMasterTableViewCell")
        let cellWoImage = cellWoImageNib.instantiateWithOwner(self, options: nil)[0] as ArticleWoImageMasterTableViewCell
        self.articleWoImageMasterTableViewCellHeight = cellWoImage.frame.height
        let cellOfLoadingNib = UINib(nibName: "ArticleMasterTableViewLoadingCell", bundle: nil)
        tableView.registerNib(cellOfLoadingNib, forCellReuseIdentifier: "ArticleMasterTableViewLoadingCell")
        let cellOfLoading = cellOfLoadingNib.instantiateWithOwner(self, options: nil)[0] as ArticleMasterTableViewLoadingCell
        self.articleMasterTableViewLoadingCellHeight = cellOfLoading.frame.height
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.articles.isEmpty {
            var articleQuery = PFQuery(className: "Article")
            articleQuery.limit = 20
            articleQuery.orderByDescending("pubDate")
            articleQuery.includeKey("publisher")
            self.isLoading = true
            weak var blockSelf = self
            articleQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                blockSelf?.articles = objects as [PFObject]
                println(blockSelf?.articles[0]["publisher"])
                blockSelf?.isLoading = false
                blockSelf?.tableView.reloadData()
            }
        }
        
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
        if section == 0 {
            return articles.count
        } else if section == 1 {
            return 1;
        }
        return 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let article = self.articles[indexPath.row]
            if let imageUrl = article["imageUrl"] as? String {
                let cell = tableView.dequeueReusableCellWithIdentifier("ArticleMasterTableViewCell", forIndexPath: indexPath) as ArticleMasterTableViewCell
                cell.titleLabel.text = article["title"] as? String
                cell.descLabel.text = article["summary"] as? String
                if let publisher = article["publisher"] as? PFObject {
                        cell.sourceLabel.text = publisher["displayName"] as? String
                }
                if let date = article["pubDate"] as? NSDate {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "YYYY-MM-dd"
                    cell.dateLabel.text = formatter.stringFromDate(date)
                }
                cell.cutImageView?.sd_setImageWithURL(NSURL(string: imageUrl))
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ArticleWoImageMasterTableViewCell", forIndexPath: indexPath) as ArticleWoImageMasterTableViewCell
                cell.titleLabel.text = article["title"] as? String
                cell.descLabel.text = article["summary"] as? String
                if let publisher = article["publisher"] as? PFObject {
                    cell.sourceLabel.text = publisher["displayName"] as? String
                }
                if let date = article["pubDate"] as? NSDate {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "YYYY-MM-dd"
                    cell.dateLabel.text = formatter.stringFromDate(date)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleMasterTableViewLoadingCell", forIndexPath: indexPath) as ArticleMasterTableViewLoadingCell
            if !self.articles.isEmpty && !self.isLoading {
                var articleQuery = PFQuery(className: "Article")
                articleQuery.skip = self.articles.count
                articleQuery.limit = 20
                articleQuery.orderByDescending("pubDate")
                articleQuery.includeKey("publisher")
                self.isLoading = true
                weak var blockSelf = self
                articleQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    blockSelf?.articles += objects as [PFObject]
                    blockSelf?.isLoading = false
                    blockSelf?.tableView.reloadData()
                    cell.activityIndicator.stopAnimating()
                }
            }
            cell.activityIndicator.startAnimating()
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let article = self.articles[indexPath.row]
            if let imageUrl = article["imageUrl"] as? String {
                return self.articleMasterTableViewCellHeight
            } else {
                return self.articleWoImageMasterTableViewCellHeight
            }
        } else {
            return self.articleMasterTableViewLoadingCellHeight
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleDetailViewController") as ArticleDetailViewController
            let article = articles[indexPath.row]
            if let contentUrl = article["contentUrl"] as? String {
                if let url =  NSURL(string: contentUrl) {
                    detailViewController.loadUrl = url
                }
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func refresh(sender: AnyObject) {
        var articleQuery = PFQuery(className: "Article")
        articleQuery.skip = self.articles.count
        articleQuery.limit = 20
        articleQuery.orderByDescending("pubDate")
        articleQuery.includeKey("publisher")
        self.isLoading = true
        weak var blockSelf = self
        articleQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            blockSelf?.articles = objects as [PFObject]
            blockSelf?.isLoading = false
            blockSelf?.refreshControl?.endRefreshing()
            blockSelf?.tableView.reloadData()
        }
    }
}
