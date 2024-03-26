using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Interfaces
{
    public interface IUserProfile
    {
        public Task<IEnumerable<UserProfile>> GetAllUserProfiles();
        public Task<UserProfile> GetUserProfileById(int userId);
        public Task<Task> InsertUserProfile(UserProfileWithCalorieInformation userProfile);
        public Task<Task> UpdateUserProfile(UserProfileWithCalorieInformation userProfile);
        public Task<bool> DeleteUserProfile(int userId);
    }
}
