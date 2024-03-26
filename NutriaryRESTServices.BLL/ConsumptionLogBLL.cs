using AutoMapper;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Data.Interfaces;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL
{
    public class ConsumptionLogBLL : IConsumptionLogBLL
    {
        private readonly IConsumptionLog _consumptionLogDAL;
        private readonly IMapper _mapper;
        public ConsumptionLogBLL(IConsumptionLog consumptionLog, IMapper mapper)
        {
            
            _consumptionLogDAL = consumptionLog;
            _mapper = mapper;

        }

        public async Task<bool> DeleteConsumptionLog(int logId)
        {
           var deleted = await _consumptionLogDAL.DeleteConsumptionLog(logId);
            return deleted;
        }

        public async Task<IEnumerable<DailyLogDetailsDTO>> GetAllConsumptionLogsById(int userId, DateTime logDate)
        {
            var logs = await _consumptionLogDAL.GetAllConsumptionLogsById(userId, logDate);
            return _mapper.Map<IEnumerable<DailyLogDetailsDTO>>(logs);
        }

        public async Task<DailyLogDetailsDTO> GetConsumptionDetailById(int logId)
        {
            var log = await _consumptionLogDAL.GetConsumptionDetailById(logId);
            return _mapper.Map<DailyLogDetailsDTO>(log);
        }

        public async Task<DailyLogDTO> InsertConsumptionLog(DailyLogDTO daily)
        {
            var log = await _consumptionLogDAL.InsertConsumptionLog(_mapper.Map<DailyLog>(daily));
            return _mapper.Map<DailyLogDTO>(log);
        }

        public async Task<DailyLogDTO> UpdateConsumptionQuantity(int logId, decimal quantity)
        {
            var log = await _consumptionLogDAL.UpdateConsumptionQuantity(logId, quantity);
            return _mapper.Map<DailyLogDTO>(log);
        }
    }
}
