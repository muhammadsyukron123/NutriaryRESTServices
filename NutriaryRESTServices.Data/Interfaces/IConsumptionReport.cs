using NutriaryRESTServices.Data.Models;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Interfaces
{
    public interface IConsumptionReport
    {
        public Task<TotalNutritionReport> GetTotalNutritionToday(int userId);
        public Task<TotalNutritionReport> GetTotalNutritionByDate(int userId, DateTime date);
        public Task<CalorieSummary> GetCalorieSummaryToday(int userId);
        public Task<CalorieSummary> GetCalorieSummaryByDate(int userId, DateTime date);
    }
}
