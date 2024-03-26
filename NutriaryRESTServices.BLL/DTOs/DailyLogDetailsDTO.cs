using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class DailyLogDetailsDTO
    {
        public int UserId { get; set; }
        public string FoodId { get; set; } = null!;
        public int LogId { get; set; }
        public decimal Quantity { get; set; }
        public DateOnly LogDate { get; set; }
        public string FoodName { get; set; } = null!;
        public decimal EnergyKal { get; set; }
        public decimal ProteinG { get; set; }
        public decimal FatG { get; set; }
        public decimal CarbsG { get; set; }
        public decimal FiberG { get; set; }
        public decimal CalciumMg { get; set; }
        public decimal FeMg { get; set; }
        public decimal NatriumMg { get; set; }
    }
}
