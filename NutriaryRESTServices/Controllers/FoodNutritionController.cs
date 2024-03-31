using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Helpers;

namespace NutriaryRESTServices.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class FoodNutritionController : ControllerBase
    {
        private readonly INutritionBLL _nutritionBLL;

        public FoodNutritionController(INutritionBLL nutritionBLL)
        {
            _nutritionBLL = nutritionBLL;
        }

        [HttpGet("GetAllFoodNutritionInfo")]
        public async Task<IActionResult> GetAllFoodNutritionInfo()
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.GetAllFoodNutritionInfo();
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetFoodByName")]
        public async Task<IActionResult> GetFoodByName(string foodName)
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.GetFoodByName(foodName);
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetFoodNutritionInfoById")]
        public async Task<IActionResult> GetFoodNutritionInfoById(string foodId)
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.GetFoodNutritionInfoById(foodId);
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
        [Authorize]
        [HttpPost("InsertFoodNutritionInfo")]
        public async Task<IActionResult> InsertFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO)
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.InsertFoodNutritionInfo(foodNutritionInfoDTO);
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
        [Authorize]
        [HttpPut("UpdateFoodNutritionInfo")]
        public async Task<IActionResult> UpdateFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO)
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.UpdateFoodNutritionInfo(foodNutritionInfoDTO);
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
        [Authorize]
        [HttpDelete("DeleteFoodNutritionInfo")]
        public async Task<IActionResult> DeleteFoodNutritionInfo(string foodId)
        {
            try
            {
                var foodNutritionInfo = await _nutritionBLL.DeleteFoodNutritionInfo(foodId);
                return Ok(foodNutritionInfo);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
