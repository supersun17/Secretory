//
//  StickersManager.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/28/19.
//

import Foundation

protocol StickerPresenterProtocol {
	func oldVisibleStickerDisappear(_ sticker: Sticker)
	func newVisibleStickerAddedToTop(_ sticker: Sticker)
	func newVisibleStickerAddedFromBack(_ sticker: Sticker)
}

class StickersManager {
	private var stickers: [Sticker] = []
	var maxVisibleStickers: Int = 5
	weak var presenter: StickerStackStill?

	init(with presenter: StickerStackStill) {
		self.presenter = presenter
	}

	func visibleStickers() -> [Sticker] {
		return Array(stickers.suffix(maxVisibleStickers))
	}

	func addSticker(_ sticker: Sticker) {
		stickers.append(sticker)
		presenter?.newVisibleStickerAddedToTop(sticker)
		if stickers.count > maxVisibleStickers {
			presenter?.oldVisibleStickerDisappear(stickers[stickers.count - maxVisibleStickers - 1])
		}
	}

	func removeTopSticker() {
		let shouldAddFromBack = stickers.count > maxVisibleStickers
		stickers.removeFirst()
		if shouldAddFromBack {
			if let bottom = bottomVisibleSticker() {
				presenter?.newVisibleStickerAddedFromBack(bottom)
			}
		}
	}

	func bottomVisibleSticker() -> Sticker? {
		if stickers.count == 0 { return nil }

		let index = stickers.count - maxVisibleStickers - 1
		let validIndex = max(0,index)
		return stickers[validIndex]
	}

	func allStickers() -> [Sticker] {
		return stickers
	}

	func removeAll() {
		stickers.removeAll()
	}
}
