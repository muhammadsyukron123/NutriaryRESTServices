using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Interfaces
{
    public interface IConsumptionLog
    {
        public Task<IEnumerable<DailyLogDetails>> GetAllConsumptionLogsById(int userId, DateTime logDate);
        public Task<DailyLogDetails> GetConsumptionDetailById(int logId);
        public Task<DailyLog> InsertConsumptionLog(DailyLog daily);
        public Task<DailyLog> UpdateConsumptionQuantity(int LogId, decimal quantity);
        public Task<bool> DeleteConsumptionLog(int logId);
    }
}
