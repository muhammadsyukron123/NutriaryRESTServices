using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NutriaryRESTServices.Domain;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class UserWithProfileDTO
    {
        public int UserId { get; set; }
        public string Username { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Firstname { get; set; } = null!;
        public string Lastname { get; set; } = null!;
        public string Gender { get; set; } = null!;
        public int Age { get; set; }
        public decimal Height { get; set; }
        public decimal Weight { get; set; }
        public string ActivityName { get; set; }
        public string TargetGoal { get; set; }
        public decimal? Bmr { get; set; }
        //public string Gender { get; set; } = null!;
        //public int Age { get; set; }
        //public decimal Height { get; set; }
        //public decimal Weight { get; set; }
        //public int ActivityLevel { get; set; }
        //public int TargetGoal { get; set; }
        //public decimal? Bmr { get; set; }
    }
}
