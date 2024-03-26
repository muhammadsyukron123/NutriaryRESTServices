using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

[Table("UserProfile")]
public partial class UserProfile
{
    [Key]
    [Column("profile_id")]
    public int ProfileId { get; set; }

    [Column("user_id")]
    public int UserId { get; set; }

    [Column("gender")]
    [StringLength(10)]
    public string Gender { get; set; } = null!;

    [Column("age")]
    public int Age { get; set; }

    [Column("height", TypeName = "decimal(5, 2)")]
    public decimal Height { get; set; }

    [Column("weight", TypeName = "decimal(5, 2)")]
    public decimal Weight { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserProfiles")]
    public virtual User User { get; set; } = null!;
}
