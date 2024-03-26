using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class UserProfileWithCalorieDTO
    {
        public int UserId { get; set; }
        public string Gender { get; set; } = null!;
        public int Age { get; set; }
        public decimal Height { get; set; }
        public decimal Weight { get; set; }
        public int ActivityLevelId { get; set; }
        public int TargetGoalId { get; set; }
    }
}
