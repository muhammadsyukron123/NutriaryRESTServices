using Microsoft.Data.SqlClient;
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
    public class UserData : IUser
    {
        private AppDbContext _context;

        public UserData(AppDbContext appDbContext)
        {
            _context = appDbContext;
        }
        public Task<bool> DeleteUser(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<User>> GetAllUsers()
        {
            throw new NotImplementedException();
        }

        public async Task<User> GetUserById(int userId)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
                if (user == null)
                {
                    throw new ArgumentException("User not found");
                }
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User not found", ex.Message);
            }
        }

        public async Task<User> GetUserByUsername(string username)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
                if (user == null)
                {
                    throw new ArgumentException("User not found");
                }
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User not found", ex.Message);
            }
        }

        public async Task<UserWithProfile> GetUserWithProfile(int userId)
        {
            try
            {
                var userQuery = from u in _context.Users
                                join up in _context.UserProfiles on u.UserId equals up.UserId
                                join uci in _context.UserCalorieInformations on u.UserId equals uci.UserId
                                join a in _context.ActivityLevels on uci.ActivityLevelId equals a.ActivityId
                                join tg in _context.TargetGoals on uci.TargetGoalId equals tg.GoalId
                                where u.UserId == userId
                                select new UserWithProfile
                                {
                                    UserId = u.UserId,
                                    Username = u.Username,
                                    Email = u.Email,
                                    Firstname = u.Firstname,
                                    Lastname = u.Lastname,
                                    Gender = up.Gender,
                                    Age = up.Age,
                                    Height = up.Height,
                                    Weight = up.Weight,
                                    ActivityName = a.ActivityName,
                                    TargetGoal = tg.GoalName,
                                    Bmr = uci.Bmr
                                };


                var user = await userQuery
                    .FirstOrDefaultAsync(u => u.UserId == userId);

                if (user == null)
                {
                    throw new ArgumentException("User not found");
                }
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User not found", ex.Message);
            }
        }

        public async Task<User> InsertUser(User users)
        {
            try
            {
                
                var parameter = new SqlParameter[]
                {
                    new SqlParameter("@username", users.Username),
                    new SqlParameter("@email", users.Email),
                    new SqlParameter("@password", users.Password),
                    new SqlParameter("@firstname", users.Firstname),
                    new SqlParameter("@lastname", users.Lastname)
                };
                var register = await _context.Database.ExecuteSqlRawAsync("EXEC usp_RegisterUser @username, @email, @password, @firstname, @lastname", parameter);

                var user = new User
                {
                    Username = users.Username,
                    Email = users.Email,
                    Password = users.Password,
                    Firstname = users.Firstname,
                    Lastname = users.Lastname
                };
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User not found", ex.Message);
            }
        }

        public async Task<User> Login(string username, string password)
        {
            try
            {
                var parameter = new SqlParameter[]
                {
                    new SqlParameter("@username", username),
                    new SqlParameter("@password", password)
                };
                var login = await _context.Database.ExecuteSqlRawAsync("EXEC usp_LoginUser @username, @password", parameter);
                if (login == 0)
                {
                    throw new ArgumentException("Invalid username or password");
                }
                var user = await GetUserByUsername(username);
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Invalid username or password", ex.Message);
            }
        }

        public async Task<User> UpdateUser(User user)
        {
            try
            {
                _context.Users.Update(user);
                await _context.SaveChangesAsync();
                return user;
            }
            catch (Exception ex)
            {
                throw new ArgumentException("User not found", ex.Message);
            }
        }
    }
}
