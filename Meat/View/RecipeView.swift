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
    @ObservedObject var rakutenRecipeSearcher: RakutenRecipeSearcher
    
    init(meatPart: MeatPart) {
        self.meatPart = meatPart
        
        // Determine if it is in yakiniku mode
        let isYakinikuMode = UserDefaults.standard.bool(forKey: "yakiniku_mode")
        print("🥩 yakiniku mode: \(isYakinikuMode)")
        if isYakinikuMode {
            self.rakutenRecipeSearcher = RakutenRecipeSearcher(meatPart: meatPart)
        } else {
            self.rakutenRecipeSearcher = RakutenRecipeSearcher(categoryID: meatPart.rakutenRecipeCategoryID)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.rakutenRecipeSearcher.rakutenRecipeItems) { recipe in
                    NavigationLink(
                        destination: RecipeDetailView(recipe: recipe, meatPart: meatPart),
                        label: {
                            HStack {
                                URLImage(url: recipe.foodImageURL)
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
            .navigationTitle("\(self.meatPart.name) recipes")
        }
    }
}

// MARK:- Recipe Detail View
/// WebView + Share button
struct RecipeDetailView: View {
    var recipe: RakutenRecipeItem
    var meatPart: MeatPart
    
    @State private var isSharedPresented = false
    
    var body: some View {
        WebView(loadURL: recipe.recipeURL)
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        self.isSharedPresented.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            })
            .sheet(isPresented: $isSharedPresented, content: {
                ActivityView(activityItems: [URL(string: recipe.recipeURL)!, "Meatで\(meatPart.japaneseName)を使ったレシピを検索しました"], applicationActivities: nil)
            })
    }
}

// MARK:- WebView
/// https://qiita.com/wiii_na/items/36123cf901839a8038e2
struct WebView: UIViewRepresentable {
    var loadURL:String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: loadURL)!))
    }
}

// MARK:- ActivityView
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
        // Nothing to do
    }
}

// MARK:- Preview
struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(meatPart: .gyu_tongue)
    }
}
