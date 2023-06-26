//
//  OnBoardingViewModel.swift
//  Estfham
//
//  Created by Lama AL Yousef on 20/06/2023.
//

import Foundation
import SwiftUI

struct LiquidShape: Shape {
    var offset: CGSize
    var curvePoint: CGFloat
    
    // MARK: SHAPE ANIMATION
    var animatableData: AnimatablePair<CGSize.AnimatableData, CGFloat>{
        get{
            return AnimatablePair(offset.animatableData, curvePoint)
        }
        set{
            offset.animatableData = newValue.first
            curvePoint = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
            return Path{path in
                let width = rect.width + (-offset.width > 0 ? offset.width : 0)
                
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: rect.width, y: 0))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                
                // MARK: - FROM
                let from = 80 + (offset.width)
                path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
                
                // MAR: - TO
                var to = 180 + (offset.height) + (-offset.width)
                to = to < 180 ? 180 : to
                
                let mid : CGFloat = 80 + ((to - 80) / 2)
                
                path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - curvePoint, y: mid), control2: CGPoint(x: width - curvePoint, y: mid))
                
            }
        }
}

@ViewBuilder
func IntroView(intro: Intro)->some View {
    VStack {
        ZStack{
            VStack{
                
                LottieView(name: intro.lottieAnimationName, size: CGSize(width: 350, height: 350))
                
                Spacer()
                    .frame(height: 200)
        }
       
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 380)
                Text(intro.title)
                    .font(.system(size: 40))
                    .textCase(.uppercase)
                Spacer()
                    .frame(height: 15)
                Text(intro.subTitle)
                    .font(.system(size: 36, weight: .bold))
                   
                
          
                
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding([.trailing, .top])
        }
  
        

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        
        intro.color
    
    )
}


// MARK: - VIEW ETENSION

extension View{
func getRect()->CGRect{
    return UIScreen.main.bounds
}
}
