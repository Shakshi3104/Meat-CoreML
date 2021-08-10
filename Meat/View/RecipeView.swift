//
//  RecipeView.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/10.
//

import SwiftUI
import WebKit

struct RecipeView: View {
    @State var meatPart: MeatPart
    
    private let dummyRecipes: [RakutenRecipeItem] = [
        RakutenRecipeItem(recipeTitle: "焼肉", recipeUrl: "https://www.yakiniku.jp/sakai/", foodImageUrl: "https://www.yakiniku.jp/sakai/wp-content/uploads/2018/07/1450_1200_topimage_01.png")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.dummyRecipes) { recipe in
                    NavigationLink(
                        destination: WebView(loadUrl: recipe.recipeUrl),
                        label: {
                            HStack {
                                Image("yakiniku")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:100, height: 100, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(recipe.recipeTitle)
                                    .padding(.vertical, 5.0)
                            }
                            .padding(.vertical, 5.0)
                        })
                    
                    
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

// MARK:- WebView
/// https://qiita.com/wiii_na/items/36123cf901839a8038e2
struct WebView: UIViewRepresentable {
    var loadUrl:String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: loadUrl)!))
    }
}

// MARK:- Preview
struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(meatPart: .gyu_tongue)
    }
}
