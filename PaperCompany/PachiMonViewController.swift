//
//  PachiMonViewController.swift
//  PaperCompany
//
//  Created by satorupan on 2018/02/17.
//  Copyright © 2018年 satorupan. All rights reserved.
//

import UIKit
//import framework
import SwiftOSC

import Speech
import AVFoundation


var pachimonPort="9998"
var pachimonUrl="10.0.1.3"


class PachiMonViewController: UIViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate  {
    
    
    
    @IBOutlet var url: UITextField!
    @IBOutlet var port: UITextField!
    
    @IBOutlet var address: UITextField!
    
    @IBOutlet var msgtype: UITextField!
    @IBOutlet var playerid: UITextField!
    @IBOutlet var target: UITextField!
    @IBOutlet var direction: UITextField!
    @IBOutlet var posx: UITextField!
    @IBOutlet var posy: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dirIcon: UIImageView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton : UIButton!
    
    
    
    // 表示する画像を設定する.
    
    let myImage0 = UIImage()
    let myImage1 = UIImage(named: "img0.jpg")
    let myImage2 = UIImage(named: "img1.jpg")
    let myImage3 = UIImage(named: "img2.jpg")
    let myImage4 = UIImage(named: "img3.jpg")
    let myImage5 = UIImage(named: "img4.jpg")
    let myImage6 = UIImage(named: "img5.jpg")
    let myImage7 = UIImage(named: "img6.jpg")
    let myImage8 = UIImage(named: "img7.jpg")
    
    
    let myDir0 = UIImage()
    let myDir1 = UIImage(named: "dir0.png")
    let myDir2 = UIImage(named: "dir1.png")
    let myDir3 = UIImage(named: "dir2.png")
    let myDir4 = UIImage(named: "dir3.png")
    let myDir5 = UIImage(named: "dir4.png")
    let myDir6 = UIImage(named: "dir5.png")
    let myDir7 = UIImage(named: "dir6.png")
    let myDir8 = UIImage(named: "dir7.png")
    /** SpeechSynthesizerクラス */
    
    var talker = AVSpeechSynthesizer()
    
    // MARK: UIViewController
    
