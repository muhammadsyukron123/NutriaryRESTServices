using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Data.Models
{
    public class CalorieSummary
    {
        public int? user_id { get; set; }
        public DateTime? log_date { get; set; }
        public decimal? BMR { get; set; }
        public decimal? consumed_calories { get; set; }
        public decimal? remaining_calories { get; set; }
    }
}
