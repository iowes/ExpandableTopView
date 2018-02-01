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
	@IBOutlet weak var tableBottom: NSLayoutConstraint!
	@IBOutlet weak var tableTop: NSLayoutConstraint!
	
	let numberOfItens = 20
	let maxHeaderHeight : CGFloat = 180
	let minHeaderHeight : CGFloat = 64
	let maxTopPading : CGFloat = 0
	let minTopPading : CGFloat = -30
	let maxBottomPading : CGFloat = 30
	let minBottomPading : CGFloat = -30
	var previousScrollOffset: CGFloat = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.layer.cornerRadius = 20
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.headerHeightConstraint.constant = self.maxHeaderHeight
		updateHeader()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
		
		let absoluteTop: CGFloat = 0;
		let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
		
		let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
		let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
		
		if canAnimateHeader(scrollView) {
			
			// Calculate new header height
			var newHeight = self.headerHeightConstraint.constant
			var newPaddingTop = self.tableTop.constant
			var newPaddingBottom = self.tableBottom.constant

			if isScrollingDown {
				newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
				newPaddingTop = min(self.maxTopPading, self.tableTop.constant + abs(scrollDiff))
				newPaddingBottom = max(self.minBottomPading, self.tableBottom.constant - abs(scrollDiff))
			} else if isScrollingUp {
				newHeight = min(self.maxHeaderHeight * 2, self.headerHeightConstraint.constant + abs(scrollDiff))
				newPaddingTop = max(self.minTopPading, self.tableTop.constant - abs(scrollDiff))
				newPaddingBottom = min(self.maxBottomPading, self.tableBottom.constant + abs(scrollDiff))
			}
			
			// Header needs to animate
			if newHeight != self.headerHeightConstraint.constant {
				self.headerHeightConstraint.constant = newHeight
				self.tableTop.constant = newPaddingTop
				self.tableBottom.constant = newPaddingBottom
				self.updateHeader()
				self.setScrollPosition(self.previousScrollOffset)
			}
			
			self.previousScrollOffset = scrollView.contentOffset.y
		}
		
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		self.scrollViewDidStopScrolling()
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		self.scrollViewDidStopScrolling()
	}
	
	func scrollViewDidStopScrolling() {
		let range = self.maxHeaderHeight - self.minHeaderHeight
		let midPoint = self.minHeaderHeight + (range / 2)
		
		if self.headerHeightConstraint.constant > midPoint {
			self.expandHeader()
		} else {
			self.collapseHeader()
		}
	}
	
	func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
		// Calculate the size of the scrollView when header is collapsed
		let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
		
		// Make sure that when header is collapsed, there is still room to scroll
		return scrollView.contentSize.height > scrollViewMaxHeight
	}
	
	func collapseHeader() {
		self.view.layoutIfNeeded()
		UIView.animate(withDuration: 0.15, animations: {
			self.headerHeightConstraint.constant = self.minHeaderHeight
			self.updateHeader()
			self.view.layoutIfNeeded()
		})
	}
	
	func expandHeader() {
		self.view.layoutIfNeeded()
		UIView.animate(withDuration: 0.15, animations: {
			self.headerHeightConstraint.constant = self.maxHeaderHeight
			self.updateHeader()
			self.view.layoutIfNeeded()
		})
	}
	
	func setScrollPosition(_ position: CGFloat) {
		self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
	}
	
	func updateHeader() {
		let range = self.maxHeaderHeight - self.minHeaderHeight
		let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
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


