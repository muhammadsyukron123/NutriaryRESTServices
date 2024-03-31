
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Interfaces
{
    public interface IUser
    {
        public Task<IEnumerable<User>> GetAllUsers();
        public Task<User> GetUserById(int userId);
        public Task<User> GetUserByUsername(string username);
        public Task<User> InsertUser(User user);
        public Task<User> UpdateUser(User user);
        public Task<bool> ChangePassword(int userId, string oldPassword, string newPassword, string confirmPassword);
        public Task<bool> DeleteUser(int userId);
        public Task<UserWithProfile> GetUserWithProfile(int userId);
        public Task<User> Login(string username, string password);

    }
}
