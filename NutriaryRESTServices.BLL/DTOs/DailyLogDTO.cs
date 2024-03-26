using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class DailyLogDTO
    {
        public int LogId { get; set; }
        public int UserId { get; set; }
        public string FoodId { get; set; } = null!;
        public decimal Quantity { get; set; }
        public DateTime LogDate { get; set; }
    }
}
