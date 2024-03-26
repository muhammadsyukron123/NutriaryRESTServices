using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class UserCalorieInformationDTO
    {
        public int ActivityLevelId { get; set; }
        public int TargetGoalId { get; set; }
        public decimal? Bmr { get; set; }
    }
}
