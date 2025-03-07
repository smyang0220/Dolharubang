//
//  TrophyEnviroment.swift
//  DolHaruBang
//
//  Created by 양희태 on 9/23/24.
//

import UIKit
import Foundation
import ComposableArchitecture
import Alamofire

struct Trophy: Decodable, Equatable, Sendable {
    var isclear : Bool
    var title : String
    var subtitle : String
    var rewardImage : Data
    var rewardName : String
}

@DependencyClient
struct TrophyClient {
    var fetchTrophy: @Sendable () async throws -> [Trophy]
}

// 실제 통신 전 테스트
extension TrophyClient: TestDependencyKey {
    // 여기서의 Self는 TmpClient
    static let previewValue = Self(
        fetchTrophy: {
            return Trophy.mockTrophies
        }
    )

    static let testValue = Self()
}

extension DependencyValues {
    var trophyClient: TrophyClient {
        get { self[TrophyClient.self] }
        set { self[TrophyClient.self] = newValue }
    }
}

extension TrophyClient: DependencyKey {
    static let liveValue = TrophyClient(
        fetchTrophy: {
            let url = "http://211.49.26.51:8080/api/v1/pepperoni"
            
//            return try await fetch(url: url, model: [Trophy].self, method: .get)
            
            return Trophy.mockTrophies
            }
    )
}


private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  let formatter = DateFormatter()
  decoder.dateDecodingStrategy = .formatted(formatter)
  return decoder
}()


extension Trophy {
    static let mockTrophy1 = Self(
        isclear: true,
        title: "첫 번째 트로피",
        subtitle: "이것은 첫 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "50 모래알"
    )

    static let mockTrophy2 = Self(
        isclear: false,
        title: "두 번째 트로피",
        subtitle: "이것은 두 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "실버 트로피"
    )

    static let mockTrophy3 = Self(
        isclear: true,
        title: "세 번째 트로피",
        subtitle: "이것은 세 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "브론즈 트로피"
    )

    static let mockTrophy4 = Self(
        isclear: false,
        title: "네 번째 트로피",
        subtitle: "이것은 네 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "플래티넘 트로피"
    )

    static let mockTrophy5 = Self(
        isclear: true,
        title: "다섯 번째 트로피",
        subtitle: "이것은 다섯 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "다이아몬드 트로피"
    )

    static let mockTrophy6 = Self(
        isclear: false,
        title: "여섯 번째 트로피",
        subtitle: "이것은 여섯 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "레드 트로피"
    )

    static let mockTrophy7 = Self(
        isclear: true,
        title: "일곱 번째 트로피",
        subtitle: "이것은 일곱 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "블루 트로피"
    )

    static let mockTrophy8 = Self(
        isclear: false,
        title: "여덟 번째 트로피",
        subtitle: "이것은 여덟 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "그린 트로피"
    )

    static let mockTrophy9 = Self(
        isclear: true,
        title: "아홉 번째 트로피",
        subtitle: "이것은 아홉 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "옐로우 트로피"
    )

    static let mockTrophy10 = Self(
        isclear: false,
        title: "열 번째 트로피",
        subtitle: "이것은 열 번째 트로피입니다.",
        rewardImage: loadImageData(named: "BackIcon") ?? Data(),
        rewardName: "퍼플 트로피"
    )

    static let mockTrophies: [Trophy] = [
        mockTrophy1,
        mockTrophy2,
        mockTrophy3,
        mockTrophy4,
        mockTrophy5,
        mockTrophy6,
        mockTrophy7,
        mockTrophy8,
        mockTrophy9,
        mockTrophy10
    ]
}



func loadImageData(named imageName: String) -> Data? {
    guard let image = UIImage(named: imageName) else {
        return nil
    }
    return image.pngData() // 또는 image.jpegData(compressionQuality: 1.0) 사용 가능
}
