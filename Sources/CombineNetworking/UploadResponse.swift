//
//  UploadResponse.swift
//  
//
//  Created by Maciej Burdzicki on 23/05/2022.
//

import Foundation

public enum UploadResponse: Equatable {
	case progress(percentage: Double)
	case response(data: Data?)
	case authError
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.progress(let left), .progress(let right)):
			return left == right
		case (.response(let left), .response(let right)):
			return left == right
		case (.authError, .authError):
			return true
		default:
			return false
		}
	}
}
