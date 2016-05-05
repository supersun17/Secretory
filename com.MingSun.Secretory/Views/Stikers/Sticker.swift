//
//  Stiker.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class Sticker: GestureView {
	override func draw(_ rect: CGRect) {
		super.draw(rect)

		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1
	}
}
