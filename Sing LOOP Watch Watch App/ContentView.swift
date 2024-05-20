//
//  ContentView.swift
//  Sing LOOP Watch Watch App
//
//  Created by Pieter Yoshua Natanael on 08/04/24.
//


import SwiftUI
import AVFoundation

/// The main view for the app.
struct ContentView: View {
    // State variables for audio recording and playback.
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var showAppFunctionality = false
    @State private var showAds = false
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)), .clear], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // Header with buttons
                    HStack {
                        Button(action: {
                            showAds = true
                        }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Text("Sing L00P")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        
                        Button(action: {
                            showAppFunctionality = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    // Record button
                    Button(action: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        Text(isRecording ? "Stop" : "Record")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.black)
                            .frame(width: 120)
                            .background(isRecording ? Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)) : Color.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Play button
                    Button(action: {
                        if isPlaying {
                            stopPlayback()
                        } else {
                            startPlayback()
                        }
                    }) {
                        Text(isPlaying ? "Stop" : "Play")
                            .font(.title3.bold())
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .background(isPlaying ? Color.red : Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)))
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .sheet(isPresented: $showAds) {
                    showAdsView(onConfirm: {
                        showAds = false
                    })
                }
                .sheet(isPresented: $showAppFunctionality) {
                    showAppFunctionalityView(onConfirm: {
                        showAppFunctionality = false
                    })
                }
                .padding()
                .onAppear {
                    setupAudioSession()
                }
            }
        }
    }
    
    /// Sets up the audio session for recording and playback.
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting AVAudioSession category: \(error.localizedDescription)")
        }
    }
    
    /// Starts recording audio.
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    /// Stops recording audio.
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    /// Starts playing the recorded audio.
    private func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.numberOfLoops = -1 // Play on loop
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Could not start playback: \(error.localizedDescription)")
        }
    }
    
    /// Stops playing the audio.
    private func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    /// Gets the documents directory URL.
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - App Functionality View

/// A view to explain the app functionality.
struct showAppFunctionalityView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("App Functionality")
                        .font(.caption.bold())
                    Spacer()
                }

                Text("""
                • Press the record button to start recording sound.
                • Press the record button again to stop recording.
                • Press the play button to hear the playback in a loop.
                • Press the play button again to stop playback.
                • Each new recording will overwrite the previous one.
                """)
                .font(.caption2)
                .multilineTextAlignment(.leading)
                .padding()

                Spacer()

                Button("Close") {
                    onConfirm()
                }
                .font(.title3)
                .padding()
                .cornerRadius(25.0)
                .padding()
            }
            .padding()
            .cornerRadius(15.0)
            .padding()
        }
    }
}

// MARK: - Ads View

/// A view to display ads.
struct showAdsView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Ads")
                        .font(.title.bold())
                    Spacer()
                }
                ZStack {
                    Image("threedollar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(25)
                        .clipped()
                }

                HStack {
                    Text("Three Dollar Apps")
                        .font(.caption.bold())
                        .padding()
                    Spacer()
                }
                Divider().background(Color.gray)

                VStack {
                    AppCardView(imageName: "bodycam", appName: "BODYCam", appDescription: "Record videos effortlessly and discreetly.", appURL: "https://apps.apple.com/id/app/b0dycam/id6496689003")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "worry", appName: "Worry Bin", appDescription: "A place for worry.", appURL: "https://apps.apple.com/id/app/worry-bin/id6498626727")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "loopspeak", appName: "LOOPSpeak", appDescription: "Type or paste your text, play in loop, and enjoy hands-free narration.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "Design to ease your mind and help you relax leading up to sleep.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "dryeye", appName: "Dry Eye Read", appDescription: "The go-to solution for a comfortable reading experience, by adjusting font size and color to suit your reading experience.", appURL: "https://apps.apple.com/id/app/dry-eye-read/id6474282023")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "iprogram", appName: "iProgramMe", appDescription: "Custom affirmations, schedule notifications, stay inspired daily.", appURL: "https://apps.apple.com/id/app/iprogramme/id6470770935")
                    Divider().background(Color.gray)
                    AppCardView(imageName: "temptation", appName: "TemptationTrack", appDescription: "One button to track milestones, monitor progress, stay motivated.", appURL: "https://apps.apple.com/id/app/temptationtrack/id6471236988")
                    Divider().background(Color.gray)
                }
                .padding()

                Spacer()

                Button("Close") {
                    onConfirm()
                }
                .font(.title3)
                .padding()
                .cornerRadius(25.0)
                .padding()
            }
            .padding()
            .cornerRadius(15.0)
            .padding()
        }
    }
}

/// A view to display an individual ads app card.
// MARK: - Ads App Card View
struct AppCardView: View {
    var imageName: String
    var appName: String
    var appDescription: String
    var appURL: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .cornerRadius(6)
            
            VStack(alignment: .leading) {
                Text(appName)
                    .font(.title3)
                Text(appDescription)
                    .font(.caption2)
            }
            .frame(alignment: .leading)
            
