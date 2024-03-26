using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Domain
{
    public class UserProfileWithCalorieInformation
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
