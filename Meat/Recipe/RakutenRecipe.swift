//
//  RakutenRecipe.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/06.
//

import Foundation


struct RakutenRecipeItem: Identifiable {
    let recipeTitle: String
    let recipeURL: String
    let foodImageURL: String
    var id = UUID()
}

func getRandomYakinikuRestaurantURL() -> String {
    let yakinikuRestaurantURLs: [String] = [
        "https://ushiwakamaru-fukui.jp/restaurant/", // 牛若丸
        "https://tabelog.com/fukui/A1801/A180101/18001227/", // 三千里
        "https://www.jojoen.co.jp", // 叙々苑
        "https://www.yakiniku.jp/nikushou_sakai/", // 肉匠坂井
        "https://www.kalubi-taisho.com" // カルビ大将
    ]
    return yakinikuRestaurantURLs.randomElement()!
}


class RakutenRecipeSearcher: ObservableObject {
    
    @Published var rakutenRecipeItems: [RakutenRecipeItem] = []
    
    init(categoryID: String) {
        self.search(categoryID: categoryID)
    }
    
    // initializer for `Yakiniku` mode
    init(meatPart: MeatPart) {
        let recipeTitle = "焼肉"
        let recipeURL = getRandomYakinikuRestaurantURL()
        let recipe: RakutenRecipeItem = {
            switch meatPart {
            case .gyu_harami:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://cdn.macaro-ni.jp/assets/img/shutterstock/shutterstock_316787414.jpg")
            case .gyu_kara_roast:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://shop25-makeshop.akamaized.net/shopimages/takefuku/000000000258_1_vcuCbxS.jpg")
            case .gyu_tongue:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://static.retrip.jp/article/55875/images/55875db1afa2d-968d-4710-975c-e91d71cad566_l.jpg")
            case .sankaku_bara:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://img.furusato-tax.jp/cdn-cgi/image/width=520,height=323/img/x/product/details/20200722/sd2_65ce214a6751b539a90b3c0846c0c2f1db48f9a7.jpg")
            case .sasami:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://main-dish.com/wp-content/uploads/sites/3/2015/07/sasami4.jpg")
            case .seseri:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://kinarino.k-img.com/system/press_images/001/327/569/fac4fbb5ed582c05e94a1db71cc809ccfb756136.jpg")
            case .sunagimo:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://sendai.tokiwatei.com/dainohara/files/2013/06/20130622_1.jpg")
            case .tori_liver:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://img2.mypl.net/image.php?id=1844022&p=shopn&s=490_740&op=")
            case .tori_momo:
                return RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: "https://letronc-s3.akamaized.net/items/images/1332490/large/mini_magick20180516-10969-1iqswaj.jpg")
            }
        }()
        
        self.rakutenRecipeItems = [recipe]
    }
    
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
                            let recipeURL = recipe["recipeUrl"] as! String
                            let foodImageURL = recipe["foodImageUrl"] as! String
                            print("🥩 \(recipeTitle) \(recipeURL) \(foodImageURL)")
                            
                            let recipeItem = RakutenRecipeItem(recipeTitle: recipeTitle, recipeURL: recipeURL, foodImageURL: foodImageURL)
                            
                            DispatchQueue.main.async {
                                self.rakutenRecipeItems.append(recipeItem)
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
