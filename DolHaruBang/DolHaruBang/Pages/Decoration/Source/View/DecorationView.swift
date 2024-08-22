//
//  DecorationView.swift
//  DolHaruBang
//
//  Created by 양희태 on 8/20/24.
//
import SwiftUI
import ComposableArchitecture

struct DecorationView: View {
    enum Tab {
        case background, shape, face
    }
    
    @State private var selected: Tab = .background
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                HStack(spacing: 8) {
                    TabButton(
                        title: "배경",
                        isSelected: selected == .background,
                        action: { selected = .background }
                    )
                    
                    TabButton(
                        title: "얼굴형",
                        isSelected: selected == .shape,
                        action: { selected = .shape }
                    )
                    
                    TabButton(
                        title: "얼굴",
                        isSelected: selected == .face,
                        action: { selected = .face }
                    )
                    
                    Spacer()
                }
                .padding(10)
                .padding(.top, 65)
                .background(Color.white) // 버튼 영역의 배경색
                
                TabView(selection: $selected) {
                    Group {
                        NavigationStack {
                            CustomizeView<Background>(store: store)
                        }
                        .tag(Tab.background)
                        
                        NavigationStack {
                            CustomizeView<FaceShape>(store: store)
                        }
                        .tag(Tab.shape)
                        
                        NavigationStack {
                            CustomizeView<Face>(store: store)
                        }
                        .tag(Tab.face)
                    }
                }
                .background(Color.white) // TabView의 배경색
                .frame(width: geometry.size.width, height: geometry.size.height) // TabView의 크기를 GeometryReader를 사용하여 조정
            }
            .frame(width: geometry.size.width, height: geometry.size.height)// 전체 레이아웃 크기 설정
            .background(Color.white)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center) {
                Text(title)
                    .font(Font.customFont(Font.body2Regular))
                    .foregroundColor(isSelected ? Color.white : Color.decoSheetTabbar)
            }
            .padding(10) // 텍스트와 테두리 사이의 간격
            .background(
                RoundedRectangle(cornerRadius: 15) // 모서리 둥글기 설정
                    .fill(isSelected ? Color.decoSheetTabbarBack : Color.clear) // 배경색 설정
            )
        }
    }
}
