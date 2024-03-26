using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Domain
{
    public class UserWithProfile
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
    }
}
