using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Interfaces
{
    public interface IUserProfileBLL
    {
        public Task<IEnumerable<GetUserProfileDTO>> GetAllUserProfiles();
        public Task<GetUserProfileDTO> GetUserProfileById(int userId);
        public Task<Task> InsertUserProfile(UserProfileWithCalorieDTO userProfile);
        public Task<Task> UpdateUserProfile(UserProfileWithCalorieDTO userProfile);
        public Task<bool> DeleteUserProfile(int userId);
    }
}
