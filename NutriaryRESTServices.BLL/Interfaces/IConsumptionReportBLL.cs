using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Interfaces
{
    public interface IConsumptionReportBLL
    {
        public Task<TotalNutritionReportDTO> GetTotalNutritionToday(int userId);
        public Task<TotalNutritionReportDTO> GetTotalNutritionByDate(int userId, DateTime date);
        public Task<CalorieSummaryDTO> GetCalorieSummaryToday(int userId);
        public Task<CalorieSummaryDTO> GetCalorieSummaryByDate(int userId, DateTime date);
    }
}
