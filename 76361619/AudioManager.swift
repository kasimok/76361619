//
//  MicroPhonePowerMonitor.swift
//  showCaseApp
//
//  Created by 0x67 on 2023-05-25.
//

import Foundation
import AVFoundation
import Accelerate


class AudioManager: ObservableObject {
  
  private let numberOfSamples: Int
  
  private var currentSample: Int
  
  private (set) var audioEngine: AVAudioEngine = AVAudioEngine()
    
  private let sampleRate = 16000.0
  
  private let bufferSize = 2048
  
  let LEVEL_LOWPASS_TRIG: Float32 = 0.30
  
  private var averagePowerForChannel0: Float = -100
      
  @Published public var soundSamples: [Float]
  
  private var displayLink: CADisplayLink?
  
  init(numberOfSamples: Int){
    self.numberOfSamples = numberOfSamples
    self.soundSamples = [Float](repeating: 0, count: numberOfSamples)
    self.currentSample = 0
    displayLink = CADisplayLink(target: self, selector: #selector(updateSoundSamples))
    displayLink?.add(to: .main, forMode: .default)
  }
  
  public func startMonitoring(){
    let inputNode = audioEngine.inputNode
    let inputFormat = inputNode.outputFormat(forBus: 0)

    // Install a tap on the audio engine with the buffer size and the input format.
    audioEngine.inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: inputFormat) { buffer, _ in
      
      self.audioMetering(buffer: buffer)
    }
    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch {
      debugPrint("\(error.localizedDescription)")
    }
  }
  
  @objc
  private func updateSoundSamples() {
    self.soundSamples[self.currentSample] = self.averagePowerForChannel0
    self.currentSample = (self.currentSample + 1) % self.numberOfSamples
  }
  
  public func stopMonitoring(){
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
  }
  
  private func audioMetering(buffer: AVAudioPCMBuffer) {
    buffer.frameLength = 1024
    let inNumberFrames: UInt = UInt(buffer.frameLength)
    
    switch buffer.format.commonFormat {
    case .pcmFormatFloat32:
      if buffer.format.channelCount > 0 {
        let samples = buffer.floatChannelData![0]
        var avgValue: Float32 = 0
        vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
        var v: Float32 = -100
        if avgValue != 0 {
          v = 20.0 * log10f(avgValue)
        }
        self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG * v) + ((1 - self.LEVEL_LOWPASS_TRIG) * self.averagePowerForChannel0)
      }
    case .pcmFormatInt16:
      if buffer.format.channelCount > 0 {
        let samples = buffer.int16ChannelData![0]
        var floatSamples = [Float](repeating: 0, count: Int(buffer.frameLength))
        vDSP_vflt16(samples, 1, &floatSamples, 1, inNumberFrames)
        var avgValue: Float32 = 0
        vDSP_meamgv(floatSamples, 1, &avgValue, inNumberFrames)
        var v: Float32 = -100
        if avgValue != 0 {
          v = 20.0 * log10f(avgValue)
        }
        self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG * v) + ((1 - self.LEVEL_LOWPASS_TRIG) * self.averagePowerForChannel0)
      }
    default:
      break
    }
  }
  
  
  deinit{
    displayLink?.invalidate()
  }
  
}
