//
//  RecordCharts.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct RecordCharts: View {
    @StateObject var userSettings = UserSettings.shared      //  设置信息
    @StateObject var dataBase = SQLiteDatabase.shared   //  用户数据
    @State var sportDataList: [SportData] = []
    @State var groupedData: [Int: [SportData]] = [:]
    let calendar = Calendar.current //  创建日历,用于获取日期的某个部分
    @State var thisdate: String! = ""
    @State var sumTime: String! = ""
    @State var num: String! = ""
    
    var body: some View {
        List{
            //  .keys.sorted()返回所有的键,且排序
            ForEach(groupedData.keys.sorted(), id: \.self){ month in
                if let firstDate = groupedData[month]?.first?.date{
                    Section(header: Text(thisdate + "   " + num + "次")){
                        ForEach(groupedData[month]!, id: \.date){ data in
                            NavigationLink(destination: RecordDetails(sportData: data)){
                                Text("用时")
                                Text(TimeManager.timeString(time: data.consumTime))
                            }
                        }
                    }.onAppear{
                        thisdate = TimeManager.mmdateString(date: firstDate)
                        num = String(describing: groupedData[month]!.count)
//                        sumTime = String(describing: sumTime(sportDataList: groupedData[month]!))
                    }
                }
            }
            
        }.navigationTitle("运动数据")
            .onAppear{
                //  获取运动数据
                if(sportDataList.count <= 0){
                    sportDataList = dataBase.getSportData(id: userSettings.id)
                    for _ in 1...5{
                        let idate = Date()
                        let iconsumtimeIn: TimeInterval = Double.random(in: 1...600)
                        let iconsumtime = TimeManager.stringTime(timeString:  TimeManager.timeIntervalString(time: iconsumtimeIn))
                        
                        
                        sportDataList.append(SportData(id: userSettings.id, date: idate, consumTime: iconsumtime))
                    }
                }
                //  按照月份分组
                for data in sportDataList{
                    let month = calendar.component(.month, from: data.date)   //  获取月份
                    //  若空,则初始化该月份的数据集合
                    if groupedData[month] == nil{
                        groupedData[month] = []
                    }
                    //  末尾添加数据(由于原始集是顺序的,分组后组内仍是顺序)
                    groupedData[month]?.append(data)
                }
                
                //  组内按照时间先后排序
                for (month, _) in  groupedData{
                    groupedData[month]!.sort(by: {$0.date < $1.date})
                }
            }
    }
    func sumTime(sportDataList: [SportData]) -> String{
        var sum: Date = TimeManager.stringTime(timeString: "00:00:00")
        for data in sportDataList{
            let timeadd = data.consumTime.timeIntervalSince1970
            sum = sum + timeadd
        }
        return TimeManager.timeString(time: sum)
    }
}
struct RecordCharts_Previews: PreviewProvider {
    static var previews: some View {
        RecordCharts().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
