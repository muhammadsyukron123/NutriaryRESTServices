using Microsoft.EntityFrameworkCore;
using NutriaryRESTServices.Data.Interfaces;
using NutriaryRESTServices.Data.Models;
using NutriaryRESTServices.Domain;
using NutriaryRESTServices.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data
{
    public class ConsumptionReportData : IConsumptionReport
    {
        private readonly AppDbContext _context;

        public ConsumptionReportData(AppDbContext appDbContext)
        {
            _context = appDbContext;
        }

        public async Task<CalorieSummary> GetCalorieSummaryByDate(int userId, DateTime date)
        {
            try
            {
                var calorieSummary = await _context.Database
                    .SqlQueryRaw<CalorieSummary>("EXEC usp_GetCalorieSummaryOnDate {0}, {1}", userId, date)
                    .ToListAsync();

                Console.WriteLine(calorieSummary);
                return calorieSummary.FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<CalorieSummary> GetCalorieSummaryToday(int userId)
        {
            try
            {
                var calorieSummary = await _context.Database
                    .SqlQueryRaw<CalorieSummary>("EXEC usp_GetCalorieSummary {0}", userId)
                    .ToListAsync();
                Console.WriteLine(calorieSummary);
                return calorieSummary.FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<TotalNutritionReport> GetTotalNutritionByDate(int userId, DateTime date)
        {
            var bmr = await _context.UserCalorieInformations
                .Where(uci => uci.UserId == userId)
                .Select(uci => uci.Bmr)
                .FirstOrDefaultAsync();

            var totalKaloriConsumed = await _context.DailyLogs
                .Where(d => d.UserId == userId && d.LogDate == date)
                .Join(_context.FoodNutritionInfos, d => d.FoodId, f => f.FoodId, (d, f) => new { d, f })
                .Select(x => new
                {
                    EnergyKal = x.f.EnergyKal,
                    ProteinG = x.f.ProteinG * x.d.Quantity / 100,
                    FatG = x.f.FatG * x.d.Quantity / 100,
                    CarbsG = x.f.CarbsG * x.d.Quantity / 100,
                    FiberG = x.f.FiberG * x.d.Quantity / 100,
                    CalciumMg = x.f.CalciumMg * x.d.Quantity / 100,
                    FeMg = x.f.FeMg * x.d.Quantity / 100,
                    NatriumMg = x.f.NatriumMg * x.d.Quantity / 100
                })
                .SumAsync(x => x.EnergyKal);

            var remainingBmr = bmr - totalKaloriConsumed;

            var totalNutrition = await _context.DailyLogs
                .Where(d => d.UserId == userId && d.LogDate == date)
                .Join(_context.FoodNutritionInfos, d => d.FoodId, f => f.FoodId, (d, f) => new { d, f })
                .GroupBy(x => x.d.UserId)
                .Select(g => new TotalNutritionReport
                {
                    UserId = g.Key,
                    LogDate = date,
                    TotalEnergyKal = g.Sum(x => x.f.EnergyKal),
                    TotalProteinG = g.Sum(x => x.f.ProteinG * x.d.Quantity / 100),
                    TotalFatG = g.Sum(x => x.f.FatG * x.d.Quantity / 100),
                    TotalCarbsG = g.Sum(x => x.f.CarbsG * x.d.Quantity / 100),
                    TotalFiberG = g.Sum(x => x.f.FiberG * x.d.Quantity / 100),
                    TotalCalciumMg = g.Sum(x => x.f.CalciumMg * x.d.Quantity / 100),
                    TotalFeMg = g.Sum(x => x.f.FeMg * x.d.Quantity / 100),
                    TotalNatriumMg = g.Sum(x => x.f.NatriumMg * x.d.Quantity / 100),
                    TotalBmr = (decimal)bmr,
                    RemainingBmr = (decimal)remainingBmr
                })
                .FirstOrDefaultAsync();

            return totalNutrition;
        }

        public async Task<TotalNutritionReport> GetTotalNutritionToday(int userId)
        {
            DateTime logDate = DateTime.Today;

            var bmr = await _context.UserCalorieInformations
                .Where(uci => uci.UserId == userId)
                .Select(uci => uci.Bmr)
                .FirstOrDefaultAsync();

            var totalKaloriConsumed = await _context.DailyLogs
                .Where(d => d.UserId == userId && d.LogDate == logDate)
                .Join(_context.FoodNutritionInfos, d => d.FoodId, f => f.FoodId, (d, f) => new { d, f })
                .Select(x => new
                {
                    EnergyKal = x.f.EnergyKal,
                    ProteinG = x.f.ProteinG * x.d.Quantity/100,
                    FatG = x.f.FatG * x.d.Quantity / 100,
                    CarbsG = x.f.CarbsG * x.d.Quantity / 100,
                    FiberG = x.f.FiberG * x.d.Quantity / 100,
                    CalciumMg = x.f.CalciumMg * x.d.Quantity /100,
                    FeMg = x.f.FeMg * x.d.Quantity / 100,
                    NatriumMg = x.f.NatriumMg * x.d.Quantity / 100
                })
                .SumAsync(x => x.EnergyKal);

            var remainingBmr = bmr - totalKaloriConsumed;

            var totalNutrition = await _context.DailyLogs
                .Where(d => d.UserId == userId && d.LogDate == logDate)
                .Join(_context.FoodNutritionInfos, d => d.FoodId, f => f.FoodId, (d, f) => new { d, f })
                .GroupBy(x => x.d.UserId)
                .Select(g => new TotalNutritionReport
                {
                    UserId = g.Key,
                    LogDate = logDate,
                    TotalEnergyKal = g.Sum(x => x.f.EnergyKal),
                    TotalProteinG = g.Sum(x => x.f.ProteinG * x.d.Quantity/100),
                    TotalFatG = g.Sum(x => x.f.FatG * x.d.Quantity / 100),
                    TotalCarbsG = g.Sum(x => x.f.CarbsG * x.d.Quantity / 100),
                    TotalFiberG = g.Sum(x => x.f.FiberG * x.d.Quantity / 100),
                    TotalCalciumMg = g.Sum(x => x.f.CalciumMg * x.d.Quantity / 100),
                    TotalFeMg = g.Sum(x => x.f.FeMg * x.d.Quantity / 100),
                    TotalNatriumMg = g.Sum(x => x.f.NatriumMg * x.d.Quantity / 100),
                    TotalBmr = (decimal)bmr,
                    RemainingBmr = (decimal)remainingBmr
                })
                .FirstOrDefaultAsync();

            return totalNutrition;
        }
    }
}
