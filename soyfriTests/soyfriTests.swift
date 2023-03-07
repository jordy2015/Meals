//
//  soyfriTests.swift
//  soyfriTests
//
//  Created by Jordy Gonzalez on 3/6/23.
//
import Combine
import XCTest
@testable import soyfri

class MockApiClient: NetworkProtocol {
    let mealMock: [Meal]
    let errorMock: Error?
    
    init(moviesMock: [Meal], error: Error?) {
        self.mealMock = moviesMock
        self.errorMock = error
    }
    
    func performRequest<T>(to url: String,
                           httpMethod: HttpMethod,
                           keyPath: String?,
                           body: [String : AnyObject]?,
                           completitionHandler: @escaping (T?, Error?) -> Void) where T : Decodable {
        if let err = self.errorMock {
            completitionHandler(nil, err)
        } else {
            completitionHandler(self.mealMock as? T, nil)
        }
    }
}


final class soyfriTests: XCTestCase {
    
    private var cancellable: Set<AnyCancellable> = []
    var mealsMock: [Meal] = []
    var errorMock: Error?

    override func setUpWithError() throws {
        let meal1 = Meal(id: "1", name: "n1", category: "c1", area: "a1", thumbUrl: "t1", youtubeUrl: "y1")
        let meal2 = Meal(id: "2", name: "n2", category: "c2", area: "a2", thumbUrl: "t2", youtubeUrl: "y2")
        let duplicateMeal = Meal(id: "1", name: "n1", category: "c1", area: "a1", thumbUrl: "t1", youtubeUrl: "y1")
        mealsMock.append(contentsOf: [meal1, meal2, duplicateMeal])
        errorMock = NSError(domain: "something went wrong", code: 401)
    }

    func testRemoveDuplicate() throws {
        //Arrange
        let apiClient = MockApiClient(moviesMock: mealsMock, error: nil)
        let mealViewModel = MealViewModel(apiClient: apiClient)
        let expectation = XCTestExpectation(description: "getting data without")
        mealViewModel.objectWillChange.sink {
            if mealViewModel.isLoading {
                XCTAssertTrue(mealViewModel.isLoading)
            } else {
                //result without duplicates
                XCTAssertEqual(mealViewModel.mealList.count, Set(self.mealsMock).count)
                expectation.fulfill()
            }
        }.store(in: &cancellable)
        
        //Act
        mealViewModel.fetchMeals()
        
        //Assert
        wait(for: [expectation], timeout: 1)
    }

}
