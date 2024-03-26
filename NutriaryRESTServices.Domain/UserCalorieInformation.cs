using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

[Table("UserCalorieInformation")]
public partial class UserCalorieInformation
{
    [Key]
    [Column("calorie_info_id")]
    public int CalorieInfoId { get; set; }

    [Column("user_id")]
    public int UserId { get; set; }

    [Column("activity_level_id")]
    public int ActivityLevelId { get; set; }

    [Column("target_goal_id")]
    public int TargetGoalId { get; set; }

    [Column("bmr", TypeName = "decimal(10, 2)")]
    public decimal? Bmr { get; set; }

    [ForeignKey("ActivityLevelId")]
    [InverseProperty("UserCalorieInformations")]
    public virtual ActivityLevel ActivityLevel { get; set; } = null!;

    [ForeignKey("TargetGoalId")]
    [InverseProperty("UserCalorieInformations")]
    public virtual TargetGoal TargetGoal { get; set; } = null!;

    [ForeignKey("UserId")]
    [InverseProperty("UserCalorieInformations")]
    public virtual User User { get; set; } = null!;
}
