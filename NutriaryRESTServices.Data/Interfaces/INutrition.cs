
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Interfaces
{
    public interface INutrition 
    {
        public Task<IEnumerable<FoodNutritionInfo>> GetAllFoodNutritionInfo();
        public Task<IEnumerable<FoodNutritionInfo>> GetFoodByName(string foodName);
        public Task<FoodNutritionInfo> GetFoodNutritionInfoById(string foodId);
        public Task<FoodNutritionInfo> InsertFoodNutritionInfo(FoodNutritionInfo foodNutritionInfo);
        public Task<FoodNutritionInfo> UpdateFoodNutritionInfo(FoodNutritionInfo foodNutritionInfo);
        public Task<bool> DeleteFoodNutritionInfo(string foodId);

    }
}
