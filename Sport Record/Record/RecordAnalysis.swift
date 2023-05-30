//
//  RecordAnalysis.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct RecordAnalysis: View {
    @State var sportData: SportData? = SportData()
    var body: some View {
        List{
            Section{
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
            Section{
                HStack{
                    Label("平均频率(每秒)",systemImage: "figure.jumprope").font(.title2).foregroundColor(.blue)
                    Spacer()
                    Text("1.7").font(.title2)
                }
                HStack{
                    Label("平均高度(m)",systemImage: "arrow.up").font(.title2).foregroundColor(.blue)
                    Spacer()
                    Text("1.9").font(.title2)
                }
            }
        }.navigationTitle("详情分析")
    }
}

struct RecordAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        RecordAnalysis()
    }
}
