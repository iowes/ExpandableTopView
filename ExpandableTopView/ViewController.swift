//
//  ViewController.swift
//  ExpandableTopView
//
//  Created by Wesley Dos Santos on 31/01/18.
//  Copyright © 2018 wesleydossantos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var littleTitle: UILabel!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableTop: NSLayoutConstraint!
    
    typealias AnimateRange = (min: CGFloat, max: CGFloat)
    
    let numberOfItens = 6
    let headerHeight : AnimateRange = (0, 120)
    var topPosition : AnimateRange = (-30, 90)
    var previousScrollOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.layer.cornerRadius = 20
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        tableHeight.constant = tableView.contentSize.height
        topPosition.min = (UIScreen.main.bounds.height - headerHeight.max) - tableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.headerHeight.max
        updateHeader()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingUp = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingDown = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        // Calculate new header height
        var newHeight = self.headerHeightConstraint.constant
        var newTopPosition = self.tableTop.constant
        
        print("newtop: \(newTopPosition)")
        print("newHeight: \(newHeight)")

        if isScrollingUp {
            newHeight = max(self.headerHeight.min, self.headerHeightConstraint.constant - abs(scrollDiff * 1.55))
            newTopPosition = max(self.topPosition.min, self.tableTop.constant - abs(scrollDiff))
            
        } else if isScrollingDown {
            newTopPosition = min(self.topPosition.max, self.tableTop.constant +  abs(scrollDiff))
            if newTopPosition > 0 {
                newHeight = min(self.headerHeight.max, self.headerHeightConstraint.constant + abs(scrollDiff * 0.8))
            }else{
                newHeight = self.headerHeight.min
            }
        }
        
        // Header needs to animate
        if newHeight != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeight
            self.updateHeader()
//            self.setScrollPosition(self.previousScrollOffset)
        }
        
        if newTopPosition != self.tableTop.constant{
            self.tableTop.constant = newTopPosition
        }
//        self.previousScrollOffset = scrollView.contentOffset.y
    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidStopScrolling()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.scrollViewDidStopScrolling()
//    }
//
//    func scrollViewDidStopScrolling() {
//        let range = self.headerHeight.max - self.headerHeight.min
//        let midPoint = self.headerHeight.min + (range / 2)
//
//        if self.headerHeightConstraint.constant > midPoint {
//            self.expandHeader()
//        } else {
//            self.collapseHeader()
//        }
//    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - headerHeight.min
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.headerHeightConstraint.constant = self.headerHeight.min
//            self.updateHeader()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.headerHeightConstraint.constant = self.headerHeight.max
//            self.updateHeader()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.headerHeight.max - self.headerHeight.min
        let openAmount = self.headerHeightConstraint.constant - self.headerHeight.min
        let percentage = openAmount / range
        
        bigTitle.alpha = percentage
        littleTitle.alpha = 1 - percentage
        UIView.animate(withDuration: 0.2) {
            if self.bigTitle.alpha <= 0{
                self.bigTitle.isHidden = true
            }else{
                self.bigTitle.isHidden = false
            }
            self.bigTitle.superview?.layoutIfNeeded()
        }
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        if let cell = cell as? MyTableViewCell{
            cell.configureWith(indexPath.row, numberOfItens: numberOfItens)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItens
    }
}


