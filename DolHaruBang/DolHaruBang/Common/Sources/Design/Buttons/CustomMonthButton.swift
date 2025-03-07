//
//  CustomMonthButton.swift
//  DolHaruBang
//
//  Created by 안상준 on 7/30/24.
//

import SwiftUI
import UIKit

struct CustomMonthButton: UIViewRepresentable {
    class Coordinator: NSObject {
        var parent: CustomMonthButton

        init(parent: CustomMonthButton) {
            self.parent = parent
        }

        @objc func buttonTapped() {
            parent.isPresented = true
        }
    }

    @Binding var selectedMonth: Int?
    @Binding var isPresented: Bool
    var font: Font
    var textColor: UIColor?
    var action: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(selectedMonth != nil ? "\(selectedMonth!)" : "월", for: .normal)
        button.titleLabel?.font = Font.uiFont(for: Font.button1) ?? UIFont.systemFont(ofSize: 16)
        button.setTitleColor(textColor ?? UIColor(Color.black), for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle(selectedMonth != nil ? "\(selectedMonth!)" : "월", for: .normal)
        uiView.titleLabel?.font = Font.uiFont(for: Font.button1) ?? UIFont.systemFont(ofSize: 16)
        uiView.setTitleColor(textColor ?? UIColor(Color.black), for: .normal)
    }
}

struct MonthPicker: View {
    @Binding var selectedMonth: Int
    @Binding var isPresented: Bool
    var months: [Int]
    var onSelect: () -> Void

    var body: some View {
        VStack {
            Text("태어난 월을 골라주세요!")
                .font(.customFont(Font.h6))
                .padding()
            
            Picker("Select Month", selection: $selectedMonth) {
                ForEach(months, id: \.self) { month in
                    Text("\(month)").tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())

            Button("선택") {
                onSelect()
                isPresented = false
            }
            .font(.customFont(Font.h7))
            .tint(.coreGreen)
            .padding()
        }
    }
}


