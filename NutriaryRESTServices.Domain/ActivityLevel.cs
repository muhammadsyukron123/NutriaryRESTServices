using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

public partial class ActivityLevel
{
    [Key]
    [Column("activity_id")]
    public int ActivityId { get; set; }

    [Column("activity_name")]
    [StringLength(50)]
    public string ActivityName { get; set; } = null!;

    [Column("activity_multiplier", TypeName = "decimal(5, 2)")]
    public decimal ActivityMultiplier { get; set; }

    [InverseProperty("ActivityLevel")]
    public virtual ICollection<UserCalorieInformation> UserCalorieInformations { get; set; } = new List<UserCalorieInformation>();
}
