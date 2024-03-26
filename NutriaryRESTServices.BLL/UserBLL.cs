using AutoMapper;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Data.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL
{
    public class UserBLL : IUserBLL
    {
        private readonly IUser _userData;
        private readonly IMapper _mapper;

        public UserBLL(IUser userData, IMapper mapper)
        {
            _userData = userData;
            _mapper = mapper;
        }
        public async Task<UserDTO> GetUserByUsername(string Username)
        {
            var user = await _userData.GetUserByUsername(Username);
            return _mapper.Map<UserDTO>(user);
        }

        public async Task<UserWithProfileDTO> GetUserWithProfile(int UserId)
        {
            var user = await _userData.GetUserWithProfile(UserId);

            return _mapper.Map<UserWithProfileDTO>(user);
        }

        public async Task<UserDTO> Login(string Username, string Password)
        {
            var user = await _userData.Login(Username, Password);
            return _mapper.Map<UserDTO>(user);
        }
    }
}
