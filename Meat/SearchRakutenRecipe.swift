//
//  SearchRakutenRecipe.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/06.
//

import Foundation

class RakutenRecipeSearcher: ObservableObject {
    
    func search(categoryID: String) {
        let url: URL = URL(string: "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=\(categoryID)&applicationId=1060011195616454125")!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let couponData = try JSONSerialization.jsonObject(with: data!,
                options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                
                let resultsOptional = couponData.first
                if let results = resultsOptional {
                    let recipeArray = results.value as! Array<Dictionary<String, Any>>
                    
                    for recipe in recipeArray {
                        let recipeTitle = recipe["recipeTitle"] as! String
                        let recipeUrl = recipe["recipeUrl"] as! String
                        let foodImageUrl = recipe["foodImageUrl"] as! String
                        print("\(recipeTitle) \(recipeUrl) \(foodImageUrl)")
                    }
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
