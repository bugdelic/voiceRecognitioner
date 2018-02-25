/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The primary view controller. The speach-to-text engine is managed an configured here.
*/

import UIKit
import Speech
import AVFoundation

//import framework
import SwiftOSC
import CoreBluetooth
import BlueCapKit

let address = OSCAddressPattern("/test/")
var port="8080"
var url="sonic.local"

// Setup Client. Change address from localhost if needed.
var client = OSCClient(address: url, port: Int(port)!)

//let manager = BluetoothManager(queue: .main)


public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    /** SpeechSynthesizerクラス */
    
    var talker = AVSpeechSynthesizer()
    
    // MARK: UIViewController
    
    // Catクラスの初期化処理
    var bug = BugConnector();
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
                The callback may not be called on the main thread. Add an
                operation to the main queue to update the record button's state.
            */
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.recordButton.isEnabled = true

                    case .denied:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)

                    case .restricted:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)

                    case .notDetermined:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode:AVAudioInputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                

                let text = self.textView.text!
                
                //var bugArray =  self.bug.setQue(text)
                
                //var bugJson = self.bug.setQue(text)
                let bugJson = self.bug.checkText(text)
                
                self.speak(mySpeak:text as NSString)
                
                let message = OSCMessage(address, bugJson)
                client.send(message)
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
    }

    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    /** ボタンが押された時の処理 */
    public func speak(mySpeak:NSString)
    {
        
        let speech = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "わたしはうちゅうじんをみた！")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.5 //速度 0.0 ~ 1.0 デフォルト0.5
        utterance.pitchMultiplier = 0.3 //声の高さ デフォルト1.0
        speech.speak(utterance)
        
        SpeechManager.sharedInstance.startSpeech(speechText: "2017年の流行語大賞は、インスタ映えと忖度")
        
    }
    
    /** ボタンが押された時の処理 */
    @IBAction func didTapBleButton(sender: UIButton)
    {
        
        self.bug.initBle(self)
    }
 /** ボタンが押された時の処理 */
        @IBAction func didTapButton(sender: UIButton)
        {
        
        // 話す内容をセット
        let utterance = AVSpeechUtterance(string:self.textView.text)
        // 言語を日本に設定
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        self.talker.speak(utterance)
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func sendBLE1(_ sender: UIButton) {
        // port = sender.text!
        self.bug.sendData(1, value: 1);
    }
    @IBAction func sendBLE10(_ sender: UIButton) {
        // port = sender.text!
        self.bug.sendData(1, value: 0);
    }
    @IBAction func sendBLE2(_ sender: UIButton) {
        // port = sender.text!
        
        self.bug.sendData(2, value: 1);
    }
    @IBAction func sendBLE20(_ sender: UIButton) {
        // port = sender.text!
        
        self.bug.sendData(2, value: 0);
    }
    @IBAction func setURL(_ sender: UITextField) {
       // url = sender.text!
    }
    @IBAction func setPort(_ sender: UITextField) {
       // port = sender.text!
        
    }
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    @IBAction func recordButtonDown() {
        
        try! startRecording()
        recordButton.setTitle("Stop recording", for: [])
    }
    @IBAction func recordButtonUp() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        }
    }
}

