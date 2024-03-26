using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Interfaces
{
    public interface IConsumptionLogBLL
    {
        public Task<IEnumerable<DailyLogDetailsDTO>> GetAllConsumptionLogsById(int userId, DateTime logDate);
        public Task<DailyLogDetailsDTO> GetConsumptionDetailById(int logId);
        public Task<DailyLogDTO> InsertConsumptionLog(DailyLogDTO daily);
        public Task<DailyLogDTO> UpdateConsumptionQuantity(int logId, decimal quantity);
        public Task<bool> DeleteConsumptionLog(int logId);
    }
}
