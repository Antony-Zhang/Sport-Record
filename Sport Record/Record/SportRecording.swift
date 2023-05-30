//
//  SportRecording.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct SportRecording: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentationMode   // 用于退出返回
    
    @State private var showImagePicker = false  //  进行图片选择(相册or拍照)
    @State private var showActionSheet = false  //  进行图片来源选择
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary   //  来源类型(默认相册)
    @State var checkImage: UIImage = UIImage()
    
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var totaltime: TimeInterval = 0
    @State private var timeRemaining: TimeInterval = 0  //  剩余时间
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()    //  定时器,每秒更新一次
    let hours = Array(0...23)
    let minutesAndSeconds = Array(0...59)
    
    @State private var isTiming = false     //  计时状态
    @State private var isStarted = false    //  运动状态
    @State private var isOver = false       //  计时结束
    @State private var showExit = false    //  中途退出
    
    var body: some View {
        Form{
            //  照片部分
            Section{
                Text("运动记录照片").font(.title3)
                Image(uiImage: checkImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .onTapGesture {
                        showActionSheet = true
                    }
            }
            .actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("选择图片"),message: nil,buttons: [
                    .default(Text("相册")){
                        sourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .default(Text("拍照")){
                        sourceType = .camera
                        showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker,
                   content: {
                ImagePicker(sourceType: sourceType) { image in
                    checkImage = image
                }
            })
            //  剩余时间部分
            Section{
                HStack{
                    Text("剩余时间").font(.title3)
                    Spacer()
                    Text("\(timeString(time: timeRemaining))")  //  显示剩余时间
                        .font(.largeTitle)
                        .onReceive(timer) { _ in    //  定时器更新时,更新剩余时间
                            //  首先判断计时状态
                            guard isTiming else{ return }
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }else{
                                isOver = true
                            }
                        }
                }
            }
            //  定时部分
            VStack{
                Text("定时").font(.title3)
                HStack{
                    //  小时选择器
                    Picker(selection: $selectedHours, label: Text("时")) {
                        ForEach(hours, id: \.self) { hour in
                            Text("\(hour) ").tag(hour)
                        }
                    }
                    .frame(width: 90,height: 100)
                    Text(":").font(.title)
                    //  分钟选择器
                    Picker(selection: $selectedMinutes, label: Text("分")) {
                        ForEach(minutesAndSeconds, id: \.self) { minute in
                            Text("\(minute) ").tag(minute)
                        }
                    }
                    .frame(width: 90,height: 100)
                    //  秒选择器
                    Text(":").font(.title)
                    Picker(selection: $selectedSeconds, label: Text("秒")) {
                        ForEach(minutesAndSeconds, id: \.self) { second in
                            Text("\(second) ").tag(second)
                        }
                    }
                    .frame(width: 90,height: 100)
                }.pickerStyle(.wheel)
            }
            //  中途退出
            .actionSheet(isPresented: $showExit){
                ActionSheet(title: Text("结束运动"),
                            message: Text("运动记录将直接保存\n统计数据可能不准确"),
                            buttons: [
                                .default(Text("确认")){
                                isTiming = false
                                isStarted = false
                                presentationMode.wrappedValue.dismiss()
                                },
                                .cancel(Text("取消"))
                            ])
            }
            //  开关部分
            Section{
                if(!isStarted){         //  未开始运动
                    Label("开始", systemImage: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            startTimer()
                            isStarted.toggle()
                            isTiming.toggle()
                        }
                }else if(!isTiming){    //  暂停计时
                    HStack{
                        Label("继续", systemImage: "pause.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .onTapGesture {
                                isTiming.toggle()
                            }
                        Spacer()
                        Label("结束", systemImage: "stop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .onTapGesture {
                                //  退出界面
                                showExit.toggle()
                            }
                    }
                }else{                  //  正在计时
                    HStack{
                        Label("暂停", systemImage: "pause.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isTiming.toggle()
                            }
                        Spacer()
                        Label("结束", systemImage: "stop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .onTapGesture {
                                //  退出界面
                                showExit.toggle()
                            }
                    }
                }
            }.alert(isPresented: $isOver){
                    //  计时结束弹窗
                    Alert(
                        title: Text("计时结束"),
                        message: Text("🎉\n恭喜你!完成运动!\n详细记录可见于\n“个人信息->个人数据”"),
                        primaryButton: .default(Text("确认"), action: {
                            isTiming = false
                            isStarted = false
                            presentationMode.wrappedValue.dismiss()
                        }),
                        secondaryButton: .cancel(Text("别点我"))
                    )
                }
        }.navigationBarBackButtonHidden(true)
    }
    
    //  根据选择的时间计算总秒数,并初始化剩余时间
    func startTimer(){
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        totaltime = TimeInterval(totalSeconds)
        timeRemaining = totaltime
    }
    //  将剩余时间转化为String,用于显示
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

struct SportRecording_Previews: PreviewProvider {
    static var previews: some View {
        SportRecording().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
