using AutoMapper;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Data.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL
{
    public class ConsumptionReportBLL : IConsumptionReportBLL
    {
        private readonly IConsumptionReport _consumptionReportDAL;
        private readonly IMapper _mapper;

        public ConsumptionReportBLL(IConsumptionReport consumptionReportDAL, IMapper mapper)
        {
            _consumptionReportDAL = consumptionReportDAL;
            _mapper = mapper;
        }

        public async Task<TotalNutritionReportDTO> GetTotalNutritionByDate(int userId, DateTime date)
        {
            var report = await _consumptionReportDAL.GetTotalNutritionByDate(userId, date);
            return _mapper.Map<TotalNutritionReportDTO>(report);
        }

        public async Task<TotalNutritionReportDTO> GetTotalNutritionToday(int userId)
        {
            var report = await _consumptionReportDAL.GetTotalNutritionToday(userId);
            return _mapper.Map<TotalNutritionReportDTO>(report);
        }
    }
}
