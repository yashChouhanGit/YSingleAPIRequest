//
//  AssetPushOperationInput.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 03/09/22.
//

import Foundation

struct AssetPushInput {
	let fileName: String
	let locationName: SetLocationEnum
	let folderName: FileFolderEnum
	let progress: Double
	
	init?(fileName: String?,locationName: SetLocationEnum?,folder: FileFolderEnum?,progress: Double = 1.0) {
		guard let fileName = fileName else {
			return nil
		}
		guard let locationName = locationName else {
			return nil
		}
		guard let folder = folder else {
			return nil
		}
		self.fileName = fileName
		self.locationName = locationName
		self.folderName = folder
		self.progress = progress
	}
}
