//
//  TransformView.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/29/19.
//

import UIKit

struct TransformViewState {
	let transform: CGAffineTransform
	let frame: CGRect
	let position: CGPoint

	init(with transform: CGAffineTransform, frame: CGRect, position: CGPoint) {
		self.transform = transform
		self.frame = frame
		self.position = position
	}
}

class TransformView: UIView {
	var savedState: TransformViewState!
	var animator: UIViewPropertyAnimator?

	func saveCurrentState() {
		savedState = TransformViewState.init(with: transform, frame: frame, position: layer.position)
	}

	func startTransformAnimate(with transform: CGAffineTransform) {
		animator = UIViewPropertyAnimator.init(duration: AnimationConstants.stikerAnimationDuration, curve: .easeOut) {
			self.transform = transform
		}
		animator?.startAnimation()
	}

	func stopTransformAnimate() {
		animator?.stopAnimation(true)
	}

	func reset() {
		if !transform.isIdentity {
			transform = CGAffineTransform.identity
		}
	}

	func swing(_ degree: Int) {
		let orgin = frame.origin
		layer.anchorPoint = CGPoint.init(x: 0, y: 0)
		layer.position = orgin
		let rotation = -CGFloat(0.01 * Double(degree) * Double.pi)
		let rotTransform = CGAffineTransform.init(rotationAngle: rotation)
		if transform.isIdentity {
			transform = rotTransform
		} else {
			transform.concatenating(rotTransform)
		}
	}

	func translate(h: CGFloat, v: CGFloat, _ degree: Int) {
		let posTransform = CGAffineTransform.init(translationX: h * CGFloat(degree),
												  y: v * CGFloat(degree))
		transform = posTransform
	}

	func scale(_ degree: Int) {
		let sclTransform = CGAffineTransform.init(scaleX: CGFloat(1.0 - 0.01 * Double(degree)),
												  y: CGFloat(1.00 - 0.01 * Double(degree)))
		transform = sclTransform
	}
}
