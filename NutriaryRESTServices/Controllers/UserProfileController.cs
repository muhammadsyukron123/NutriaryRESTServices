using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Domain;
using System.Security.Claims;

namespace NutriaryRESTServices.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserProfileController : ControllerBase
    {
        private readonly IUserProfileBLL _userProfileBLL;

        public UserProfileController(IUserProfileBLL userProfileBLL)
        {
            _userProfileBLL = userProfileBLL;
        }

        [Authorize]
        [HttpGet("GetUserProfile")]
        public async Task<IActionResult> GetUserProfile(int UserId)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || userIdClaim.Value != UserId.ToString())

            {
                return Forbid();
            }
            try
            {
                
                var result = await _userProfileBLL.GetUserProfileById(UserId);
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

        [HttpPost("UpdateUserProfile")]
        public async Task<IActionResult> UpdateUserProfile(UserProfileWithCalorieDTO userProfile)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != userProfile.UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _userProfileBLL.UpdateUserProfile(userProfile);
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

        [HttpPost("InsertUserProfile")]
        public async Task<IActionResult> InsertUserProfile(UserProfileWithCalorieDTO userProfile)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || userIdClaim.Value != userProfile.UserId.ToString())

                {
                    return Forbid();
                }
                var result = await _userProfileBLL.InsertUserProfile(userProfile);
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
