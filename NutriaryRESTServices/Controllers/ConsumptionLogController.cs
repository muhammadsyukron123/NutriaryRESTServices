using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Domain;
using NutriaryRESTServices.Helpers;
using System.Security.Claims;

namespace NutriaryRESTServices.Controllers
{
    
    [Route("api/[controller]")]
    [ApiController]
    public class ConsumptionLogController : ControllerBase
    {
        private readonly IConsumptionLogBLL _consumptionLogBLL;

        public ConsumptionLogController(IConsumptionLogBLL consumptionLogBLL)
        {
            _consumptionLogBLL = consumptionLogBLL;
        }

        [Authorize]
        [HttpGet("GetAllConsumptionLogsById")]
        public async Task<IActionResult> GetAllConsumptionLogsById(int UserId, DateTime LogDate)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

            {
                return Forbid();
            }
            try
            {
                
                var logs = await _consumptionLogBLL.GetAllConsumptionLogsById(UserId, LogDate);
                return Ok(logs);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpDelete("DeleteConsumptionLog")]
        public async Task<IActionResult> DeleteConsumptionLog(int LogId)
        {
            try
            {
                var result = await _consumptionLogBLL.DeleteConsumptionLog(LogId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpPost("InsertConsumptionLog")]
        public async Task<IActionResult> InsertConsumptionLog(DailyLogDTO daily)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || userIdClaim.Value != daily.UserId.ToString())

            {
                return Forbid();
            }
            try
            {
                var result = await _consumptionLogBLL.InsertConsumptionLog(daily);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpPut("UpdateConsumptionQuantity")]
        public async Task<IActionResult> UpdateConsumptionQuantity(ConsumptionLogUpdateDTO consumptionLogUpdateDTO)
        {
            try
            {
                var result = await _consumptionLogBLL.UpdateConsumptionQuantity(consumptionLogUpdateDTO.LogId, consumptionLogUpdateDTO.Quantity);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
