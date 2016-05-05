//
//  StickerStackStill.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/28/19.
//

import UIKit

class StickerStackStill: UIView, StickerPresenterProtocol {
	lazy var stickersManager = StickersManager(with: self)

	var defaultOffSet: (h: CGFloat, v: CGFloat) = (h: CGFloat(10), v: CGFloat(10))
	var defaultStickerSize: CGSize {
		let stackSize = bounds
		let maxVisibleStickers = CGFloat(self.stickersManager.maxVisibleStickers)
		let defaultSize = (w: stackSize.width - maxVisibleStickers * self.defaultOffSet.h * 2,
						   h: stackSize.height - maxVisibleStickers * self.defaultOffSet.v)
		return CGSize.init(width: defaultSize.w, height: defaultSize.h)
	}

	func addSticker() {
		let sticker = Sticker()
		sticker.backgroundColor = UIColor.getRandomColor()
		stickersManager.addSticker(sticker)
	}

	func getBottomSticker() -> Sticker? {
		return stickersManager.visibleStickers().first
	}

	func getNewStickerRect() -> CGRect {
		let size = defaultStickerSize
		let minX = (bounds.width - size.width) / 2
		let minY = bounds.height - size.height

		return CGRect.init(x: minX, y: minY, width: size.width, height: size.height)
	}

	// StickerPresenterProtocol
	func oldVisibleStickerDisappear(_ sticker: Sticker) {
		sticker.removeFromSuperview()
	}

	func newVisibleStickerAddedToTop(_ sticker: Sticker) {
		addSubview(sticker)
		sticker.frame = getNewStickerRect()
		bringSubviewToFront(sticker)
	}

	func newVisibleStickerAddedFromBack(_ sticker: Sticker) {
		if let bottom = getBottomSticker() {
			addSubview(sticker)
			sticker.frame = getNewStickerRect()
			insertSubview(sticker, belowSubview: bottom)
		}
	}
}
