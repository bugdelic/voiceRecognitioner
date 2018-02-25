//
//  SpeechManager.swift
//  PaperCompany
//
//  Created by satorupan on 2018/02/13.
//  Copyright © 2018年 satorupan. All rights reserved.
//

import AVFoundation

class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    
    static let sharedInstance = SpeechManager()
    
    let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        // delegateの設定
        synthesizer.delegate = self
    }
    
    // 音声再生開始
    func startSpeech(speechText: String) {
        synthesizer.speak(setSpeechText(text: speechText))
    }
    
    // 音声再生停止
    func stopSpeech() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    // 音声設定
    private func setSpeechText(text: String) -> AVSpeechUtterance {
        // AVSpeechUtteranceを作成
        let utterance = AVSpeechUtterance(string: text)
        // 言語を設定
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        // 再生速度を設定
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        // 声の高さを設定
        utterance.pitchMultiplier = 1.0
        
        return utterance
    }
    
    // 読み上げが開始したとき
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
    }
    
    // 読み上げが終了したとき
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
    }
    
    // 読み上げが一時停止したとき
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("didPause")
    }
    
    // 読み上げが一時停止から再生されたとき
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("didContinue")
    }
    
    // 読み上げが途中で終了したとき
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("didCancel")
    }
    
    // 読み上げ中で字句ごとに呼ばれる
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        print("willSpeak")
    }
}
