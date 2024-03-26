using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.Domain
{
    public class TotalNutritionReport
    {
        public int UserId { get; set; }
        public DateTime LogDate { get; set; }
        public decimal TotalEnergyKal { get; set; }
        public decimal TotalProteinG { get; set; }
        public decimal TotalFatG { get; set; }
        public decimal TotalCarbsG { get; set; }
        public decimal TotalFiberG { get; set; }
        public decimal TotalCalciumMg { get; set; }
        public decimal TotalFeMg { get; set; }
        public decimal TotalNatriumMg { get; set; }
        public decimal TotalBmr { get; set; }
        public decimal RemainingBmr { get; set; }
    }
}