            Spacer()
            Button(action: {
                openURL(appURL)
            }) {
                Text("Try")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// Helper function to open URLs on watchOS
func openURL(_ urlString: String) {
    if let url = URL(string: urlString) {
        WKExtension.shared().openSystemURL(url)
    }
}


/*
 
 //great but want to improve
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var showAdsAndAppFunctionality: Bool = false
    @State private var showAd: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),.clear], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                   
                    HStack {
                        Button(action: {
                            showAd = true
                        }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                               
                            Spacer()
                            
                            Text("Sing L00P")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Button(action: {
                                showAdsAndAppFunctionality = true
                            }) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                        

                    Spacer()

                    Button(action: {
                        if isRecording {
                            self.stopRecording()
                        } else {
                            self.startRecording()
                        }
                    }){
                        Text(isRecording ? "Stop" : "Record")
                            .font(.headline)
                            .padding()
                            .foregroundColor(isRecording ? Color.black : Color.black)
                            .frame(width: 120)
                            .background(isRecording ? Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)) : Color.white)
                           
                            .cornerRadius(10)
                         
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                   

                    Button(action: {
                        if isPlaying {
                            self.stopPlayback()
                        } else {
                            self.startPlayback()
                        }
                    }) {
                        Text(isPlaying ? "Stop" : "Play")
                            .font(.title3.bold())
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .background(isPlaying ? Color.red : Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)))
                            .cornerRadius(10)
                            
                    }
                    .buttonStyle(PlainButtonStyle())
                    

//                    Text("Press the record button to start recording sound and press it again to stop recording. Press the play button to hear the playback in a loop, and press it again to stop playback. Each new recording will overwrite the previous one.")
//                        .padding()
                }
                .sheet(isPresented: $showAd) {
                    ShowAdView(onConfirm: {
                        showAd = false
                    })
                }
                .sheet(isPresented: $showAdsAndAppFunctionality) {
                    ShowExplainView(onConfirm: {
                        showAdsAndAppFunctionality = false
                    })
                }
                .padding()
                .onAppear {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        print("Error setting AVAudioSession category: \(error.localizedDescription)")
                    }
            }
            }
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.numberOfLoops = -1 // Play on loop
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Could not start playback: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Explain View
struct ShowExplainView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
               HStack{
                   Text("App Functionality")
                       .font(.caption.bold())
                   Spacer()
               }
               
               Text("""
               • Press the record button to start recording sound.
               • Press the record button again to stop recording.
               • Press the play button to hear the playback in a loop.
               • Press the play button again to stop playback.
               • Each new recording will overwrite the previous one.
               """)
               .font(.caption2)
               .multilineTextAlignment(.leading)
               .padding()
               
               Spacer()

               Button("Close") {
                   // Perform confirmation action
                   onConfirm()
               }
               .font(.title3)
               .padding()
               .cornerRadius(25.0)
               .padding()
           }
           .padding()
           .cornerRadius(15.0)
           .padding()
        }
    }
}

// MARK: - Ad View
struct ShowAdView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Ads")
                        .font(.title.bold())
                    Spacer()
                }
                ZStack {
                    Image("threedollar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(25)
                        .clipped()
//                        .onTapGesture {
//                            openURL("https://b33.biz/three-dollar/")
//                        }
                }
                // App Cards
                HStack {
                    Text("Three Dollar Apps")
                        .font(.caption.bold())
                        .padding()
                    Spacer()
                }
                Divider().background(Color.gray)

                VStack {
                    AppCardView(imageName: "bodycam", appName: "BODYCam", appDescription: "Record videos effortlessly and discreetly.", appURL: "https://apps.apple.com/id/app/b0dycam/id6496689003")
                    Divider().background(Color.gray)
                    // Add more AppCardViews here if needed
                    // App Data
                 
                    
                    AppCardView(imageName: "timetell", appName: "TimeTell", appDescription: "Announce the time every 30 seconds, no more guessing and checking your watch, for time-sensitive tasks.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "worry", appName: "Worry Bin", appDescription: "A place for worry.", appURL: "https://apps.apple.com/id/app/worry-bin/id6498626727")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "loopspeak", appName: "LOOPSpeak", appDescription: "Type or paste your text, play in loop, and enjoy hands-free narration.", appURL: "https://apps.apple.com/id/app/loopspeak/id6473384030")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "insomnia", appName: "Insomnia Sheep", appDescription: "Design to ease your mind and help you relax leading up to sleep.", appURL: "https://apps.apple.com/id/app/insomnia-sheep/id6479727431")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "dryeye", appName: "Dry Eye Read", appDescription: "The go-to solution for a comfortable reading experience, by adjusting font size and color to suit your reading experience.", appURL: "https://apps.apple.com/id/app/dry-eye-read/id6474282023")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "iprogram", appName: "iProgramMe", appDescription: "Custom affirmations, schedule notifications, stay inspired daily.", appURL: "https://apps.apple.com/id/app/iprogramme/id6470770935")
                    Divider().background(Color.gray)
                    
                    AppCardView(imageName: "temptation", appName: "TemptationTrack", appDescription: "One button to track milestones, monitor progress, stay motivated.", appURL: "https://apps.apple.com/id/app/temptationtrack/id6471236988")
                    Divider().background(Color.gray)
                
                }
                Spacer()

                // Close Button
                Button("Close") {
                    // Perform confirmation action
                    onConfirm()
                }
                .font(.title3)
                .padding()
                .cornerRadius(25.0)
                .padding()
            }
            .padding()
            .cornerRadius(15.0)
            .padding()
        }
    }
}

// Helper function to open URLs on watchOS
func openURL(_ urlString: String) {
    if let url = URL(string: urlString) {
        WKExtension.shared().openSystemURL(url)
    }
}

// MARK: - App Card View
struct AppCardView: View {
    var imageName: String
    var appName: String
    var appDescription: String
    var appURL: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .cornerRadius(6)
            
            VStack(alignment: .leading) {
                Text(appName)
                    .font(.title3)
                Text(appDescription)
                    .font(.caption2)
            }
            .frame(alignment: .leading)
            
            Spacer()
            Button(action: {
                openURL(appURL)
            }) {
                Text("Try")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}


*/

/*

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
 Text("Press the record button to start recording sound and press it again to stop recording. Press the play button to hear the playback in a loop, and press it again to stop playback. Each new recording will overwrite the previous one.")
     .padding()
*/
