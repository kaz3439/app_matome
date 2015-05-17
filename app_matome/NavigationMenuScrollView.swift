//
//  NavigationMenuScrollView.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 4/14/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

protocol NavigationMenuScrollViewDelegate : class {
    func navigationMenuScrollView(scrollView : NavigationMenuScrollView, touchUpMenuButton menuButton: UIButton)
}

class NavigationMenuScrollView: UIScrollView {

    weak var menuDelegate : NavigationMenuScrollViewDelegate?
    var currentMenu = 1
    var currentVMenuUnderbar :UIView?

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let currentButton = self.viewWithTag(currentMenu) {
            currentButton.tintColor = UIColor.purpleColor()
            var slice = CGRectZero
            var reminder = CGRectZero
            CGRectDivide(currentButton.frame, &slice, &reminder, 2.5, CGRectEdge.MaxYEdge)
            self.currentVMenuUnderbar = UIView(frame: slice)
            self.currentVMenuUnderbar?.backgroundColor = UIColor.purpleColor()
            if let currentVMenuUnderbar = self.currentVMenuUnderbar {
                self.addSubview(currentVMenuUnderbar)
            }
        }
        
    }
    
    @IBAction func performButton(sender: UIButton) {
        animateMenuHighlight(sender)
        self.menuDelegate?.navigationMenuScrollView(self, touchUpMenuButton: sender)
    }
    
    func transitMenuHighlight(menuIndex : Int) {
        if let view = self.viewWithTag(menuIndex + 1) {
            self.animateMenuHighlight(view)
        }
    }
    
    private func animateMenuHighlight(menuButton: UIView) {
        let expectedTransitionedX = menuButton.center.x - self.frame.size.width/2
        let transitionedX = expectedTransitionedX < 0 ? 0 : expectedTransitionedX
        let point = CGPointMake(transitionedX, self.frame.origin.y)
        self.setContentOffset(point, animated: true)
        for  subview in self.subviews {
            if let button = subview as? UIButton {
                button.tintColor = UIColor.whiteColor()
            }
        }
        menuButton.tintColor = UIColor.purpleColor()
        self.layer.removeAllAnimations()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if let underBar = self.currentVMenuUnderbar {
                underBar.frame = CGRectMake(menuButton.frame.origin.x, underBar.frame.origin.y, menuButton.frame.width, underBar.frame.height)
            }
        }, { (completion) -> Void in
        })
        self.currentMenu = menuButton.tag
    }
}
