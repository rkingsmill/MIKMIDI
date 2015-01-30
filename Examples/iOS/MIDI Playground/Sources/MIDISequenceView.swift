//
//  MIDISequenceView.swift
//  MIDI Playground
//
//  Created by Andrew Madsen on 1/29/15.
//  Copyright (c) 2015 Mixed In Key. All rights reserved.
//

import UIKit
import MIKMIDI

class MIDISequenceView : UIView {
	
	var sequence: MIKMIDISequence? {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	var pixelsPerTick : CGFloat {
		if (self.sequence == nil) { return 10.0 }
		
		let tracks = self.sequence!.tracks as [MIKMIDITrack]
		let maxLength = tracks.reduce(0) { (currMax: MusicTimeStamp, track: MIKMIDITrack) -> MusicTimeStamp in
			return max(currMax, track.length);
		}
		return CGRectGetWidth(self.bounds) / CGFloat(maxLength)
	}
	
	var pixelsPerNote : CGFloat {
		return CGRectGetHeight(self.bounds) / 127.0
	}
	
	override func drawRect(rect: CGRect) {
		if self.sequence == nil { return }
		
		let ppt = self.pixelsPerTick
		let noteHeight = self.pixelsPerNote
		
		let tracks = self.sequence!.tracks as [MIKMIDITrack]
		for (index, track) in enumerate(tracks) {
			let events = track.events as [MIKMIDIEvent]
			for event in events {
				if let note = event as? MIKMIDINoteEvent {
					let noteColor = tracks.count <= 2 ? self.colorForNote(note) : self.colorForTrackAtIndex(index)
				}
				
				
			}
		}
	}
	
	func colorForNote(note: MIKMIDINoteEvent) -> UIColor {
		let colors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.cyanColor(), UIColor.blueColor(), UIColor.purpleColor()]
		let noteIndex = (note.note % 12)
		return UIColor.greenColor()
	}
	
	func colorForTrackAtIndex(index: Int) -> UIColor {
		let colors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor()]
		return UIColor.greenColor()
	}
}

extension UIColor {
	func colorByInterpolatingWith(otherColor: UIColor, var amount: CGFloat) -> UIColor {
		amount = min(max(amount, 0.0), 1.0)
		
		let startComponent = CGColorGetComponents(self.CGColor)
		let endComponent = CGColorGetComponents(otherColor.CGColor)
		
		let startAlpha = CGColorGetAlpha(self.CGColor)
		let endAlpha = CGColorGetAlpha(otherColor.CGColor)
		
		let r = startComponent[0] + (endComponent[0] - startComponent[0]) * amount
		let g = startComponent[1] + (endComponent[1] - startComponent[1]) * amount
		let b = startComponent[2] + (endComponent[2] - startComponent[2]) * amount
		let a = startAlpha + (endAlpha - startAlpha) * amount
		
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}