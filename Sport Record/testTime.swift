////
////  testTime.swift
////  Sport Record
////
////  Created by EastOS on 2023/5/30.
////
//
//import SwiftUI
//
//struct TimerView: View {
//    // 用于存储用户选择的时间
//    @State private var selectedTime = DateComponents()
//    // 用于存储定时器实例
//    @State private var timer: Timer?
//    // 用于存储剩余时间
//    @State private var timeRemaining: TimeInterval = 0
//
//    // 用于格式化剩余时间
//    let timeFormatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .positional
//        formatter.zeroFormattingBehavior = .pad
//        return formatter
//    }()
//
//    var body: some View {
//        VStack {
//            // 显示剩余时间
//            Text(timeFormatter.string(from: timeRemaining) ?? "")
//                .font(.largeTitle)
//                .padding()
//
//            // 水平排列三个滚筒样式的选择器
//            HStack {
//                // 小时选择器
//                Picker(selection: $selectedTime.hour, label: Text("Hours")) {
//                    ForEach(0..<24) { hour in
//                        Text("\(hour) h").tag(hour)
//                    }
//                }
//                .pickerStyle(.wheel)
//
//                // 分钟选择器
//                Picker(selection: $selectedTime.minute, label: Text("Minutes")) {
//                    ForEach(0..<60) { minute in
//                        Text("\(minute) m").tag(minute)
//                    }
//                }
//                .pickerStyle(.wheel)
//
//                // 秒选择器
//                Picker(selection: $selectedTime.second, label: Text("Seconds")) {
//                    ForEach(0..<60) { second in
//                        Text("\(second) s").tag(second)
//                    }
//                }
//                .pickerStyle(.wheel)
//            }
//            
//            // 开始计时器按钮
//            Button(action: startTimer) {
//                Text("Start Timer")
//            }
//        }
//        // 当接收到定时器事件时更新剩余时间
//        .onReceive(timer ?? Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
//            guard timeRemaining > 0 else {
//                timer?.invalidate()
//                timer = nil
//                return
//            }
//
//            timeRemaining -= 1
//        }
//    }
//
//    // 开始计时器函数
//    func startTimer() {
//        // 计算选定时间与当前时间的时间间隔
//        guard let timeInterval = Calendar.current.date(from: selectedTime)?.timeIntervalSinceNow else { return }
//
//        // 存储剩余时间并创建定时器实例
//        timeRemaining = timeInterval
//        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//}
//
//
//
//struct testTime_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView()
//    }
//}
