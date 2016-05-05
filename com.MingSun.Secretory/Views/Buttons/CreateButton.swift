//
//  CreateButton.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class CreateButton: UIButton {
	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = frame.height / 2
	}
}
