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
    public class UserProfileBLL : IUserProfileBLL
    {
        private readonly IUserProfile _userProfile;
        private readonly IMapper _mapper;

        public UserProfileBLL(IUserProfile userProfile, IMapper mapper)
        {
            _userProfile = userProfile;
            _mapper = mapper;
        }
        public Task<bool> DeleteUserProfile(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<GetUserProfileDTO>> GetAllUserProfiles()
        {
            throw new NotImplementedException();
        }

        public async Task<GetUserProfileDTO> GetUserProfileById(int userId)
        {
            var userProfile = await _userProfile.GetUserProfileById(userId);
            return _mapper.Map<GetUserProfileDTO>(userProfile);
        }

        public async Task<Task> InsertUserProfile(UserProfileWithCalorieDTO userProfile)
        {
            var user = _mapper.Map<UserProfileWithCalorieInformation>(userProfile);
            var insertedUser = await _userProfile.InsertUserProfile(user);
            return _mapper.Map<Task>(insertedUser);
        }

        public async Task<Task> UpdateUserProfile(UserProfileWithCalorieDTO userProfile)
        {
            var user = _mapper.Map<UserProfileWithCalorieInformation>(userProfile);
            var updatedUser = await _userProfile.UpdateUserProfile(user);
            return _mapper.Map<Task>(updatedUser);
        }
    }
}
