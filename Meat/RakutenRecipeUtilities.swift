//
//  SearchRakutenRecipe.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/06.
//

import Foundation


struct RakutenRecipeItem {
    let recipeTitle: String
    let recipeUrl: String
    let foodImageUrl: String
}


class RakutenRecipeSearcher: ObservableObject {
    
    @Published var rakutenRecipeItems: [RakutenRecipeItem] = []
    @Published var firstRakutenRecipeItem: RakutenRecipeItem = RakutenRecipeItem(recipeTitle: "🥩", recipeUrl: "🥩", foodImageUrl: "🥩")
    
    func search(categoryID: String){
        DispatchQueue.main.async {
            self.rakutenRecipeItems.removeAll()
        }
        
        let url: URL = URL(string: "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=\(categoryID)&applicationId=1060011195616454125")!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let couponData = try JSONSerialization.jsonObject(with: data!,
                options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                
                let resultsOptional = couponData.first
                
                if let results = resultsOptional {
                    let recipeArrayOptional = results.value as? Array<Dictionary<String, Any>>
                    
                    if let recipeArray = recipeArrayOptional {
                        for recipe in recipeArray {
                            let recipeTitle = recipe["recipeTitle"] as! String
                            let recipeUrl = recipe["recipeUrl"] as! String
                            let foodImageUrl = recipe["foodImageUrl"] as! String
                            print("\(recipeTitle) \(recipeUrl) \(foodImageUrl)")
                            
                            let recipeItem = RakutenRecipeItem(recipeTitle: recipeTitle, recipeUrl: recipeUrl, foodImageUrl: foodImageUrl)
                            
                            DispatchQueue.main.async {
                                self.rakutenRecipeItems.append(recipeItem)
                            }
                        }
                        
                        
                        if let firstRakutenRecipeItem = self.rakutenRecipeItems.first {
                            DispatchQueue.main.async {
                                self.firstRakutenRecipeItem = firstRakutenRecipeItem
                            }
                        }
                    }
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
