using Microsoft.AspNetCore.Authorization;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Helpers
{
    

    public class UserIdMatchRequirement : IAuthorizationRequirement
    {
    }

    public class UserIdMatchHandler : AuthorizationHandler<UserIdMatchRequirement>
    {
        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, UserIdMatchRequirement requirement)
        {
            if (context.User.HasClaim(c => c.Type == ClaimTypes.NameIdentifier))
            {
                var userIdClaim = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (!string.IsNullOrEmpty(userIdClaim))
                {
                    if (context.Resource is Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext mvcContext)
                    {
                        var routeUserId = mvcContext.HttpContext.Request.RouteValues["UserId"]?.ToString();
                        if (userIdClaim == routeUserId)
                        {
                            context.Succeed(requirement);
                        }
                    }
                }
            }

            return Task.CompletedTask;
        }
    }

}
