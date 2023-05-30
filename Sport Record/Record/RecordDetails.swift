//
//  RecordDetails.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct RecordDetails: View {
    @State var sportData: SportData? = SportData()
    var body: some View {
        List{
            Section{
                Text("单次运动的影像记录")
                Image(uiImage: (sportData?.checkImage)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Section{
                Text("主要数据")
                HStack{
                    Label("用时",systemImage: "clock").font(.title2).foregroundColor(.red)
                    Spacer()
                    Text(TimeManager.timeString(time: (sportData?.consumTime)!)).font(.title2)
                }
                HStack{
                    Label("平均心率",systemImage: "heart").font(.title2).foregroundColor(.red)
                    Spacer()
                    Text("121-145").font(.title2)
                }
                HStack{
                    Label("消耗能量(卡)",systemImage: "bolt").font(.title2).foregroundColor(.red)
                    Spacer()
                    Text("455").font(.title2)
                }
            }
            HStack{
                NavigationLink(destination: RecordAnalysis(sportData: sportData)){
                    Text("详情分析").font(.title)
                        .bold()
                        .foregroundColor(.blue)
                }
            }
        }.navigationTitle("记录")
    }
}

struct RecordDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetails()
    }
}
