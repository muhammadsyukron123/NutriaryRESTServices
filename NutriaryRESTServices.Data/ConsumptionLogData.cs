using Microsoft.EntityFrameworkCore;
using NutriaryRESTServices.Data.Interfaces;
using NutriaryRESTServices.Domain;
using NutriaryRESTServices.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data
{

    public class ConsumptionLogData : IConsumptionLog
    {
        private readonly AppDbContext _context;

        public ConsumptionLogData(AppDbContext appDbContext)
        {
            _context = appDbContext;
        }

        public async Task<bool> DeleteConsumptionLog(int logId)
        {
            try
            {
                var dailyLog = await _context.DailyLogs.FirstOrDefaultAsync(d => d.LogId == logId);
                if (dailyLog == null)
                {
                    throw new ArgumentException("Consumption Log not found");
                }
                _context.DailyLogs.Remove(dailyLog);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Consumption Log not found", ex.Message);
            }
        }

        public async Task<IEnumerable<DailyLogDetails>> GetAllConsumptionLogsById(int userId, DateTime logDate)
        {
            try
            {
                var dailyLogs = await _context.DailyLogs
                    .Where(d => d.UserId == userId && d.LogDate == logDate)
                    .Select(d => new DailyLogDetails 
                    {
                        UserId = d.UserId,
                        FoodId = d.FoodId,
                        LogId = d.LogId,
                        Quantity = d.Quantity,
                        LogDate = d.LogDate,
                        FoodName = d.Food.FoodName, 
                        EnergyKal = d.Food.EnergyKal,
                        ProteinG = d.Food.ProteinG,
                        FatG = d.Food.FatG,
                        CarbsG = d.Food.CarbsG,
                        FiberG = d.Food.FiberG,
                        CalciumMg = d.Food.CalciumMg,
                        FeMg = d.Food.FeMg,
                        NatriumMg = d.Food.NatriumMg
                    })
                    .ToListAsync();
                return dailyLogs;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Consumption Log not found", ex.Message);
            }
        }

        public async Task<DailyLogDetails> GetConsumptionDetailById(int logId)
        {
            try
            {
                var dailyLog = await _context.DailyLogs
                    .Where(d => d.LogId == logId)
                    .Select(d => new DailyLogDetails
                    {
                        UserId = d.UserId,
                        FoodId = d.FoodId,
                        LogId = d.LogId,
                        Quantity = d.Quantity,
                        LogDate = d.LogDate,
                        FoodName = d.Food.FoodName,
                        EnergyKal = d.Food.EnergyKal,
                        ProteinG = d.Food.ProteinG,
                        FatG = d.Food.FatG,
                        CarbsG = d.Food.CarbsG,
                        FiberG = d.Food.FiberG,
                        CalciumMg = d.Food.CalciumMg,
                        FeMg = d.Food.FeMg,
                        NatriumMg = d.Food.NatriumMg
                    })
                    .FirstOrDefaultAsync();
                return dailyLog;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Consumption Log not found", ex.Message);
            }
        }

        public async Task<DailyLog> InsertConsumptionLog(DailyLog daily)
        {
            try
            {
                _context.DailyLogs.Add(daily);
                await _context.SaveChangesAsync();
                return daily;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Consumption Log not found", ex.Message);
            }
        }

        public async Task<DailyLog> UpdateConsumptionQuantity(int LogId, decimal quantity)
        {
            try
            {
                var dailyLog = await _context.DailyLogs.FirstOrDefaultAsync(d => d.LogId == LogId);
                if (dailyLog == null)
                {
                    throw new ArgumentException("Consumption Log not found");
                }
                dailyLog.Quantity = quantity;
                await _context.SaveChangesAsync();
                return dailyLog;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Consumption Log not found", ex.Message);
            }
        }
    }
}
