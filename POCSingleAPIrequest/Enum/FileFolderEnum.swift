//
//  FileFolderEnum.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 03/09/22.
//

import Foundation

enum FileFolderEnum: String {
	case main
	case test
	
	var folderName: String {
		self.rawValue.uppercased()
	}
}
