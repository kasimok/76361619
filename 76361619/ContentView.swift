//
//  ContentView.swift
//  76361619
//
//  Created by 0x67 on 2023-06-02.
//

import SwiftUI
import AVFoundation
import Combine

private var cancellables = Set<AnyCancellable>()


struct ContentView: View {
  
  @State private var devices:  [AVAudioSessionPortDescription] = []
  @State private var currentDevice: String = ""
  
  var body: some View {
    ZStack{
      DynoView(style: .circle, elementCount: 4)
      VStack(alignment: .leading) {
        HStack{
          Text("Visualization:")
          AudioVisualizerView(audioMgr: kAudioMgr)
        }
        HStack{
          Text("Input Devices:")
          withAnimation {
            Picker("Current Audio Input", selection: $currentDevice) {
              ForEach(devices, id: \.portName) {
                Text($0.portName)
              }
            }.pickerStyle(.segmented).onChange(of: currentDevice) { newValue in
              
              debugPrint("Selection Changed to: \(newValue)")
              
              if let inputDevicePortDescription = devices.first(where: {$0.portName == currentDevice}) {
                
                do {
                  try AVAudioSession.sharedInstance().setPreferredInput(inputDevicePortDescription)
                  debugPrint("Set preferred input to:\(inputDevicePortDescription)")
                } catch{
                  debugPrint("Error Setting input: \(error)")
                }
                
              }
            }
          }
          
        }
      }.padding()
    }
      .onAppear(){
        NotificationCenter.Publisher(center: .default, name: AVAudioSession.routeChangeNotification).sink { noti in
          self.refreshData()
        }.store(in: &cancellables)
      }
  }
  private func refreshData(){
    debugPrint("\(#function): AVAudioSession.routeChangeNotification: ",AVAudioSession.sharedInstance().currentRoute.inputs.first?.portName ?? "NA")
    devices = AVAudioSession.sharedInstance().availableInputs ?? []
    currentDevice = AVAudioSession.sharedInstance().currentRoute.inputs.first?.portName ?? ""
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
