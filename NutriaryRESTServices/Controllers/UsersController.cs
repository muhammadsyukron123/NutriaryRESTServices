using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Domain;
using NutriaryRESTServices.Helpers;
using NutriaryRESTServices.ViewModels;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace NutriaryRESTServices.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUserBLL _userBLL;
        private AppSettings _appSettings;

        public UsersController(IUserBLL userBLL, IOptions<AppSettings> appSettings)
        {
            _userBLL = userBLL;
            _appSettings = appSettings.Value;
        }

        [Authorize]
        [HttpGet("GetUserByUsername")]
        public async Task<IActionResult> GetUserByUsername(string Username)
        {
            try
            {
                var userNameClaim = User.FindFirst(ClaimTypes.Name);
                if (userNameClaim == null && userNameClaim.Value != Username.ToString())

                {
                    return Forbid();
                }
                var result = await _userBLL.GetUserByUsername(Username);
                if (result == null)
                {
                    return NotFound();
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpGet("GetWithProfile")]
        public async Task<IActionResult> GetUserWithProfile(int UserId)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null && userIdClaim.Value != UserId.ToString())

                {
                    return Forbid();
                }
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
                var result = await _userBLL.Login(userDTO.Username, userDTO.Password);
                if (result == null)
                {
                    return NotFound();
                }
                List<Claim> claims = new List<Claim>();
                claims.Add(new Claim(ClaimTypes.Name, result.Username));
                claims.Add(new Claim(ClaimTypes.NameIdentifier, result.UserId.ToString()));
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(claims),
                    Expires = DateTime.UtcNow.AddHours(1),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                var userWithToken = new UserWithToken
                {
                    UserId = result.UserId,
                    Username = result.Username,
                    FirstName = result.Firstname,
                    LastName = result.Lastname,
                    Token = tokenHandler.WriteToken(token)
                };
                return Ok(userWithToken);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpPost("Register")]
        public async Task<IActionResult> Register(UserCreateDTO userDTO)
        {
            try
            {
                var result = await _userBLL.InsertUser(userDTO);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpPut("UpdateUser")]
        public async Task<IActionResult> UpdateUser(UserDTO userDTO)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null && userIdClaim.Value != userDTO.UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _userBLL.UpdateUser(userDTO);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [Authorize]
        [HttpGet("GetUserById")]
        public async Task<IActionResult> GetUserById(int UserId)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null && userIdClaim.Value != UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _userBLL.GetUserById(UserId);
                if (result == null)
                {
                    return NotFound();
                }
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
