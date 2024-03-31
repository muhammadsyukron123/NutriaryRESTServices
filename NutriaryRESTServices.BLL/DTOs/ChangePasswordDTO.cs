using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class ChangePasswordDTO
    {
        public int UserId { get; set; }
        public string oldPassword { get; set; } = string.Empty;
        public string newPassword { get; set; } = string.Empty;
        public string confirmPassword { get; set; } = string.Empty;
    }
}
