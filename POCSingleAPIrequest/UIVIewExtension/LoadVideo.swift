//
//  LoadVideo.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 05/09/22.
//

import UIKit
import AVKit

extension UIView {
	func loadVideo(path: URL) -> AVPlayer {
		//let fileURL = URL(fileURLWithPath: path)
		let item = AVPlayerItem(url: path)
		let player = AVPlayer(playerItem: item)
		let layer = AVPlayerLayer(player: player)
		layer.videoGravity = .resize
		layer.frame = self.bounds
		self.layer.insertSublayer(layer, at: 0)
		player.play()
		return player
	}
}
