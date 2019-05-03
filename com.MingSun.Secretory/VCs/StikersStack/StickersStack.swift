//
//  StickersStack.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/28/19.
//

import UIKit

protocol StickersStackDataSource: AnyObject {
	func numberOfStickers() -> Int
	func contentViewForSticker(at index: Int) -> UIView
}

protocol ContentSelectors: AnyObject {
	var contentSelectors: [Int] { get set }
}

extension ContentSelectors {
	func rebuildContentSelectors(with size: Int) {
		contentSelectors.removeAll()
		for i in 0..<size {
			contentSelectors.append(i)
		}
	}
	func getContentSelectorCount() -> Int {
		return contentSelectors.count
	}
	func getContentSelector(at i: Int) -> Int {
		return contentSelectors[i]
	}
	func removeContentSelector(at i: Int) {
		contentSelectors.remove(at: i)
	}
	func insertContentSelector(at i: Int, _ contentIndex: Int) {
		contentSelectors.insert(contentIndex, at: i)
	}
}

class StickersStack: UIView, ContentSelectors {
	weak var dataSource: StickersStackDataSource?

	typealias StickerOffset = (h: CGFloat, v: CGFloat)
	var stickerOffset: StickerOffset = (h: CGFloat(10), v: CGFloat(10))
	var stickerSize: CGSize {
		let stackSize = bounds
		let defaultSize = (w: stackSize.width - CGFloat(maxVisibleStickers) * stickerOffset.h * 2,
						   h: stackSize.height - CGFloat(maxVisibleStickers) * stickerOffset.v)
		return CGSize.init(width: defaultSize.w, height: defaultSize.h)
	}
	var stickerBoundry: CGFloat = 0.75

	/**
	stickers array is used as a stack, consider it: [bottom,.....,top]
	**/
	private let stickersPool = ElementsPool<Sticker>(with: { return Sticker() })
	private var stickers: [Sticker] = []
	var contentSelectors: [Int] = []
	var maxVisibleStickers: Int = 5

	override init(frame: CGRect) {
		super.init(frame: frame)

		initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		initialSetup()
	}

	private func initialSetup() {
		observeChanges()
	}
}

// ******** StickerPresentation related ********
extension StickersStack: StickerBehaviorDelegate {
	func reloadStack() {
		guard let newCount = dataSource?.numberOfStickers(), newCount != 0 else { return }
		rebuildContentSelectors(with: newCount)
		rebuildContent()
	}

	private func rebuildContent() {
		removeAll()
		let endIndex = getContentSelectorCount() - 1
		let startIndex = endIndex - min(getContentSelectorCount(), maxVisibleStickers) + 1
		for i in startIndex...endIndex {
			let sticker = addSticker(at: i)
			addNewVisibleStickerToTop(sticker)
		}
		redoTransform()
	}

	func addSticker(at i: Int) -> Sticker {
		let sticker = stickersPool.draw()
		setupSticker(sticker, at: i)
		return sticker
	}

	private func setupSticker(_ sticker: Sticker, at i: Int) {
		sticker.delegate = self
		addSubview(sticker)
		sticker.frame = getNewStickerRect()
		if let contentView = dataSource?.contentViewForSticker(at: getContentSelector(at: i)) {
			sticker.attachContentView(contentView)
		}
	}

	private func getNewStickerRect() -> CGRect {
		let size = stickerSize
		let minX = (bounds.width - size.width) / 2
		let minY = bounds.height - size.height

		return CGRect.init(x: minX, y: minY, width: size.width, height: size.height)
	}

	func addNewVisibleStickerToTop(_ sticker: Sticker) {
		stickers.append(sticker)
		bringSubviewToFront(sticker)
		redoTransform()
	}

	func newVisibleStickerAddedToBack(_ sticker: Sticker) {
		stickers.insert(sticker, at: 0)
		sendSubviewToBack(sticker)
		redoTransform()
	}

	func removeSticker(at i: Int) {
		let startIndex = getContentSelectorCount() - stickers.count
		let sticker = stickers.remove(at: i)
		stickersPool.release(sticker)
		removeContentSelector(at: startIndex + i)
		let next = getContentSelectorCount() - 1 - stickers.count
		if next >= 0 {
			let sticker = addSticker(at: next)
			newVisibleStickerAddedToBack(sticker)
		} else {
			redoTransform()
		}
	}

	func removeAll() {
		for (i,s) in stickers.enumerated().reversed() {
			stickers.remove(at: i)
			stickersPool.release(s)
		}
	}

	func boundryCheckThreshold() -> CGRect {
		return CGRect.init(x: frame.width * stickerBoundry / 2,
						   y: frame.height * stickerBoundry / 2,
						   width: frame.width * stickerBoundry,
						   height: frame.height * stickerBoundry)
	}

	func sitckerDidMoveOutOfBoundry(_ sticker: Sticker) {
		for (i,s) in stickers.enumerated() {
			if s === sticker {
				removeSticker(at: i)
				break
			}
		}
	}
}

// ******** Animation related ********
extension StickersStack {
	func observeChanges() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(orientationDidChange),
											   name: UIDevice.orientationDidChangeNotification,
											   object: nil)
	}

	@objc func orientationDidChange() {
		redoFrame()
		redoTransform()
	}

	private func redoFrame() {
		for s in stickers {
			if !s.isBeingDragged {
				s.reset()
				s.frame = getNewStickerRect()
			}
		}
	}

	private func redoTransform() {
		for (i,s) in stickers.enumerated() {
			if !s.isBeingDragged {
				s.reset()
				s.swing(CGFloat(stickers.count - 1 - i) / 100)
				s.saveCurrentState()
			}
		}
	}
}
