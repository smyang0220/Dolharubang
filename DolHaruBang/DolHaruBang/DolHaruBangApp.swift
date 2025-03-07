//
//  DolHaruBangApp.swift
//  DolHaruBang
//
//  Created by 안상준 on 7/28/24.
//

import SwiftUI
import AVFoundation

@main
struct DolHaruBangApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var userManager = UserManager()
//    let persistenceController = PersistenceController.shared


    var body: some Scene {
        WindowGroup {
            EntryPointView()
                .environmentObject(userManager)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// 어플리케이션의 생명 주기를 관리함
/*
 UIResponder - 이벤트 처리 클래스
 UIApplicationDelegate - 이벤트 처리 메서드가 정의되어 있는 프로토콜을 준수
 */
class AppDelegate: UIResponder, UIApplicationDelegate {
    var audioPlayer: AVAudioPlayer? // 오디오 파일 재생용 클래스

    // 앱이 실행되고 초기화 될 때 호출되는 메서드 from UIApplicationDelegate
    /*
     실행중인 UIApplication을 받아서 실행 성공여부를 반환
     didFinishLaunchingWithOptions의 경우 UIApplication.LaunchOptionsKey의 배열 타입으로 어플이 어떤 경유로 시작됐는지에 대한 정보를 담고 있음
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        playBackgroundMusic()
        return true
    }

    func playBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "SpringHasCome", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // 무한 반복
                audioPlayer?.play()
            } catch {
                print("Error loading audio file: \(error)")
            }
        }
    }
}
