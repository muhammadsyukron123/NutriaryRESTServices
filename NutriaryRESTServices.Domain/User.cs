using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

public partial class User
{
    [Key]
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("username")]
    [StringLength(50)]
    public string Username { get; set; } = null!;

    [Column("email")]
    [StringLength(100)]
    public string Email { get; set; } = null!;

    [Column("password")]
    [StringLength(100)]
    public string Password { get; set; } = null!;

    [Column("firstname")]
    [StringLength(100)]
    public string Firstname { get; set; } = null!;

    [Column("lastname")]
    [StringLength(100)]
    public string Lastname { get; set; } = null!;

    [InverseProperty("User")]
    public virtual ICollection<DailyLog> DailyLogs { get; set; } = new List<DailyLog>();

    [InverseProperty("User")]
    public virtual ICollection<UserCalorieInformation> UserCalorieInformations { get; set; } = new List<UserCalorieInformation>();

    [InverseProperty("User")]
    public virtual ICollection<UserDiary> UserDiaries { get; set; } = new List<UserDiary>();

    [InverseProperty("User")]
    public virtual ICollection<UserProfile> UserProfiles { get; set; } = new List<UserProfile>();
}
