using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

public partial class TargetGoal
{
    [Key]
    [Column("goal_id")]
    public int GoalId { get; set; }

    [Column("goal_name")]
    [StringLength(50)]
    public string GoalName { get; set; } = null!;

    [Column("calorie_adjustment")]
    public int CalorieAdjustment { get; set; }

    [InverseProperty("TargetGoal")]
    public virtual ICollection<UserCalorieInformation> UserCalorieInformations { get; set; } = new List<UserCalorieInformation>();
}
