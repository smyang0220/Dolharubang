//
//  Face.swift
//  DolHaruBang
//
//  Created by 양희태 on 8/20/24.
//

import ComposableArchitecture

protocol Customizable : Hashable, CaseIterable where AllCases == Array<Self>{
    var description: String { get }
    
    func performAction(with store: StoreOf<HomeFeature>)
}


// 표정
enum Face : String, Customizable {
    func performAction(with store: ComposableArchitecture.StoreOf<HomeFeature>) {
        store.send(.selectFace(self))
    }
    
    case sparkle = "반짝이"
    case sosim = "소심이"
    case saechim = "새침이"
    case nareun = "나른이"
    case meong = "멍이"
    case cupid = "큐피드"
    case bboombboom = "뿜뿜이"
    case balral = "발랄이"
    case chic = "시크"
    
    var description: String {
        return self.rawValue
    }
}
