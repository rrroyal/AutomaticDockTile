//
//  DockTilePlugin.swift
//  DockTilePlugin
//
//  Created by royal on 13/11/2020.
//

import AppKit
import Combine

class DockTilePlugin: NSObject, NSDockTilePlugIn {
	private var cancellable: AnyCancellable? = nil
	
	func setDockTile(_ dockTile: NSDockTile?) {
		updateDockTile(dockTile)
		
		cancellable = NSApp.publisher(for: \.effectiveAppearance)
			.removeDuplicates()
			.sink { appearance in
				self.updateDockTile(dockTile, appearance: appearance)
			}
	}
	
	func updateDockTile(_ dockTile: NSDockTile?, appearance: NSAppearance = NSApp.effectiveAppearance) {
		guard let dockTile = dockTile else {
			return
		}
		
		let isLight = appearance.bestMatch(from: [.aqua, .darkAqua]) == .aqua
		
		let view = NSView(frame: NSRect(x: 0, y: 0, width: dockTile.size.width, height: dockTile.size.height))
		view.wantsLayer = true
		
		let color = isLight ? CGColor(gray: 1, alpha: 1) : CGColor(gray: 0, alpha: 1)
		view.layer?.backgroundColor = color
		
		dockTile.contentView = view
		dockTile.display()
	}
}
