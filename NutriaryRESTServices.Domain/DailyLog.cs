using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

public partial class DailyLog
{
    [Key]
    [Column("log_id")]
    public int LogId { get; set; }

    [Column("user_id")]
    public int UserId { get; set; }

    [Column("food_id")]
    [StringLength(50)]
    public string FoodId { get; set; } = null!;

    [Column("quantity", TypeName = "decimal(5, 2)")]
    public decimal Quantity { get; set; }

    [Column("log_date")]
    public DateTime LogDate { get; set; }

    [ForeignKey("FoodId")]
    [InverseProperty("DailyLogs")]
    public virtual FoodNutritionInfo Food { get; set; } = null!;

    [ForeignKey("UserId")]
    [InverseProperty("DailyLogs")]
    public virtual User User { get; set; } = null!;
}
