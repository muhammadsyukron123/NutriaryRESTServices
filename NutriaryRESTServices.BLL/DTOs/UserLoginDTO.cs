using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class UserLoginDTO
    {
        public string Username { get; set; } = null!;
        public string Password { get; set; } = null!;
    }
}
