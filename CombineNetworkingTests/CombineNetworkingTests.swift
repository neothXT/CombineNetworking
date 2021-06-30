//
//  CombineNetworkingTests.swift
//  CombineNetworkingTests
//
//  Created by Maciej Burdzicki on 20/05/2021.
//

import XCTest
import Combine
@testable import CombineNetworking

class CombineNetworkingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testBadResponseFetch() throws {
		let expectation = expectation(description: "Fetch first todo object")
		var subscriptions: Set<AnyCancellable> = []
		
		CNProvider<RemoteEndpoint>().publisher(for: .posts, responseType: Todo?.self)?
			.catch { error -> Just<Todo?> in
				if let responseError = error as? CNError, case .unexpectedResponse(let response) = responseError,
				   response.statusCode == -1003 {
					expectation.fulfill()
				}
				return Just(nil)
			}
			.sink { _ in }
			.store(in: &subscriptions)
		
		wait(for: [expectation], timeout: 10)
	}
	
	func testPlain() throws {
		let expectation = expectation(description: "Fetch first todo object")
		var subscriptions: Set<AnyCancellable> = []
		
		CNProvider<RemoteEndpoint>().publisher(for: .todos, responseType: Todo.self)?
			.sink(receiveCompletion: { _ in
			}) { (todos: Todo) in
				expectation.fulfill()
			}
			.store(in: &subscriptions)
		
		wait(for: [expectation], timeout: 10)
	}

	func testQueryParams() throws {
		let expectation = expectation(description: "Fetch first todo object")
		var subscriptions: Set<AnyCancellable> = []
		
		CNProvider<RemoteEndpoint>().publisher(for: .dictGet(["postId": 1]), responseType: Post.self)?
			.sink(receiveCompletion: { _ in
				expectation.fulfill()
			}) { (_: Post) in }
			.store(in: &subscriptions)
		
		wait(for: [expectation], timeout: 10)
	}
	
	func testPostWithJsonModel() throws {
		let post = Post(userId: 123, id: nil, title: "SampleTitle", body: "SampleBody")
		
		let expectation = expectation(description: "Fetch first todo object")
		var subscriptions: Set<AnyCancellable> = []
		
		CNProvider<RemoteEndpoint>().publisher(for: .post(post), responseType: Post.self)?
			.sink(receiveCompletion: { _ in
				expectation.fulfill()
			}) { (_: Post) in }
			.store(in: &subscriptions)
		
		wait(for: [expectation], timeout: 10)
	}
	
	func testPostWithDictionary() throws {
		let expectation = expectation(description: "Fetch first todo object")
		var subscriptions: Set<AnyCancellable> = []
		
		let dict = ["userId": "1231", "title": "Title", "body": "Body"]
		
		CNProvider<RemoteEndpoint>().publisher(for: .dictPost(dict), responseType: Post.self)?
			.sink(receiveCompletion: { _ in
				expectation.fulfill()
			}) { (_: Post) in }
			.store(in: &subscriptions)
		
		wait(for: [expectation], timeout: 10)
	}
}
