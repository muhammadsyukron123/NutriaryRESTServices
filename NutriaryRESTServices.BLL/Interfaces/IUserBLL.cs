using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Interfaces
{
    public interface IUserBLL
    {
        public Task<UserDTO> Login(string Username, string Password);
        public Task<UserDTO> GetUserByUsername(string Username);
        public Task<UserWithProfileDTO> GetUserWithProfile(int UserId);
        public Task<UserDTO> GetUserById(int userId);
        public Task<UserDTO> InsertUser(UserCreateDTO userCreateDTO);
        public Task<UserDTO> UpdateUser(UserDTO userDTO);

    }
}
