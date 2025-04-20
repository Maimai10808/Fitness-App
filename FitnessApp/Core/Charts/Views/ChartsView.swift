import SwiftUI
import Charts


struct ChartsView: View {
    @StateObject var viewModel = ChartsViewModel()
    @State var selectedChart: ChartOptions = .oneWeek
    
    var body: some View {
        VStack {
            Text("Charts")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ZStack {
                            switch selectedChart {
                            case .oneWeek:
                                VStack {
                                    ChartDataView(average: viewModel.oneWeekAverage,
                                                  total: viewModel.oneWeekTotal)

                                    Chart {
                                        ForEach(viewModel.chartData) { data in       // ← 关键修改
                                            BarMark(
                                                x: .value("Day",   data.date, unit: .day),
                                                y: .value("Steps", data.count)
                                            )
                                        }
                                    }
                                }

                            case .oneMonth:
                                VStack {
                                    ChartDataView(average: viewModel.oneMonthAverage,
                                                  total: viewModel.oneMonthTotal)

                                    Chart {
                                        ForEach(viewModel.mockOneMonthData) { data in
                                            BarMark(
                                                x: .value("Day",   data.date, unit: .day),
                                                y: .value("Steps", data.count)
                                            )
                                        }
                                    }
                                }

                            case .threeMonth:
                                VStack {
                                    ChartDataView(average: viewModel.threeMonthAverage,
                                                  total: viewModel.threeMonthTotal)

                                    Chart {
                                        ForEach(viewModel.mockThreeMonthData) { data in
                                            LineMark(
                                                x: .value("Day",   data.date, unit: .day),
                                                y: .value("Steps", data.count)
                                            )
                                        }
                                    }
                                }

                            case .yearToDate:
                                VStack {
                                    ChartDataView(average: viewModel.ytdAverage,
                                                  total: viewModel.ytdTotal)

                                    Chart {
                                        ForEach(viewModel.ytdChartData) { data in
                                            BarMark(
                                                x: .value("Month", data.date, unit: .month),
                                                y: .value("Steps", data.count)
                                            )
                                        }
                                    }
                                }

                            case .oneYear:
                                VStack {
                                    ChartDataView(average: viewModel.oneYearAverage,
                                                  total: viewModel.oneYearTotal)

                                    Chart {
                                        ForEach(viewModel.oneYearChartData) { data in
                                            BarMark(
                                                x: .value("Month", data.date, unit: .month),
                                                y: .value("Steps", data.count)
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .foregroundStyle(.green)
                        .frame(maxWidth: 450)
                        .padding(.horizontal)
            
            HStack {
                ForEach(ChartOptions.allCases, id: \.rawValue) {
                    option in
                    Button(option.rawValue) {
                        withAnimation(.spring) {
                            selectedChart = option
                        }
                    }
                    .padding()
                    .foregroundColor(selectedChart == option ? .white : .green)
                    .background(selectedChart == option ? .green : .clear)
                    .cornerRadius(10)
                }
            }
        }
        .alert("Oops",
               isPresented: $viewModel.presentError) {
            // ✅ 用 Button 才能点
            Button("OK", role: .cancel) {
                viewModel.presentError = false   // 也可以留空，系统自动关
            }
        } message: {
            Text("we ran into issues fetching some of your step data please make sure you have allowed access and try again.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChartsView()
} 
