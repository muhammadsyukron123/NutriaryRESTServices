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
    public class FoodNutritionBLL : INutritionBLL
    {
        private readonly INutrition _nutritionBLL;
        private readonly IMapper _mapper;
        public FoodNutritionBLL(INutrition nutrition, IMapper mapper)
        {
            _nutritionBLL = nutrition;
            _mapper = mapper;
            
        }
        public async Task<bool> DeleteFoodNutritionInfo(string foodId)
        {
            return await _nutritionBLL.DeleteFoodNutritionInfo(foodId);
        }

        public async Task<IEnumerable<FoodNutritionInfoDTO>> GetAllFoodNutritionInfo()
        {
            var foodNutritionInfo = await _nutritionBLL.GetAllFoodNutritionInfo();
            return _mapper.Map<IEnumerable<FoodNutritionInfoDTO>>(foodNutritionInfo);
        }

        public async Task<IEnumerable<FoodNutritionInfoDTO>> GetFoodByName(string foodName)
        {
            var foodNutritionInfo = await _nutritionBLL.GetFoodByName(foodName);
            return _mapper.Map<IEnumerable<FoodNutritionInfoDTO>>(foodNutritionInfo);
        }

        public async Task<FoodNutritionInfoDTO> GetFoodNutritionInfoById(string foodId)
        {
            var foodNutritionInfo = await _nutritionBLL.GetFoodNutritionInfoById(foodId);
            return _mapper.Map<FoodNutritionInfoDTO>(foodNutritionInfo);
        }

        public async Task<FoodNutritionInfoDTO> InsertFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO)
        {
            var foodNutritionInfo = _mapper.Map<FoodNutritionInfo>(foodNutritionInfoDTO);
            var result = await _nutritionBLL.InsertFoodNutritionInfo(foodNutritionInfo);
            return _mapper.Map<FoodNutritionInfoDTO>(result);
        }

        public async Task<FoodNutritionInfoDTO> UpdateFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO)
        {
            var foodNutritionInfo = _mapper.Map<FoodNutritionInfo>(foodNutritionInfoDTO);
            var result = await _nutritionBLL.UpdateFoodNutritionInfo(foodNutritionInfo);
            return _mapper.Map<FoodNutritionInfoDTO>(result);
        }
    }
}
