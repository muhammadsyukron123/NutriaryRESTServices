using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.DTOs
{
    public class ConsumptionLogUpdateDTO
    {
        public int LogId { get; set; }
        public decimal Quantity { get; set; }
    }
}
