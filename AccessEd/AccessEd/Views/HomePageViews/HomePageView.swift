//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI
import SwiftData


struct HomePageView: View {
    @StateObject var viewModel = CourseViewModel()
        
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("AccessEd")
                            .font(.title)
                        
                        Spacer()
                        
                        Image("App Logo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .clipped()
                    }
                    .padding()
                    .padding(.top, 50)
                    .frame(maxWidth: 240, maxHeight: 150)

                    
                    
                    // Courses and Schedule Layer
                    VStack(spacing: 0) {
                        CoursesLayerView(viewModel: viewModel)
//                            .frame(height: 290) //300)
                        
                        CalendarLayerView()
//                            .padding()
                    }
//                    .padding(.leading, 10)
                    .frame(width: UIScreen.main.bounds.width /*- 100*/, alignment: .leading)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, topTrailing: 0), style: .continuous)
                            .fill(Color("Light-Dark Mode Colors"))
                    )
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading)
                )
            }
            
            EachRecommendedCourseCardView(viewModel: viewModel)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color("Light-Dark Mode Colors")).ignoresSafeArea(.all)
        .alert(isPresented: $viewModel.showAlert, content: {
            viewModel.getAlert()
        })
    }
}

//#Preview("Light Mode") {
//    HomePageView()
//        .preferredColorScheme(.light)
//}
//
//#Preview("Dark Mode") {
//    HomePageView()
//        .preferredColorScheme(.dark)
//}

struct HomePageView_Previews: PreviewProvider {
   
    static var previews: some View {
        let viewModel = CalendarViewModel()
        Group {
            HomePageView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
                .environmentObject(viewModel)
            
            HomePageView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                .environmentObject(viewModel)
        }
    }
}
