//
//  AudioVisualizer.swift
//  OpenAI
//
//  Created by 0x67 on 2023-05-26.
//

import Foundation
import SwiftUI

let kNumberOfSamples: Int = 12
let kBarHeight:CGFloat = 20
let kVisualizerWidth:CGFloat = 80
let kVisualizerPadding:CGFloat = 10

let kAudioMgr = AudioManager(numberOfSamples: kNumberOfSamples)

struct AudioVisualizerView: View {
  
  @ObservedObject var audioMgr = kAudioMgr
  
  var body: some View {
    VStack{
      ZStack{
        Color(hex: 0x00A87C)
        HStack(spacing: 2) {
          ForEach(audioMgr.soundSamples.indices, id: \.self) { index in
            BarView(value: self.normalizeSoundLevel(level: audioMgr.soundSamples[index]))
              .id(index)
          }
        }.padding(kVisualizerPadding)
      }.frame(width: kVisualizerWidth,height: kBarHeight).cornerRadius(4)
    }
  }
  
  
  private func normalizeSoundLevel(level: Float) -> CGFloat {
    let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
    return CGFloat(level * (kBarHeight / 25)) // scaled to max at 300 (our height of our bar)
  }
}

struct BarView: View {
  
  var value: CGFloat
  
  var body: some View {
    RoundedRectangle(cornerRadius: 1)
      .fill(LinearGradient(gradient: Gradient(colors: [.white, .white]),
                           startPoint: .top,
                           endPoint: .bottom))
      .frame(width: (kVisualizerWidth - kVisualizerPadding * 2 - CGFloat(kNumberOfSamples) * 2) / CGFloat(kNumberOfSamples), height: max(value,1))
  }
  
}

struct AudioVisualizerView_Previews: PreviewProvider {
  static var previews: some View {
    AudioVisualizerView()
  }
}
