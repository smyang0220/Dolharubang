
//
//  HomeView.swift
//  DolHaruBang
//
//  Created by 양희태 on 7/31/24.
//

import SwiftUI
import UIKit
import ComposableArchitecture


struct HomeView : View {
    @State var store: StoreOf<HomeFeature>
    
    var body : some View {
            GeometryReader { geometry in
                ZStack {
                    // 배경이미지 설정
                    // 추후 통신을 통해 받아오면 됨
                    
                    Image(Background(rawValue: store.selectedBackground.rawValue)!.fileName)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    // 메인 컴포넌트들
                    VStack {
                        // 상단 부분
                        HStack{
                            
                            HStack{
                                Button(action: {
                                    // 추후 추가
                                }) {
                                    HStack {
                                        Image("Sand")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                        Text("20")
                                            .font(Font.customFont(Font.caption1))
                                            .foregroundColor(.white)
                                    }
                                    .background(Color.clear)
                                    .frame(width: geometry.size.width * 0.15, height: 30)
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.white, lineWidth: 1) // 테두리 색상과 두께 설정
                                    )
                                }
                                .padding(.bottom , 15)
                                Spacer()
                            }.frame(width: geometry.size.width * 0.25)
                            
                            
                            Text("돌돌이 방")
                                .padding(.bottom , 15)
                                .font(Font.customFont(Font.h6))
                                .shadow(radius: 4,x:0,y: 1)
                                .frame(width: geometry.size.width * 0.4, alignment: .center)
                            
                            // 공유, 꾸미기
                            HStack(spacing: 10){
                                Button(action: {
                                    store.send(.openShare)
                                }) {
                                    VStack {
                                        Image("Share")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    .padding(.bottom , 15)
                                    .background(Color.clear)
                                    
                                }
                                
                                Button(action: {
                                    if store.enable {
                                        store.send(.openDecoration)
                                    }
                                }) {
                                    VStack {
                                        Image("Brush")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24) // 이미지 크기 조정
                                        Text("꾸미기")
                                            .font(Font.customFont(Font.caption1))
                                            .foregroundStyle(Color.white)
                                    }
                                    .padding(10)
                                    .background(Color.clear) // 배경색을 투명으로 설정
                                    .clipShape(Circle()) // 원형으로 자르기
                                    .overlay(
                                        Circle() // 원형 테두리
                                            .stroke(Color.white, lineWidth: 1) // 테두리 색상과 두께 설정
                                    )
                                    .shadow(color: .gray, radius: 1, x: 1, y: 1) // 그림자 추가
                                }
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            }
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                         
                            
                        
                        }
                        .frame(height : geometry.size.height * 0.1)
                        .padding(.top , geometry.size.height * 0.07)
                        
                        
                        Spacer().background(Color.red)
                        
                        // MARK: 3D 돌 뷰
                        let dolView = DolView(
                                        selectedFace: $store.selectedFace,
                                        selectedFaceShape: $store.selectedFaceShape,
                                        selectedAccessory: $store.selectedAccessory,
                                        selectedSign: $store.selectedSign,
                                        selectedMail: $store.selectedMail,
                                        selectedNest: $store.selectedNest,
                                        signText: $store.message,
                                        sign: $store.sign,
                                        profile: $store.profile,
                                        mail: $store.mail,
                                        enable: $store.enable,
                                        onImagePicked: { image in
                                            store.send(.captureDol(image))
                                        },
                                        hasRendered: $store.needCapture
                                    )
                        dolView
                        
                        Spacer().background(Color.red)
                        VStack{
                            
                            if store.ability{
                                HStack{
                                    Button(action: {
                                            dolView.rollDol()
                                       })
                                    {
                                        // 구르기추가
                                        VStack{
                                            Text("구르기")
                                                .font(Font.customFont(Font.caption1))
                                                .foregroundColor(store.ability ? .black: .white)
                                                .padding()// Text
                                        }
                                        .frame(height: geometry.size.width * 0.1)
                                        .background(Color.ability1).cornerRadius(20)
                                    }
                                }
                                .frame(height: geometry.size.width * 0.15)
                                .transition(.opacity) // 애니메이션 전환 효과
                                .animation(.easeInOut, value: store.ability)
                            }else{
                                Spacer().frame(height: geometry.size.width * 0.15)
                            }
                            
                            
                            HStack(spacing : 5){
                                
                                Button(action: {
                                    store.send(.clickAbility)
                                }) {
                                    VStack(spacing : 0) {
                                        Image(store.ability ? "Star2" : "Star")
                                                    .resizable()
                                                    .scaledToFit()
                                        
                                        
                                        Text("능력")
                                            .font(Font.customFont(Font.caption1))
                                            .foregroundColor(store.ability ? Color.ability1: Color.ability2)
                                            .padding(.bottom,2)
                                    }
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                                    .background(store.ability ? Color.ability2 : Color.ability1)
                                    .clipShape(Circle())
                                    .shadow(color: Color(hex:"CECECE") , radius: 5, x:0, y:1)
                                    .overlay(
                                      Ellipse()
                                        .inset(by: 0.25)
                                        .stroke(.white, lineWidth: 0.25)
                                    )
                                   
                                    
                                }
                                
                                CustomTextField(
                                    text: $store.message,
                                    placeholder: "돌에게 말을 걸어보세요",
                                    placeholderColor: Color(hex:"C8BEB2").toUIColor(),
                                    backgroundColor: .coreWhite,
                                    maxLength: 40,
                                    useDidEndEditing: false,
                                    customFontStyle: Font.body3Bold,
                                    alignment: Align.leading,
                                    leftPadding : 5,
                                    rightPadding : 5
                                )
                                .frame(width: geometry.size.width * 0.65, height: geometry.size.width * 0.1)
                                .cornerRadius(25)
                                .shadow(color: Color(hex:"B4B8BF"), radius: 5, x:0, y:1)

                                
                                Button(action: {
                                    store.send(.clickMessage)
                                    hideKeyboard()
                                    
                                }){
                                    Image("Send")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                }
                                
                            }
                            .padding(.bottom , geometry.size.height * 0.02)
                        }
                        // 키보드 focus시 오프셋 변경
                        .offset(y: store.isKeyboardVisible ? -geometry.size.height * 0.22 : 0)
                        .animation(.easeInOut, value: store.isKeyboardVisible)
                        
                        Spacer().frame(height: geometry.size.height * 0.12)
                        
                    }
                    
                    
                    // MARK: 공유버튼
                    if store.shareButton {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                store.send(.closeShare)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zIndex(1)
                        ShareView(
                            showPopup: $store.shareButton, DolImage: $store.captureDol
                        )
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(2)
                    }
                    
                    // MARK: 펫말
                    if store.sign {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                store.send(.closeSign)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zIndex(1)
                        SignView(
                            showPopup: $store.sign,
                            message: $store.message, store: Store(initialState: SignFeature.State()){
                                SignFeature()}
                        )
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(2)
                    }
                    
                    // MARK: 프로필
                    if store.profile {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                store.send(.closeProfile)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zIndex(1)
                        ProfileView(
                            showPopup: $store.profile, store: Store(initialState: ProfileFeature.State()){
                                ProfileFeature()
                            }
                        )
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(2)
                    }
                    
                    // MARK: 우체통
                    if store.mail {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                store.send(.closeMail)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zIndex(1)
                        MailView(
                            showPopup: $store.mail, store: Store(initialState: MailFeature.State()){
                                MailFeature()
                            }
                        )
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(2)
                    }
                    
                } // ZStack
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨기기
                .frame(height: geometry.size.height)
                .keyboardResponder(isKeyboardVisible: $store.isKeyboardVisible)
                .onAppear (
                    perform : UIApplication.shared.hideKeyboard
                )
                .onAppear{
                    store.send(.fetchBackground)
                    store.send(.fetchFace)
                    store.send(.fetchFaceShape)
                    store.send(.fetchAccessory)
                    store.send(.fetchNest)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .sheet(isPresented: $store.decoration) {
                    // 이 뷰가 모달로 표시됩니다.
                    DecorationView(store: store)
                        .presentationDetents([.fraction(0.45)])
                        .presentationCompactAdaptation(.none)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }// sheet
            } // geometry
    } // some
    
    
} // View

struct CommonTextFieldStyle: TextFieldStyle {
    var placeholderColor: Color
    var textColor: Color
    var backgroundColor: Color
    var borderColor: Color
    var cornerRadius: CGFloat
    var shadowColor: Color
    var shadowRadius: CGFloat

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .leading) {
            // Background Rectangle
            Rectangle()
                .foregroundColor(backgroundColor)
                .cornerRadius(cornerRadius)
                .frame(height: 46)
                .shadow(color: shadowColor.opacity(0.5), radius: shadowRadius, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
            
          
            // TextField.
            configuration
                .font(.body)
                .foregroundColor(textColor)
                .padding(.leading, 8) // Add padding to align text within the text field
        }
        .padding(.horizontal, 8) // Add horizontal padding for the whole ZStack
    }
}

