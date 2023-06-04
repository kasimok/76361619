//
//  ContentView.swift
//  76361619
//
//  Created by 0x67 on 2023-06-02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AudioVisualizerView(audioMgr: kAudioMgr)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
