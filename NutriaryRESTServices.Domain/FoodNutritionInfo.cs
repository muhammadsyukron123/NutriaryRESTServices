using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

[Table("FoodNutritionInfo")]
public partial class FoodNutritionInfo
{
    [Key]
    [Column("food_id")]
    [StringLength(50)]
    public string FoodId { get; set; } = null!;

    [Column("food_name")]
    [StringLength(50)]
    public string FoodName { get; set; } = null!;

    [Column("energy_kal", TypeName = "decimal(5, 2)")]
    public decimal EnergyKal { get; set; }

    [Column("protein_g", TypeName = "decimal(5, 2)")]
    public decimal ProteinG { get; set; }

    [Column("fat_g", TypeName = "decimal(5, 2)")]
    public decimal FatG { get; set; }

    [Column("carbs_g", TypeName = "decimal(5, 2)")]
    public decimal CarbsG { get; set; }

    [Column("fiber_g", TypeName = "decimal(5, 2)")]
    public decimal FiberG { get; set; }

    [Column("calcium_mg", TypeName = "decimal(5, 2)")]
    public decimal CalciumMg { get; set; }

    [Column("fe_mg", TypeName = "decimal(5, 2)")]
    public decimal FeMg { get; set; }

    [Column("natrium_mg", TypeName = "decimal(5, 2)")]
    public decimal NatriumMg { get; set; }

    [InverseProperty("Food")]
    public virtual ICollection<DailyLog> DailyLogs { get; set; } = new List<DailyLog>();
}
