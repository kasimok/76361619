//
// Created by 0x67 on 30/12/2022.
// Copyright © 2022 0x67. All rights reserved.
//
import Foundation
import SwiftUI

/// Background view that filled with some Brownian moving shapes
struct DynoView: View {
  
  enum DynoViewStyle{
    case roundedRect
    case circle
  }
  
  let style: DynoViewStyle
  let elementCount: Int
  
  struct GradientRectangle: View {
    
    let startColor: Color
    let endColor: Color
    
    var body: some View {
      Rectangle()
        .fill(LinearGradient(gradient: Gradient(colors: [startColor.opacity(0.1), endColor.opacity(0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
  }
  
  @State private var offset = CGSize.zero
  
  var body: some View {
    GeometryReader{ reader in
      ZStack{
        ForEach(0 ..< elementCount, id: \.self) { _ in
          let size = randomSize()
          
          GradientRectangle(startColor: Color.random, endColor: Color.random)
            .frame(width: size, height: size)
            .cornerRadius(style == .roundedRect ? size / 5 : size / 2)
            .position(x: .random(in: 0...reader.size.width), y: .random(in: 0...reader.size.height))
            .rotationEffect(randomAngle())
            .offset(offset)
            .animation(.linear(duration: Double.random(in: 30...100)).repeatForever(autoreverses: true), value: offset)
            .onAppear {
              self.offset = CGSize(width: self.randomNumber(), height: self.randomNumber())
            }
        }
      }
    }
  }
  
  
  func randomSize() -> CGFloat{
    CGFloat.random(in: 60...360)
  }
  
  func randomAngle() -> Angle{
    Angle(degrees: CGFloat.random(in: -90...90))
  }
  
  func randomNumber() -> CGFloat {
    CGFloat.random(in: -150...150)
  }
}

struct DynoView_Previews: PreviewProvider {
  static var previews: some View {
    DynoView(style: .roundedRect, elementCount: 6)
  }
}