    // Catクラスの初期化処理
    var bug = BugConnector();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendOSC(_ sender: Any) {
        
        
        
        //let bugJson = "HELLO POIPOI"
        
        
        // Setup Client. Change address from localhost if needed.
        
        //var pachimoClient = OSCClient(address: pachimonUrl, port: Int(pachimonPort)!)

        let pachimoClient = OSCClient(address: url.text!, port: Int(port.text!)!)
        
        
        let address1  = OSCAddressPattern("/shogi/playerid")
        let text1 : String = self.playerid.text!
        let message1 = OSCMessage(address1, text1)
        //pachimoClient.send(message1)
        
        let address2 = OSCAddressPattern("/shogi/target")
        let text2 : String = self.target.text!
        let message2 = OSCMessage(address2, text2)
        //pachimoClient.send(message2)
        
        let address3 = OSCAddressPattern("/shogi/direction")
        let text3 : String = self.direction.text!
        let message3 = OSCMessage(address3, text3)
        //pachimoClient.send(message3)
        
        let address4 = OSCAddressPattern("/shogi/msgtype")
        let text4 : String = self.msgtype.text!
        let message4 = OSCMessage(address4, text4)
        //pachimoClient.send(message4)
        
        let address5 = OSCAddressPattern("/shogi/posx")
        let text5 : String = self.posx.text!
        let message5 = OSCMessage(address5, text5)
        //pachimoClient.send(message5)
        
        let address6 = OSCAddressPattern("/shogi/posy")
        let text6 : String = self.posy.text!
        let message6 = OSCMessage(address6, text6)
       // pachimoClient.send(message6)
        
        if(text4=="0"){
            let bundle=OSCBundle(message4,message1,message2,message3)
            pachimoClient.send(bundle)
        }else{
            let bundle=OSCBundle(message4,message1,message2,message5,message6)
            pachimoClient.send(bundle)
        }
        
       
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
                
                if(text=="ましまし" || text=="もしもし" || text=="真島氏"){
                    self.sendOSC("")
                    self.msgtype.text=String(0);
                    self.target.text=String("");
                    self.direction.text=String("");
                    self.posx.text=String("");
                    self.posy.text=String("");
                    self.imageView.image=self.myImage0
                    self.dirIcon.image=self.myDir0
                }else if(text=="鳥" || text=="トリ"){
                    self.target.text=String(0)
                    self.imageView.image=self.myImage1
                }else if(text=="ぴよぴよ" || text=="にはには"){
                    self.target.text=String(1)
                    self.imageView.image=self.myImage2
                }else if(text=="象" || text=="ゾウ" || text=="蔵"){
                    self.target.text=String(2)
                    self.imageView.image=self.myImage3
                }else if(text=="マンモス"){
                    self.target.text=String(3)
                    self.imageView.image=self.myImage4
                }else if(text=="ライオン" || text=="ライオン"){
                    self.target.text=String(4)
                    self.imageView.image=self.myImage5
                }else if(text=="ライガー" || text=="タイゴン"){
                    self.target.text=String(5)
                    self.imageView.image=self.myImage6
                }else if(text=="キリン" || text=="切り"){
                    self.target.text=String(6)
                    self.imageView.image=self.myImage7
                }else if(text=="白" || text=="じらす"){
                    self.target.text=String(7)
                    self.imageView.image=self.myImage8
                }
                
                if(text=="左前" || text=="ひだりまえ"){
                    self.direction.text=String(0)
                    self.dirIcon.image=self.myDir1
                }else if(text=="前" || text=="まえ" || text=="米"){
                    self.direction.text=String(1)
                    self.dirIcon.image=self.myDir2
                }else if(text=="右前" || text=="みぎまえ"){
                    self.direction.text=String(2)
                    self.dirIcon.image=self.myDir3
                }else if(text=="左" || text=="ひだり"){
                    self.direction.text=String(3)
                    self.dirIcon.image=self.myDir4
                }else if(text=="右" || text=="みぎ"){
                    self.direction.text=String(4)
                    self.dirIcon.image=self.myDir5
                }else if(text=="左後ろ" || text=="ひだりうしろ"){
                    self.direction.text=String(5)
                    self.dirIcon.image=self.myDir6
                }else if(text=="後" || text=="うしろ"){
                    self.direction.text=String(6)
                    self.dirIcon.image=self.myDir7
                }else if(text=="右後ろ" || text=="みぎうしろ"){
                    self.direction.text=String(7)
                    self.dirIcon.image=self.myDir8
                }
                
                if(text=="パチパチ"){
                    self.msgtype.text=String(1);
                }
                
                
                if(text=="A" || text=="えー" || text=="笑"){
                    self.posx.text=String(0);
                }else if(text=="B" || text=="びー"){
                    self.posx.text=String(1);
                }else if(text=="C" || text=="水"){
                    self.posx.text=String(2);
                }
                
                if(text=="1" || text=="いち"){
                    self.posy.text=String(0);
                }else if(text=="2" || text=="に"){
                    self.posy.text=String(1);
                }else if(text=="3" || text=="さん"){
                    self.posy.text=String(2);
                }else if(text=="4" || text=="し"){
                    self.posy.text=String(3);
                }else if(text=="5" || text=="ご"){
                    self.posy.text=String(4);
                }
                
                if(text=="先行"){
                    self.playerid.text=String(0);
                }else if(text=="高校"){
                    self.playerid.text=String(1);
                }
                
                let dir=self.direction.text!
                if(dir==""){
                    self.msgtype.text!=String(1);
                }else{
                    self.msgtype.text!=String(0);
                }
                
                if(text=="なしなし" || text=="消し消し"){
                    self.msgtype.text=String(0);
                    self.target.text=String("");
                    self.direction.text=String("");
                    self.posx.text=String("");
                    self.posy.text=String("");
                    self.imageView.image=self.myImage0
                    self.dirIcon.image=self.myDir0
                }
                
                //var bugArray =  self.bug.setQue(text)
                
                //var bugJson = self.bug.setQue(text)
                let bugJson = self.bug.checkText(text)
                
                //self.speak(mySpeak:text as NSString)
                
                let address0 = OSCAddressPattern("/shogi/msgtype")
               let message = OSCMessage(address0, bugJson)
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
