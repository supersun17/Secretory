//
//  Stiker.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class Sticker: GestureView {
	weak var contentView: UIView?

	override func draw(_ rect: CGRect) {
		super.draw(rect)

		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1
	}

	func attachContentView(_ contentView: UIView) {
		self.contentView = contentView
		addSubview(contentView)
		bringSubviewToFront(contentView)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		let views = ["contentView" : contentView]
		var allConstraints: [NSLayoutConstraint] = []
		let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: views)
		let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: views)
		allConstraints.append(contentsOf: constraintsH)
		allConstraints.append(contentsOf: constraintsV)
		NSLayoutConstraint.activate(allConstraints)
	}
}

extension Sticker: PoolElementProtocol {
	func prepareForReuse() {
		contentView?.removeFromSuperview()
	}
}
