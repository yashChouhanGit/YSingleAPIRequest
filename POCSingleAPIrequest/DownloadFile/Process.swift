//
//  Process.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 05/09/22.
//

import Foundation

struct Process {
	let fielName: String
	let locationName: SetLocationEnum
	let folderName: FileFolderEnum
	
	func checkAvailability(newFileName: String) -> Bool {
		var isAvailable = false
		isAvailable = newFileName == fielName
		if isAvailable {
			return true
		}
		isAvailable = newFileName.contains(fielName)
		if isAvailable {
			return true
		}
		isAvailable = fielName.contains(newFileName)
		if isAvailable {
			return true
		}
		return false
	}
}
