//
//  RoundView.swift
//  ExpandableTopView
//
//  Created by Wesley Dos Santos on 31/01/18.
//  Copyright © 2018 wesleydossantos. All rights reserved.
//

import UIKit

class RoundedView: UIView {
	
	func roundTopCorner(_ radius:CGFloat){
		self.round([.topLeft, .topRight], radius: radius)
	}
	
	func roundBottomCorner(_ radius:CGFloat){
		self.round([.bottomLeft, .bottomRight], radius: radius)
	}
	
	func clearRound(){
		self.round(.allCorners, radius: 0)
	}
	
	private func round(_ corners: UIRectCorner, radius: CGFloat){
		let bounds = self.bounds
		
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = maskPath.cgPath
		
		self.layer.mask = maskLayer
		
		let frameLayer = CAShapeLayer()
		frameLayer.frame = bounds
		frameLayer.path = maskPath.cgPath
		frameLayer.fillColor = UIColor.white.cgColor
		
		self.layer.addSublayer(frameLayer)
	}
}
