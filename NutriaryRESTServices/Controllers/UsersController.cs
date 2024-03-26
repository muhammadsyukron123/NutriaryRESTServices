using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;

namespace NutriaryRESTServices.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUserBLL _userBLL;

        public UsersController(IUserBLL userBLL)
        {
            _userBLL = userBLL;
        }

        [HttpGet("GetUserByUsername")]
        public async Task<IActionResult> GetUserByUsername(string Username)
        {
            try
            {
                var user = await _userBLL.GetUserByUsername(Username);
                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("GetWithProfile")]
        public async Task<IActionResult> GetUserWithProfile(int UserId)
        {
            try
            {
                var user = await _userBLL.GetUserWithProfile(UserId);
                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpPost("Login")]     
        public async Task<IActionResult> Login(UserLoginDTO userDTO)
        {
            try
            {
                var user = await _userBLL.Login(userDTO.Username, userDTO.Password);
                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
