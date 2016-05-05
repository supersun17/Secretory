//
//  MainVC.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class MainVC: UIViewController {
	@IBOutlet weak var stickersStack: StickersStack!

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	@IBAction func track(_ sender: UIButton) {

	}

	@IBAction func create(_ sender: UIButton) {
		stickersStack.addSticker()
	}
}
