//
//  GestureView.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/29/19.
//

import UIKit

class GestureView: TransformView, UIGestureRecognizerDelegate {
	func setupGesture() {
		let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
		pan.delegate = self
		addGestureRecognizer(pan)
	}

	@objc func handlePan(_ pan: UIPanGestureRecognizer) {
		switch pan.state {
		case .began:
			stopTransformAnimate()
			break
		case .changed:
			let translation = pan.translation(in: superview)
			transform = CGAffineTransform.init(translationX: translation.x, y: translation.y)
			break
		case .ended:
			startTransformAnimate(with: savedState.transform)
			break
		default:
			break
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupGesture()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		setupGesture()
	}
}
