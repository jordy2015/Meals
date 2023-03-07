//
//  MealViewModel.swift
//  soyfri
//
//  Created by Jordy Gonzalez on 3/6/23.
//

import Foundation
import Combine
import OrderedCollections

class MealViewModel: ObservableObject {
    
    var mealList: OrderedSet<Meal> = []
    var error: Error? = nil
    var isLoading: Bool = false
    
    private let apiClient: NetworkProtocol
    
    init(apiClient: NetworkProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchMeals() {
        isLoading = true
        objectWillChange.send()
        
        apiClient.performRequest(to: WebServices.randomMealApi,
                                 httpMethod: .Get,
                                 keyPath: "meals",
                                 body: nil) { [weak self] (result: [Meal]?, error) in
            guard let self = self else { return }
            
            if let meals = result {
                self.mealList.append(contentsOf: meals)
            }
            
            if let err = error {
                self.error = err
            }
            
            self.isLoading = false
            self.objectWillChange.send()
        }
    }
}
