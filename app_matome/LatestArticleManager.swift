//
//  ArticleManager.swift
//  
//
//  Created by Kazuhiro Hayashi on 1/18/15.
//
//

import UIKit

class LatestArticleManager: NSObject {
    var items : [PFObject] = []
    var isFirstLoading = false
    var queue : NSOperationQueue = NSOperationQueue()
    let limit = 20
    private func sendAsynchronousRequestWithSkip (skip: Int, limit: Int, completeHandler handler: ([AnyObject]!, NSError!) -> Void) {
            var articleQuery = PFQuery(className: "Article")
            articleQuery.skip = self.items.count
            articleQuery.limit = 20
            articleQuery.orderByDescending("pubDate")
            articleQuery.includeKey("publisher")
            articleQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                handler(objects, error)
            })
    }
    
    func resetAndFirst() {
        weak var blockSelf = self
        self.isFirstLoading = true
        self.sendAsynchronousRequestWithSkip(0, limit: self.limit, completeHandler: { (objects, error) -> Void in
            blockSelf?.items = objects as [PFObject]
            self.isFirstLoading = false
        })
    }
    
    func next() {
        if self.isFirstLoading == true {
            return
        }

        weak var blockSelf = self
        self.sendAsynchronousRequestWithSkip(self.items.count, limit: self.limit, completeHandler: { (objects, error) -> Void in
            if blockSelf != nil {
                blockSelf?.items += objects as [PFObject]
            }
        })
    }
}
