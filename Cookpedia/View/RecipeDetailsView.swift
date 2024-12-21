//
//  RecipeDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 20/12/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @State private var recipeDetails: RecipeDetails
    let recipeId: Int
    var apiGetManager = APIGetRequest()
    
    // Private initializer for internal use only
    private init(recipeDetails: RecipeDetails, recipeId: Int) {
        self.recipeDetails = recipeDetails
        self.recipeId = recipeId
    }
    
    // Public initializer for NavigationLink and external use
    init(recipeId: Int) {
        self.recipeId = recipeId
        self.recipeDetails = RecipeDetails(
            id: recipeId,
            userId: 0,
            title: "Loading...",
            recipeCoverPictureUrl1: "",
            recipeCoverPictureUrl2: "",
            description: "",
            cookTime: "",
            serves: "",
            origin: "",
            ingredients: [],
            instructions: [],
            fullName: "",
            profilePictureUrl: "",
            username: ""
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl1).jpg")) { image in
                                    image
                                        .resizable()
                                        .frame(width: geometry.size.width, height: 430)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color("Greyscale400"))
                                        .frame(width: geometry.size.width, height: 430)
                                }
                                
                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl2).jpg")) { image in
                                    image
                                        .resizable()
                                        .frame(width: geometry.size.width, height: 430)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color("Greyscale400"))
                                        .frame(width: geometry.size.width, height: 430)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(recipeDetails.title)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 32))
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Dark4"))
                                    }
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(recipeDetails.profilePictureUrl).jpg")) { image in
                                        image
                                            .resizable()
                                            .frame(width: 72, height: 72)
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color("Greyscale400"))
                                            .frame(width: 72, height: 72)
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipeDetails.fullName)
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                        Text("@\(recipeDetails.username)")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Medium", size: 16))
                                    }
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Text("Follow")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                            .frame(width: 86, height: 38)
                                            .background(Color("Primary900"))
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    }
                                }
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Dark4"))
                                    }
                                Text(recipeDetails.description)
                                    .foregroundStyle(Color("Greyscale50"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                                HStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        HStack(spacing: 6) {
                                            Image("time-circle")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Text("\(recipeDetails.cookTime) mins")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                        }
                                        Text("cook time")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(Color("Dark3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(spacing: 6) {
                                        HStack(spacing: 6) {
                                            Image("profile-unselected")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Text("\(recipeDetails.serves) serving")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                        }
                                        Text("serve")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(Color("Dark3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(spacing: 6) {
                                        HStack(spacing: 6) {
                                            Image("location-primary")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Text(recipeDetails.origin)
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                        Text("origin")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(Color("Dark3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                }
                            }
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Dark4"))
                                }
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Ingredients:")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 24))
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(recipeDetails.ingredients, id: \.index) { ingredient in
                                        HStack(spacing: 16) {
                                            Circle()
                                                .foregroundStyle(Color("Dark3"))
                                                .frame(width: 32, height: 32)
                                                .overlay {
                                                    Text("\(ingredient.index)")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Semibold", size: 16))
                                                }
                                            Text(ingredient.ingredient)
                                                .foregroundStyle(Color("MyWhite"))
                                                .font(.custom("Urbanist-Medium", size: 18))
                                        }
                                    }
                                }
                            }
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Dark4"))
                                }
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Instructions:")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 24))
                                ForEach(recipeDetails.instructions, id: \.index) { instruction in
                                    HStack(alignment: .top, spacing: 16) {
                                        Circle()
                                            .foregroundStyle(Color("Dark3"))
                                            .frame(width: 32, height: 32)
                                            .overlay {
                                                Text("\(instruction.index)")
                                                    .foregroundStyle(Color("Primary900"))
                                                    .font(.custom("Urbanist-Semibold", size: 16))
                                            }
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text("\(instruction.instruction)")
                                                .foregroundStyle(Color("MyWhite"))
                                                .font(.custom("Urbanist-Medium", size: 18))
                                            HStack(spacing: 8) {
                                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl1 ?? "").jpg")) { image in
                                                    image
                                                        .resizable()
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 80)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } placeholder: {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .foregroundStyle(Color("Dark1"))
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 0)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                }
                                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl2 ?? "").jpg")) { image in
                                                    image
                                                        .resizable()
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 80)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } placeholder: {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .foregroundStyle(Color("Dark1"))
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 0)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                }
                                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl3 ?? "").jpg")) { image in
                                                    image
                                                        .resizable()
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 80)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } placeholder: {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .foregroundStyle(Color("Dark1"))
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 0)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Dark4"))
                                }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .all)
            .background(Color("Dark1"))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 20) {
                        Button {
                            //
                        } label: {
                            Image("bookmark-unselected")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        Button {
                            //
                        } label: {
                            Image("send")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        Button {
                            //
                        } label: {
                            Image("more-circle")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                }
            }
            .onAppear {
                apiGetManager.getRecipeDetails(recipeId: recipeId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let details):
                                self.recipeDetails = details
                            case .failure(let error):
                                print("error \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeId: 1)
}
