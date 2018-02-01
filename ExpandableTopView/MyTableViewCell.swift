//
//  MyTableViewCell.swift
//  ExpandableTopView
//
//  Created by Wesley Dos Santos on 31/01/18.
//  Copyright © 2018 wesleydossantos. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	
	func configureWith(_ index: Int, numberOfItens: Int){
		label.text = "Celula \(index + 1)" 
	}

}
