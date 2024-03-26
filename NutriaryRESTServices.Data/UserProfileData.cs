using Azure;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NutriaryRESTServices.Data.Interfaces;
using NutriaryRESTServices.Domain;
using NutriaryRESTServices.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data
{
    public class UserProfileData : IUserProfile
    {
        private readonly AppDbContext _context;

        public UserProfileData(AppDbContext appDbContext) 
        {
            _context = appDbContext;    
        }
        public Task<bool> DeleteUserProfile(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<UserProfile>> GetAllUserProfiles()
        {
            throw new NotImplementedException();
        }

        public async Task<UserProfile> GetUserProfileById(int userId)
        {
            try
            {
                var userProfile = await _context.UserProfiles.FirstOrDefaultAsync(u => u.UserId == userId);
                if (userProfile == null)
                {
                    throw new ArgumentException("User Profile not found");
                }
                return userProfile;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User Profile not found", ex.Message);
            }
        }

        public async Task<Task> InsertUserProfile(UserProfileWithCalorieInformation userProfile)
        {
            try
            {

                var userProfileParam = new SqlParameter[]
                {
                     new SqlParameter("@user_id", userProfile.UserId),
                     new SqlParameter("@gender", userProfile.Gender),
                     new SqlParameter("@age", userProfile.Age),
                     new SqlParameter("@height", userProfile.Height),
                     new SqlParameter("@weight", userProfile.Weight),
                     new SqlParameter("@activity_level_id", userProfile.ActivityLevelId),
                     new SqlParameter("@target_goal_id", userProfile.TargetGoalId)
                };

                await _context.Database.ExecuteSqlRawAsync("EXECUTE usp_InsertUserProfile @user_id, @gender, @age, @height, @weight, @activity_level_id, @target_goal_id", userProfileParam);

                return Task.CompletedTask;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User Profile not found", ex.Message);
            }
        }

        public async Task<Task> UpdateUserProfile(UserProfileWithCalorieInformation userProfile)
        {
            try
            {
                var userProfileParam = new SqlParameter[]
                {
                     new SqlParameter("@user_id", userProfile.UserId),
                     new SqlParameter("@gender", userProfile.Gender),
                     new SqlParameter("@age", userProfile.Age),
                     new SqlParameter("@height", userProfile.Height),
                     new SqlParameter("@weight", userProfile.Weight),
                     new SqlParameter("@activity_level_id", userProfile.ActivityLevelId),
                     new SqlParameter("@target_goal_id", userProfile.TargetGoalId)
                };

                await _context.Database.ExecuteSqlRawAsync("EXECUTE usp_InsertUserProfile @user_id, @gender, @age, @height, @weight, @activity_level_id, @target_goal_id", userProfileParam);

                return Task.CompletedTask;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User Profile not found", ex.Message);
            }
        }
    }
}
