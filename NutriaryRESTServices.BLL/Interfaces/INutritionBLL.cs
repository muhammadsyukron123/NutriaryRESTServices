using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Interfaces
{
    public interface INutritionBLL
    {
        public Task<IEnumerable<FoodNutritionInfoDTO>> GetAllFoodNutritionInfo();
        public Task<IEnumerable<FoodNutritionInfoDTO>> GetFoodByName(string foodName);
        public Task<FoodNutritionInfoDTO> GetFoodNutritionInfoById(string foodId);
        public Task<FoodNutritionInfoDTO> InsertFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO);
        public Task<FoodNutritionInfoDTO> UpdateFoodNutritionInfo(FoodNutritionInfoDTO foodNutritionInfoDTO);
        public Task<bool> DeleteFoodNutritionInfo(string foodId);
    }
}
