using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Helpers;
using System.Security.Claims;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NutriaryRESTServices.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class NutritionReportController : ControllerBase
    {
        private readonly IConsumptionReportBLL _consumptionReportBLL;

        public NutritionReportController(IConsumptionReportBLL consumptionReportBLL)
        {
            _consumptionReportBLL = consumptionReportBLL;
        }

        [HttpGet("GetTodayConsumptionReport")]
        public async Task<IActionResult> GetTodayConsumptionReport(int UserId)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

                {        
                    return Forbid();
                }

                var result = await _consumptionReportBLL.GetTotalNutritionToday(UserId);
                if (result == null)
                {
                    return NotFound("You haven't eaten anything today");
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetConsumptionReportByDate")] 
        public async Task<IActionResult> GetConsumptionReportByDate(int UserId, DateTime LogDate)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _consumptionReportBLL.GetTotalNutritionByDate(UserId, LogDate);
                if (result == null)
                {
                    return NotFound("You haven't eaten anything today");
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetTodayCalorieSummary")]
        public async Task<IActionResult> GetTodayCalorieSummary(int UserId)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _consumptionReportBLL.GetCalorieSummaryToday(UserId);
                if (result == null)
                {
                    return NotFound("You haven't eaten anything today");
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetCalorieSummaryByDate")]
        public async Task<IActionResult> GetCalorieSummaryByDate(int UserId, DateTime LogDate)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _consumptionReportBLL.GetCalorieSummaryByDate(UserId, LogDate);
                if (result == null)
                {
                    return NotFound("You haven't eaten anything today");
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
