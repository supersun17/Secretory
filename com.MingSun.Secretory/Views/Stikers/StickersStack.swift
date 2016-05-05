//
//  StikersStack.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class StickersStack: StickerStackStill {
	override func draw(_ rect: CGRect) {
		super.draw(rect)

		NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange),
											   name: UIDevice.orientationDidChangeNotification, object: nil)
	}

	@objc func orientationDidChange() {
		redoFrame()
		redoTransform()
	}

	override func newVisibleStickerAddedToTop(_ sticker: Sticker) {
		super.newVisibleStickerAddedToTop(sticker)

		redoTransform()
	}

	override func newVisibleStickerAddedFromBack(_ sticker: Sticker) {
		super.newVisibleStickerAddedFromBack(sticker)
	}

	func redoFrame() {
		for s in stickersManager.visibleStickers() {
			s.reset()
			s.frame = getNewStickerRect()
		}
	}

	private func redoTransform() {
		let totalVisibleStickersCount = stickersManager.visibleStickers().count - 1
		for (i,v) in stickersManager.visibleStickers().enumerated().reversed() {
			v.reset()
			v.swing(totalVisibleStickersCount - i)
			v.saveCurrentState()
		}
	}
}
