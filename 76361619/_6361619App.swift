//
//  _6361619App.swift
//  76361619
//
//  Created by 0x67 on 2023-06-02.
//

import SwiftUI
import AVFoundation

@main
struct _6361619App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
              let session = AVAudioSession.sharedInstance()
              try? session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
              try? session.setActive(true)
              kAudioMgr.startMonitoring()
            }
        }
    }
}
