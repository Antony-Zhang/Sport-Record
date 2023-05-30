//
//  testTime2.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/30.
//

import SwiftUI

import SwiftUI

struct TimerView2: View {
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let hours = Array(0...23)
    let minutesAndSeconds = Array(0...59)
    
    var body: some View {
        VStack {
            Text("倒计时")
                .font(.largeTitle)
            
            HStack {
                Picker(selection: $selectedHours, label: Text("小时")) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour) 小时").tag(hour)
                    }
                }
                .frame(maxWidth: 100)
                
                Picker(selection: $selectedMinutes, label: Text("分钟")) {
                    ForEach(minutesAndSeconds, id: \.self) { minute in
                        Text("\(minute) 分钟").tag(minute)
                    }
                }
                .frame(maxWidth: 100)
                
                Picker(selection: $selectedSeconds, label: Text("秒")) {
                    ForEach(minutesAndSeconds, id: \.self) { second in
                        Text("\(second) 秒").tag(second)
                    }
                }
                .frame(maxWidth: 100)
            }
            .labelsHidden()
            
            Button(action: startTimer) {
                Text("开始")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("\(timeString(time: timeRemaining))")
                .font(.largeTitle)
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
        }
        .padding()
    }
    
    func startTimer() {
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        timeRemaining = TimeInterval(totalSeconds)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}


struct testTime2_Previews: PreviewProvider {
    static var previews: some View {
        TimerView2()
    }
}
