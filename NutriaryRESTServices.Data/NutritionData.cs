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
    public class NutritionData : INutrition
    {
        private readonly AppDbContext _context;

        public NutritionData(AppDbContext appDbContext)
        {
            _context = appDbContext;
        }
        public Task<bool> DeleteFoodNutritionInfo(string foodId)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<FoodNutritionInfo>> GetAllFoodNutritionInfo()
        {
            try
            {
                var foodNutritionInfo = await _context.FoodNutritionInfos.ToListAsync();
                return foodNutritionInfo;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Food Nutrition Info not found", ex.Message);
            }
        }

        public async Task<IEnumerable<FoodNutritionInfo>> GetFoodByName(string foodName)
        {
            try
            {
                var foodNutritionInfo = await _context.FoodNutritionInfos.Where(f => f.FoodName == foodName).ToListAsync();
                return foodNutritionInfo;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Food Nutrition Info not found", ex.Message);
            }
        }

        public async Task<FoodNutritionInfo> GetFoodNutritionInfoById(string foodId)
        {
            try
            {
                var foodNutritionInfo = await _context.FoodNutritionInfos.FirstOrDefaultAsync(f => f.FoodId == foodId);
                if (foodNutritionInfo == null)
                {
                    throw new ArgumentException("Food Nutrition Info not found");
                }
                return foodNutritionInfo;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Food Nutrition Info not found", ex.Message);
            }
        }

        public async Task<FoodNutritionInfo> InsertFoodNutritionInfo(FoodNutritionInfo foodNutritionInfo)
        {
            try
            {
                _context.FoodNutritionInfos.Add(foodNutritionInfo);
                await _context.SaveChangesAsync();
                return foodNutritionInfo;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Food Nutrition Info not found", ex.Message);
            }
        }

        public async Task<FoodNutritionInfo> UpdateFoodNutritionInfo(FoodNutritionInfo foodNutritionInfo)
        {
            try
            {
                _context.FoodNutritionInfos.Update(foodNutritionInfo);
                await _context.SaveChangesAsync();
                return foodNutritionInfo;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Food Nutrition Info not found", ex.Message);
            }
        }
    }
}
